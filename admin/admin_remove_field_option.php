<?php
require_once __DIR__ . '/../session_init.php';
require_once __DIR__ . '/../csrf.php';
header('Content-Type: application/json');

if (!isset($_SESSION['admin_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Unauthorized']);
    exit;
}
csrf_verify();

include '../connection.php';


$id = trim($_POST['id'] ?? '');

if (empty($id) || !ctype_digit($id)) {
    echo json_encode(['success' => false, 'error' => 'Invalid option id.']);
    exit;
}

$result = pg_query_params($conn, "DELETE FROM form_field_options WHERE id = $1", [$id]);

if ($result) {
    echo json_encode(['success' => true]);
} else {
    error_log('Remove field option error: ' . pg_last_error($conn));
    echo json_encode(['success' => false, 'error' => 'Could not remove option.']);
}

pg_close($conn);