<?php

require_once __DIR__ . '/../session_init.php';
error_reporting(E_ALL);
ini_set('display_errors', 0);
if (!isset($_SESSION['employee_id'])) {
    header('Content-Type: application/json');
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Unauthorized']);
    exit;
}
include '../connection.php';
header('Content-Type: application/json');

$sql = "SELECT id, form_no, submitted_by, Operation, Given_by, Date_of_submission, Depatment_section,
        Incident_description, Main_Error_category, Sub_Error_categor,
        avg_impact_score, avg_freq_score, avg_risk_score,
        root_cause, immediate_correction, corrective_action,
        preventive_action, patient_consequences, remarks
        FROM feedback_complaint_data
        WHERE status = 'submitted'
        ORDER BY id DESC";
$result = pg_query($conn, $sql);

if (!$result) {
    error_log("SQL Error: " . pg_last_error($conn));
    echo json_encode(['success' => false, 'error' => 'Could not load responses.']);
    pg_close($conn);
    exit;
}

$rows = pg_fetch_all($result) ?: [];

// Attach each submission's remark thread (append-only replies added after
// the original submission-time remark).
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
        error_log("Remarks thread query error: " . pg_last_error($conn));
    }
}

foreach ($rows as &$row) {
    $row['replies'] = $repliesBySubmission[$row['id']] ?? [];
}
unset($row);

echo json_encode(['success' => true, 'data' => $rows]);

pg_close($conn);