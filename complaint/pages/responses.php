<?php
require_once __DIR__ . '/../session_init.php';
require_once __DIR__ . '/../csrf.php';
if (!isset($_SESSION['employee_id'])) {
    header('Location: ../index.html');
    exit;
}
$__csrf_token = csrf_token();
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="<?php echo htmlspecialchars($__csrf_token); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Responses</title>
    <link rel="stylesheet" href="../style.css">
    <style>
        .remarks-cell {
            min-width: 180px;
            max-width: 260px;
            padding: 4px 6px !important;
        }

        .remarks-list {
            max-height: 62px;
            overflow-y: auto;
        }

        .remark-entry {
            padding: 4px 7px;
            border-radius: 5px;
            margin-bottom: 4px;
            font-size: 12.5px;
            line-height: 1.35;
            background: #f4f5f7;
            border: 1px solid #e2e5e9;
            color: #333;

            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: default;
        }

        .remark-entry .remark-meta {
            font-size: 10.5px;
            color: #8a8f98;
            font-weight: 600;
            margin-right: 5px;
        }

        .add-remark-btn {
            background: none;
            border: none;
            color: #2b6cb0;
            font-size: 11.5px;
            padding: 2px 4px;
            cursor: pointer;
        }

        .add-remark-btn:hover {
            text-decoration: underline;
        }

        .add-remark-form textarea {
            width: 100%;
            min-width: 200px;
            padding: 4px 6px;
            border: 2px solid #1a365d;
            border-radius: 4px;
            font-size: 13px;
            font-family: inherit;
            box-sizing: border-box;
            resize: vertical;
            margin-bottom: 4px;
        }

        .add-remark-form button {
            font-size: 12px;
            padding: 3px 10px;
            margin-right: 4px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
        }

        .add-remark-form .save-btn {
            background: #2b6cb0;
            color: white;
        }

        .add-remark-form .cancel-btn {
            background: #e2e8f0;
            color: #2d3748;
        }

        #remarks_save_status {
            font-size: 12px;
            margin-top: 6px;
            min-height: 16px;
        }

        #remarks_save_status.success {
            color: #2f7a3d;
        }

        #remarks_save_status.error {
            color: #c53030;
        }

        /* Global floating tooltip — shows the full remark text on hover,
           since the cell itself only shows a truncated single line. */
        #global-tooltip {
            visibility: hidden;
            opacity: 0;
            position: fixed;
            background: #1a202c;
            color: #f7fafc;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
            padding: 8px 12px;
            width: max-content;
            max-width: 280px;

            font-size: 12px;
            text-align: left;
            font-weight: normal;
            line-height: 1.45;
            white-space: pre-wrap;
            word-break: break-word;

            transition: opacity 0.12s ease;
            z-index: 9999;
            pointer-events: none;
        }

        #global-tooltip .tip-meta {
            display: block;
            font-size: 10.5px;
            color: #a0aec0;
            font-weight: 600;
            margin-bottom: 3px;
        }

        #global-tooltip.visible {
            visibility: visible;
            opacity: 1;
        }
    </style>
</head>

<body>
    <div class="container responses-container">
        <img src="../BBH-logo-1-1B.png" alt="" srcset="">
        <h1>Submitted Responses</h1>

        <div class="responses-top-bar">
            <a href="dashboard.php" class="dashboard-btn">← Back to Dashboard</a>
        </div>

        <div id="responses_status">Loading responses…</div>

        <div class="table-scroll">
            <table class="responses-table" id="responses_table" style="display:none;">
                <thead>
                    <tr>
                        <th>Form No.</th>
                        <th>Submitted By</th>
                        <th>Operation</th>
                        <th>Given By</th>
                        <th>Date</th>
                        <th>Department</th>
                        <th>Incident Description</th>
                        <th>Error Category</th>
                        <th>Sub Category</th>
                        <th>Avg Impact</th>
                        <th>Avg Freq</th>
                        <th>Avg Risk</th>
                        <th>Patient Consequences</th>
                        <th>Corrective Action</th>
                        <th>Preventive Action</th>
                        <th>Remarks</th>
                    </tr>
                </thead>
                <tbody id="responses_body"></tbody>
            </table>
        </div>
        <div id="remarks_save_status"></div>
    </div>

    <div id="global-tooltip"></div>

    <script src="../js/auth-guard.js"></script>
    <script src="../js/responses.js"></script>
</body>

</html>