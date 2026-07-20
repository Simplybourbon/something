<?php

require_once __DIR__ . '/../session_init.php';
require_once __DIR__ . '/../csrf.php';
error_reporting(E_ALL);
ini_set('display_errors', 0);

if (!isset($_SESSION['employee_id'])) {
    header('Content-Type: application/json');
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Unauthorized']);
    exit;
}
csrf_verify();

include '../connection.php';
header('Content-Type: application/json');

$submissionId = trim($_POST['submission_id'] ?? '');
$remarkText   = trim($_POST['remark_text'] ?? '');

if (empty($submissionId) || !ctype_digit($submissionId)) {
    echo json_encode(['success' => false, 'error' => 'Invalid submission ID.']);
    pg_close($conn);
    exit;
}

if ($remarkText === '') {
    echo json_encode(['success' => false, 'error' => 'Remark cannot be empty.']);
    pg_close($conn);
    exit;
}

if (strlen($remarkText) > 2000) {
    echo json_encode(['success' => false, 'error' => 'Remark is too long (max 2000 characters).']);
    pg_close($conn);
    exit;
}

// This endpoint only ever INSERTs a new row. There is no update/delete path
// for remarks anywhere in the app — the original submitter's remark
// (feedback_complaint_data.remarks) and every reply added here are
// permanent once written.
$author = $_SESSION['employee_id'];

$result = pg_query_params(
    $conn,
    "INSERT INTO remarks_thread (submission_id, author, remark_text)
     VALUES ($1, $2, $3)
     RETURNING id, author, remark_text, created_at",
    [$submissionId, $author, $remarkText]
);

if ($result) {
    $row = pg_fetch_assoc($result);
    echo json_encode(['success' => true, 'reply' => $row]);
} else {
    error_log('Add remark error: ' . pg_last_error($conn));
    echo json_encode(['success' => false, 'error' => 'Could not save remark. The submission may no longer exist.']);
}

pg_close($conn);