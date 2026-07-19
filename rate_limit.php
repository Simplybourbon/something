<?php
// ── Login rate limiting ───────────────────────────────────
// Requires the `login_attempts` table — see migration_login_attempts.sql.
// Call rate_limit_check() before verifying a password, and
// rate_limit_record_failure() / rate_limit_clear() after.

const RATE_LIMIT_MAX_ATTEMPTS = 5;
const RATE_LIMIT_WINDOW_MINUTES = 15;

function rate_limit_key($identifier) {
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    return $identifier . '|' . $ip;
}

// Returns true if the request should be blocked (too many recent failures).
function rate_limit_is_blocked($conn, $identifier) {
    $key = rate_limit_key($identifier);
    $result = pg_query_params(
        $conn,
        "SELECT COUNT(*) AS attempts FROM login_attempts
         WHERE identifier_key = $1 AND success = false
           AND attempted_at > NOW() - INTERVAL '" . RATE_LIMIT_WINDOW_MINUTES . " minutes'",
        [$key]
    );
    if (!$result) return false; // fail open on DB error rather than lock everyone out
    $row = pg_fetch_assoc($result);
    return ((int)($row['attempts'] ?? 0)) >= RATE_LIMIT_MAX_ATTEMPTS;
}

function rate_limit_record_failure($conn, $identifier) {
    $key = rate_limit_key($identifier);
    pg_query_params(
        $conn,
        "INSERT INTO login_attempts (identifier_key, success, attempted_at) VALUES ($1, false, NOW())",
        [$key]
    );
}

// Clears failed-attempt history for this identifier+IP on a successful login.
function rate_limit_clear($conn, $identifier) {
    $key = rate_limit_key($identifier);
    pg_query_params($conn, "DELETE FROM login_attempts WHERE identifier_key = $1", [$key]);
}

// Sends a 429 JSON response and exits. Call when rate_limit_is_blocked() is true.
function rate_limit_reject() {
    http_response_code(429);
    header('Content-Type: application/json');
    echo json_encode([
        'success' => false,
        'error' => 'Too many failed login attempts. Please wait ' . RATE_LIMIT_WINDOW_MINUTES . ' minutes and try again.'
    ]);
    exit;
}
