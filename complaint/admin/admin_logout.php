<?php
require_once __DIR__ . '/../session_init.php';
error_reporting(E_ALL);
ini_set('display_errors', 0);
session_destroy();
header('Content-Type: application/json');
echo json_encode(['success' => true]);
?>