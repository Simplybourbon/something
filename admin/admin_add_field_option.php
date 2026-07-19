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


$valid_fields = ['given_by', 'department_section', 'pre_analytic_error', 'analytic_error', 'post_analytic_error', 'no_lab_error'];

$field_name    = trim($_POST['field_name'] ?? '');
$option_value  = trim($_POST['option_value'] ?? '');

if (!in_array($field_name, $valid_fields)) {
    echo json_encode(['success' => false, 'error' => 'Invalid field name.']);
    exit;
}
if (empty($option_value)) {
    echo json_encode(['success' => false, 'error' => 'Option text is required.']);
    exit;
}
if (strlen($option_value) > 200) {
    echo json_encode(['success' => false, 'error' => 'Option text is too long.']);
    exit;
}

$max = pg_query_params($conn, "SELECT COALESCE(MAX(display_order),0) AS m FROM form_field_options WHERE field_name = $1", [$field_name]);
$next_order = pg_fetch_result($max, 0, 'm') + 1;

$result = pg_query_params(
    $conn,
    "INSERT INTO form_field_options (field_name, option_value, display_order) VALUES ($1, $2, $3)",
    [$field_name, $option_value, $next_order]
);

if ($result) {
    echo json_encode(['success' => true]);
} else {
    if (strpos(pg_last_error($conn), 'duplicate') !== false || strpos(pg_last_error($conn), 'unique') !== false) {
        echo json_encode(['success' => false, 'error' => 'This option already exists for this field.']);
    } else {
        error_log('Add field option error: ' . pg_last_error($conn));
        echo json_encode(['success' => false, 'error' => 'Could not add option.']);
    }
}

pg_close($conn);