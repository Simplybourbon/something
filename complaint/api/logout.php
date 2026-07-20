<?php
require_once __DIR__ . '/../session_init.php';
header('Content-Type: application/json');

$_SESSION = [];
session_destroy();

echo json_encode(['success' => true]);
?>