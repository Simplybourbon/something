<?php
// ── CSRF protection ───────────────────────────────────────
// Requires session_init.php (or any session_start()) to already
// have run, since the token lives in $_SESSION.

function csrf_token() {
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

// Verifies the token submitted in $_POST['csrf_token'] against the
// session's token. On failure, sends a 403 JSON error and exits —
// callers don't need to check a return value or handle failure.
function csrf_verify() {
    $submitted = $_POST['csrf_token'] ?? '';
    $expected  = $_SESSION['csrf_token'] ?? '';

    if ($expected === '' || $submitted === '' || !hash_equals($expected, $submitted)) {
        http_response_code(403);
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'error' => 'Invalid or missing CSRF token. Please refresh the page and try again.']);
        exit;
    }
}
