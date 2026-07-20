<?php
// Copy this file to connection.php (which is git-ignored) and fill in
// the real values for this environment. Never commit connection.php.

$db_host     = "localhost";
$db_port     = "5432";
$db_name     = "Feedback_data";
$db_user     = "postgres";
$db_password = "REPLACE_WITH_REAL_PASSWORD";

$conn = pg_connect("host=$db_host port=$db_port dbname=$db_name user=$db_user password=$db_password");

if (!$conn) {
    die("Connection failed: ");
}

// Pins the Postgres session timezone so drafted_at/submitted_at display
// correctly regardless of the server's own default timezone setting.
// See NOTES.md for why this line is required on every deployment.
pg_query($conn, "SET timezone = 'Asia/Kolkata';");