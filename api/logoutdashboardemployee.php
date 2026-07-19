<?php
require_once __DIR__ . '/../session_init.php';
session_destroy();
echo json_encode(['success' => true]);
?>