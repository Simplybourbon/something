<?php
require_once __DIR__ . '/../session_init.php';
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);

if (!isset($_SESSION['employee_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Unauthorized']);
    exit;
}

include '../connection.php';

$submitted_by = $_SESSION['employee_id'];

$sql = "SELECT id, form_no, operation, incident_description, drafted_at
        FROM feedback_complaint_data
        WHERE submitted_by = $1 AND status = 'draft'
        ORDER BY drafted_at DESC";

$result = pg_query_params($conn, $sql, [$submitted_by]);

if (!$result) {
    error_log("get_my_drafts error: " . pg_last_error($conn));
    echo json_encode(['success' => false, 'error' => 'Could not load drafts.']);
    pg_close($conn);
    exit;
}

$rows = pg_fetch_all($result) ?: [];
echo json_encode(['success' => true, 'data' => $rows]);
pg_close($conn);