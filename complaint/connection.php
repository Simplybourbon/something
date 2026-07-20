<?php

$conn = pg_connect("host=localhost port=5432 dbname=Feedback_data user=postgres password=2026Bbh");

if (!$conn) {
    die("Connection failed: ");
}
pg_query($conn, 'SET search_path TO "ComplaintSchema"');
pg_query($conn, "SET timezone = 'Asia/Kolkata';");
