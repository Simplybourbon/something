// ── Export Modal ──────────────────────────────────────────
function openExportModal() {
    document.getElementById('exportModal').style.display = 'block';
}

function closeExportModal() {
    document.getElementById('exportModal').style.display = 'none';
}

function exportData() {
    const from = document.getElementById('export_from').value;
    const to = document.getElementById('export_to').value;
    const format = document.getElementById('export_format').value;

    if (!from || !to) {
        alert('Please select both From and To dates.');
        return;
    }
    if (new Date(from) > new Date(to)) {
        alert('From date cannot be after To date.');
        return;
    }

    if (format === 'excel') {
        window.location.href = `../api/export_excel.php?from_date=${from}&to_date=${to}`;
    } else if (format === 'csv') {
        window.location.href = `../api/export_csv.php?from_date=${from}&to_date=${to}`;
    } else if (format === 'pdf') {
        window.location.href = `../api/export_pdf.php?from_date=${from}&to_date=${to}`;
    }
}

// ── CSRF token helper ────────────────────────────────────────
function getCsrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]');
    return meta ? meta.getAttribute('content') : '';
}

// ── Drafts Modal ───────────────────────────────────────────
function openDraftsModal() {
    document.getElementById('draftsModal').style.display = 'block';
    fetch('../api/get_my_drafts.php')
        .then(res => res.json())
        .then(result => {
            const el = document.getElementById('draftsList');
            if (!result.success) {
                el.innerHTML = `<p style="color:red;">${escapeHtml(result.error)}</p>`;
                return;
            }
            if (result.data.length === 0) {
                el.innerHTML = '<p>No drafts saved.</p>';
                return;
            }
            el.innerHTML = result.data.map(d => `
                <div style="border-bottom:1px solid #eee; padding:10px 0;">
                    <strong>${escapeHtml(d.form_no) || '(no number yet)'}</strong> — ${escapeHtml(d.operation) || 'No type selected'}<br>
                    <small>${escapeHtml((d.incident_description || '').substring(0, 60))}</small><br>
                    <small>Saved: ${d.drafted_at ? escapeHtml(new Date(d.drafted_at).toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' })) : '-'}</small><br>
                    <a href="form.php?draft_id=${encodeURIComponent(d.id)}">Continue Editing →</a>
                    &nbsp;|&nbsp;
                    <a href="#" style="color:#c0392b;" onclick="discardDraft(${encodeURIComponent(d.id)}, this); return false;">Discard Draft</a>
                </div>
            `).join('');
        })
        .catch(() => {
            document.getElementById('draftsList').innerHTML = '<p style="color:red;">Network error.</p>';
        });
}

function discardDraft(draftId, linkEl) {
    if (!confirm('Discard this draft? This cannot be undone.')) {
        return;
    }

    const row = linkEl.closest('div');
    linkEl.textContent = 'Discarding...';

    const formData = new FormData();
    formData.append('draft_id', draftId);
    formData.append('csrf_token', getCsrfToken());

    fetch('../api/discard_draft.php', {
        method: 'POST',
        body: formData
    })
        .then(res => res.json())
        .then(result => {
            if (!result.success) {
                alert(result.error || 'Could not discard draft.');
                linkEl.textContent = 'Discard Draft';
                return;
            }
            if (row) {
                row.remove();
            }
            const el = document.getElementById('draftsList');
            if (el && el.children.length === 0) {
                el.innerHTML = '<p>No drafts saved.</p>';
            }
        })
        .catch(() => {
            alert('Network error while discarding draft.');
            linkEl.textContent = 'Discard Draft';
        });
}

function closeDraftsModal() {
    document.getElementById('draftsModal').style.display = 'none';
}

// Close modal if user clicks outside it
window.onclick = function (e) {
    const exportModal = document.getElementById('exportModal');
    const draftsModal = document.getElementById('draftsModal');
    if (e.target === exportModal) closeExportModal();
    if (e.target === draftsModal) closeDraftsModal();
}

function handleLogout() {
    fetch('../api/logoutdashboardemployee.php', { method: 'POST' })
        .then(() => {
            window.location.href = '../index.html';
        })
        .catch(() => {
            window.location.href = '../index.html';
        });
}

// ── HTML escaping (prevents stored XSS from draft data — e.g. a
// malicious <img onerror=...> saved into incident_description) ──
function escapeHtml(value) {
    if (value === null || value === undefined) return '';
    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}