-- Run this once against the real DB. Not applied automatically by any script.
CREATE TABLE IF NOT EXISTS login_attempts (
    id SERIAL PRIMARY KEY,
    identifier_key VARCHAR(255) NOT NULL,
    success BOOLEAN NOT NULL DEFAULT false,
    attempted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_login_attempts_key_time
    ON login_attempts (identifier_key, attempted_at);

-- Optional: periodically purge old rows (e.g. via a cron job), since this
-- table only needs to retain the last RATE_LIMIT_WINDOW_MINUTES of history:
-- DELETE FROM login_attempts WHERE attempted_at < NOW() - INTERVAL '1 day';
