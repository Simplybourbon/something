<?php

require_once __DIR__ . '/../session_init.php';
require_once __DIR__ . '/../rate_limit.php';
error_reporting(E_ALL);
ini_set('display_errors', 0);

include '../connection.php';


header('Content-Type: application/json');

$employee_id = trim($_POST["employee_id"] ?? "");
$password    = $_POST["password"] ?? "";

if (empty($employee_id) || empty($password)) {
    echo json_encode(['success' => false, 'error' => 'Employee ID and password are required.']);
    pg_close($conn);
    exit;
}

if (rate_limit_is_blocked($conn, $employee_id)) {
    pg_close($conn);
    rate_limit_reject();
}

$result = pg_query_params($conn, 
    "SELECT employee_id, password_hash FROM employees WHERE employee_id = $1", 
    [$employee_id]
);

if (!$result) {
    error_log("Login SQL Error: " . pg_last_error($conn));
    echo json_encode(['success' => false, 'error' => 'Something went wrong. Please try again.']);
    pg_close($conn);
    exit;
}

$row = pg_fetch_assoc($result);

// Timing-safe: always run password_verify even if no row found
$hashToCheck = $row ? $row['password_hash'] : '$2y$10$invalidsaltinvalidsaltinvalidsa';

if ($row && password_verify($password, $hashToCheck)) {
    session_regenerate_id(true);
    rate_limit_clear($conn, $employee_id);
    $_SESSION['employee_id'] = $row['employee_id'];
    echo json_encode(['success' => true]);
} else {
    rate_limit_record_failure($conn, $employee_id);
    echo json_encode(['success' => false, 'error' => 'Invalid Employee ID or Password.']);
}

pg_close($conn);
?>