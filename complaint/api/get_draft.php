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

$draft_id = trim($_GET["draft_id"] ?? "");
if (empty($draft_id) || !ctype_digit($draft_id)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Invalid draft id']);
    exit;
}

include '../connection.php';

$submitted_by = $_SESSION['employee_id'];

$sql = "SELECT * FROM feedback_complaint_data
        WHERE id = $1 AND submitted_by = $2 AND status = 'draft'";

$result = pg_query_params($conn, $sql, [$draft_id, $submitted_by]);

if (!$result || pg_num_rows($result) === 0) {
    http_response_code(404);
    echo json_encode(['success' => false, 'error' => 'Draft not found or no longer editable.']);
    pg_close($conn);
    exit;
}

$row = pg_fetch_assoc($result);
echo json_encode(['success' => true, 'data' => $row]);
pg_close($conn);