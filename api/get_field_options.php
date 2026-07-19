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


$result = pg_query($conn, "SELECT field_name, option_value FROM form_field_options ORDER BY field_name, display_order, id");

if (!$result) {
    error_log("get_field_options error: " . pg_last_error($conn));
    echo json_encode(['success' => false, 'error' => 'Could not load field options.']);
    pg_close($conn);
    exit;
}

$grouped = [];
while ($row = pg_fetch_assoc($result)) {
    $grouped[$row['field_name']][] = $row['option_value'];
}

echo json_encode(['success' => true, 'data' => $grouped]);
pg_close($conn);