<?php

require_once __DIR__ . '/../session_init.php';
if (!isset($_SESSION['employee_id']) && !isset($_SESSION['admin_id'])) {
    http_response_code(401);
    die("Unauthorized. Please log in.");
}
include '../connection.php';

$from = trim($_GET['from_date'] ?? '');
$to   = trim($_GET['to_date'] ?? '');

// ---- Validate dates ----
if (empty($from) || empty($to)) {
    die("Invalid date range.");
}

$from_dt = DateTime::createFromFormat('Y-m-d', $from);
$to_dt   = DateTime::createFromFormat('Y-m-d', $to);

if (!$from_dt || $from_dt->format('Y-m-d') !== $from ||
    !$to_dt   || $to_dt->format('Y-m-d')   !== $to) {
    die("Invalid date format.");
}

if ($from_dt > $to_dt) {
    die("From date cannot be after To date.");
}

// ---- Query using pg_query_params (SQL injection safe) ----
// Same column set as the View Submissions tab.
$sql = "SELECT id, form_no, submitted_by, Operation, Given_by, Date_of_submission,
        Depatment_section, Incident_description, Main_Error_category, Sub_Error_categor,
        avg_impact_score, avg_freq_score, avg_risk_score, patient_consequences,
        corrective_action, preventive_action, remarks
        FROM feedback_complaint_data
        WHERE Date_of_submission BETWEEN $1 AND $2
        ORDER BY Date_of_submission ASC";

$result = pg_query_params($conn, $sql, [$from, $to]);

if (!$result) {
    error_log("Export PDF query failed: " . pg_last_error($conn));
    die("Something went wrong. Please try again.");
}

$rows = pg_fetch_all($result) ?: [];

// Pull in any remark-thread replies too, same as the View Submissions tab,
// so the exported Remarks column matches what's shown on screen.
$ids = array_map(fn($r) => (int) $r['id'], $rows);
$repliesBySubmission = [];

if (!empty($ids)) {
    $idList = '{' . implode(',', $ids) . '}';
    $threadResult = pg_query_params(
        $conn,
        "SELECT submission_id, author, remark_text, created_at
         FROM remarks_thread
         WHERE submission_id = ANY($1::int[])
         ORDER BY created_at ASC",
        [$idList]
    );

    if ($threadResult) {
        foreach (pg_fetch_all($threadResult) ?: [] as $reply) {
            $repliesBySubmission[$reply['submission_id']][] = $reply;
        }
    } else {
        error_log("Remarks thread query error (PDF export): " . pg_last_error($conn));
    }
}

function buildRemarksText($row, $replies) {
    $parts = [];
    if (!empty($row['remarks'])) {
        $parts[] = $row['submitted_by'] . ' (original): ' . $row['remarks'];
    }
    foreach ($replies as $reply) {
        $when = date('d-M-Y', strtotime($reply['created_at']));
        $parts[] = $reply['author'] . ' (' . $when . '): ' . $reply['remark_text'];
    }
    return implode("\n", $parts);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback Report <?= htmlspecialchars($from) ?> to <?= htmlspecialchars($to) ?></title>
    <style>
        @page {
            size: landscape;
        }
        body {
            font-family: Arial, sans-serif;
            font-size: 10px;
            margin: 20px;
            color: #2d3748;
        }
        h2 {
            text-align: center;
            color: #1a365d;
            margin-bottom: 5px;
        }
        p.range {
            text-align: center;
            color: #4a5568;
            margin-bottom: 15px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: auto;
        }
        th {
            background-color: #2b6cb0;
            color: white;
            padding: 6px 9px;
            text-align: center;
            font-size: 9.5px;
        }
        td {
            border: 1px solid #cbd5e0;
            padding: 5px 6px;
            vertical-align: top;
            font-size: 9.5px;
            white-space: pre-wrap;
            word-break: break-word;
          
        }
        tr:nth-child(even) td {
            background-color: #f7fafc;
        }
        thead {
            display: table-header-group; /* repeat header row on every printed page */
        }
        tr {
            page-break-inside: avoid;
        }
        @media print {
            .no-print { display: none; }
        }
    </style>
</head>
<body>

<div class="no-print" style="text-align:center; margin-bottom:20px;">
    <button onclick="window.print()" style="padding:10px 30px; background:#2b6cb0; color:white; border:none; border-radius:5px; font-size:14px; cursor:pointer;">
        Print / Save as PDF
    </button>
</div>

<h2>Complaint & Feedback Report</h2>
<p class="range">Date Range: <?= htmlspecialchars($from) ?> to <?= htmlspecialchars($to) ?></p>

<table>
    <thead>
        <tr>
            <th>Form No.</th>
            <th>Submitted By</th>
            <th>Operation</th>
            <th>Given By</th>
            <th>Date</th>
            <th>Department / Section</th>
            <th>Incident Description</th>
            <th>Main Error Category</th>
            <th>Sub Error Category</th>
            <th>Impact</th>
            <th>Freq</th>
            <th>Risk</th>
            <th>Patient Consequences</th>
            <th>Corrective Action</th>
            <th>Preventive Action</th>
            <th>Remarks</th>
        </tr>
    </thead>
    <tbody>
    <?php foreach ($rows as $row): ?>
        <?php $replies = $repliesBySubmission[$row['id']] ?? []; ?>
        <tr>
            <td><?= htmlspecialchars($row['form_no'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['submitted_by'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['operation'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['given_by'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['date_of_submission'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['depatment_section'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['incident_description'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['main_error_category'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['sub_error_categor'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['avg_impact_score'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['avg_freq_score'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['avg_risk_score'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['patient_consequences'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['corrective_action'] ?? '') ?></td>
            <td><?= htmlspecialchars($row['preventive_action'] ?? '') ?></td>
            <td><?= nl2br(htmlspecialchars(buildRemarksText($row, $replies))) ?></td>
        </tr>
    <?php endforeach; ?>
    </tbody>
</table>

<?php if (empty($rows)): ?>
    <p style="text-align:center; color:#e53e3e;">No records found for the selected date range.</p>
<?php endif; ?>

<?php pg_close($conn); ?>
</body>
</html>