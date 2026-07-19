<?php

require_once __DIR__ . '/../session_init.php';
header('Content-Type: application/json');

if (isset($_SESSION['employee_id'])) {
    echo json_encode(['loggedIn' => true, 'employee_id' => $_SESSION['employee_id']]);
} else {
    echo json_encode(['loggedIn' => false]);
}
?>