# Deployment Notes — Draft Feature + Timestamp Fix

Use this checklist when setting up the complaint/feedback system on the company server.
The timezone bug we hit locally will happen again on a fresh server unless these steps
are done — a new server has its own default Postgres timezone, unrelated to what's set
on your dev machine.

---

## 1. Database schema changes (run once, in order)

### 1a. Add the draft-tracking columns
```sql
ALTER TABLE feedback_complaint_data
    ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'submitted',
    ADD COLUMN drafted_at TIMESTAMP NULL,
    ADD COLUMN submitted_at TIMESTAMP NULL;
```

### 1b. Convert to timezone-aware timestamps
On a **fresh server with no existing draft data**, skip the `USING ... AT TIME ZONE`
conversion (there's nothing to correct) and just do:
```sql
ALTER TABLE feedback_complaint_data
    ALTER COLUMN drafted_at TYPE timestamptz,
    ALTER COLUMN submitted_at TYPE timestamptz;
```

> Only use the `USING drafted_at AT TIME ZONE 'Asia/Kolkata'` version if you're
> migrating a database that already has draft rows saved under the old buggy
> setup (i.e. you're literally moving the dev database, not starting clean).
> If you're starting clean, run the simple `ALTER COLUMN ... TYPE timestamptz`
> above — no `USING` clause needed since there's no history to reinterpret.

---

## 2. Pin the database session timezone

This is the actual fix — it's what prevents this bug from ever happening again,
on any server, regardless of what that server's own Postgres default is set to.

In **`connection.php`**, right after the connection check:

```php
$conn = pg_connect("host=... dbname=... user=... password=...");

if (!$conn) {
    die("Connection failed: ");
}

pg_query($conn, "SET timezone = 'Asia/Kolkata';");
```

**This line must exist on the company server's `connection.php` too** — it's not
something that carries over automatically just because the column type is
`timestamptz`. `timestamptz` stores an absolute instant, but PHP/pg_query still
needs to know what timezone to interpret/display it in for the session, and
that's controlled by this line.

---

## 3. Verify after deploying

Run this directly in pgAdmin (or via a quick throwaway PHP script) on the
company server:

```sql
SHOW timezone;
```
Should return `Asia/Kolkata`. If it doesn't, the `SET timezone` line above
either isn't in `connection.php` or isn't being reached.

Then do a **live test**: save a new draft through the actual form, note the
real wall-clock time, and check the dashboard's "My Drafts" list shows that
same time. If it's off, the timezone isn't pinned correctly — don't just patch
the row with an interval `UPDATE`; find out why the session default is wrong.

---

## 4. Frontend note (already handled, just confirming it travels with the code)

`js/dashboard.js`, inside `openDraftsModal()`:
```js
new Date(d.drafted_at).toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' })
```
This explicitly forces `Asia/Kolkata` display regardless of what timezone the
*browser/OS* on the viewing machine is set to — important since company
machines may not all be configured the same way. No changes needed here for
deployment, just noting why it's written this way.

---

## 5. Quick summary if something looks off after deployment

| Symptom | Likely cause |
|---|---|
| Draft times off by a fixed number of hours | `SET timezone` missing from `connection.php` on that server |
| Draft times correct in DB but wrong on dashboard | Browser/JS timezone issue — check the `toLocaleString` line above still has `timeZone: 'Asia/Kolkata'` |
| `column "drafted_at" is of type timestamp without time zone` errors | Step 1b wasn't run on that server's DB |