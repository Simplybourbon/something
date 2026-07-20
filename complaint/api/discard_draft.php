<?php
require_once __DIR__ . '/../session_init.php';
require_once __DIR__ . '/../csrf.php';
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);

if (!isset($_SESSION['employee_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Unauthorized']);
    exit;
}
csrf_verify();

include '../connection.php';

$submitted_by = $_SESSION['employee_id'];
$draft_id = trim($_POST['draft_id'] ?? '');

if (empty($draft_id) || !ctype_digit($draft_id)) {
    echo json_encode(['success' => false, 'error' => 'Invalid draft id']);
    pg_close($conn);
    exit;
}

// Only deletes rows that are still a draft AND owned by this employee —
// prevents discarding someone else's draft or an already-submitted record.
$sql = "DELETE FROM feedback_complaint_data
        WHERE id = $1 AND submitted_by = $2 AND status = 'draft'";

$result = pg_query_params($conn, $sql, [$draft_id, $submitted_by]);

if (!$result) {
    error_log("discard_draft error: " . pg_last_error($conn));
    echo json_encode(['success' => false, 'error' => 'Could not discard draft.']);
    pg_close($conn);
    exit;
}

if (pg_affected_rows($result) === 0) {
    http_response_code(404);
    echo json_encode(['success' => false, 'error' => 'Draft not found or already removed.']);
    pg_close($conn);
    exit;
}

echo json_encode(['success' => true]);
pg_close($conn);