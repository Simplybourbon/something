document.addEventListener('DOMContentLoaded', function () {
    const statusEl = document.getElementById('responses_status');
    const table = document.getElementById('responses_table');
    const tbody = document.getElementById('responses_body');

    fetch('../api/view_responses.php')
        .then(res => {
            if (res.status === 401) {
                window.location.href = '../index.html';
                return;
            }
            return res.json();
        })
        .then(result => {
            if (!result) return;

            if (!result.success) {
                statusEl.textContent = result.error || 'Could not load responses.';
                return;
            }

            const rows = result.data;

            if (!rows || rows.length === 0) {
                statusEl.textContent = 'No responses submitted yet.';
                return;
            }

            statusEl.style.display = 'none';
            table.style.display = 'table';

            rows.forEach(row => {
                const tr = document.createElement('tr');
                tr.dataset.id = row.id;
                tr.innerHTML = `
                    <td>${escapeHtml(row.form_no)}</td>
                    <td>${escapeHtml(row.submitted_by)}</td>
                    <td>${escapeHtml(row.operation)}</td>
                    <td>${escapeHtml(row.given_by)}</td>
                    <td>${escapeHtml(row.date_of_submission)}</td>
                    <td>${escapeHtml(row.depatment_section)}</td>
                    <td>${escapeHtml(row.incident_description)}</td>
                    <td>${escapeHtml(row.main_error_category)}</td>
                    <td>${escapeHtml(row.sub_error_categor)}</td>
                    <td>${escapeHtml(row.avg_impact_score)}</td>
                    <td>${escapeHtml(row.avg_freq_score)}</td>
                    <td>${escapeHtml(row.avg_risk_score)}</td>
                    <td>${escapeHtml(row.patient_consequences)}</td>
                    <td>${escapeHtml(row.corrective_action)}</td>
                    <td>${escapeHtml(row.preventive_action)}</td>
                    <td class="remarks-cell"></td>
                `;
                tbody.appendChild(tr);
                renderRemarksCell(tr.querySelector('.remarks-cell'), row);
            });
        })
        .catch(err => {
            console.error('Failed to load responses:', err);
            statusEl.textContent = 'Network error while loading responses.';
        });
});

// Renders: the original submission-time remark (frozen, never editable),
// followed by any replies added later, followed by an "Add remark" control.
// Nothing in this cell ever edits or deletes an existing entry — only new
// rows can be appended via add_remark.php. Each entry is truncated to a
// single line; hovering shows the full text in a floating tooltip, since
// remarks can run long.
function renderRemarksCell(cell, row) {
    cell.innerHTML = '';

    const list = document.createElement('div');
    list.className = 'remarks-list';
    cell.appendChild(list);

    if (row.remarks) {
        addRemarkEntryEl(list, `${row.submitted_by} (original, ${row.date_of_submission})`, row.remarks);
    }

    (row.replies || []).forEach(reply => {
        addRemarkEntryEl(list, `${reply.author} (${formatDateTime(reply.created_at)})`, reply.remark_text);
    });

    const addBtn = document.createElement('button');
    addBtn.type = 'button';
    addBtn.className = 'add-remark-btn';
    addBtn.textContent = '+ Add';
    addBtn.addEventListener('click', () => showAddRemarkForm(cell, list, row.id, addBtn));
    cell.appendChild(addBtn);
}

function addRemarkEntryEl(cell, meta, text) {
    const entry = document.createElement('div');
    entry.className = 'remark-entry';
    entry.innerHTML = `<span class="remark-meta">${escapeHtml(meta)}</span>${escapeHtml(text)}`;
    entry.addEventListener('mouseenter', () => showRemarkTip(entry, meta, text));
    entry.addEventListener('mouseleave', hideTip);
    cell.appendChild(entry);
    return entry;
}

// ── Global floating tooltip: full remark text on hover ──
function showRemarkTip(el, meta, text) {
    const tip = document.getElementById('global-tooltip');
    if (!tip) return;
    tip.innerHTML = `<span class="tip-meta">${escapeHtml(meta)}</span>${escapeHtml(text)}`;
    const rect = el.getBoundingClientRect();
    tip.style.left = Math.min(rect.left, window.innerWidth - 300) + 'px';
    tip.style.top = (rect.bottom + 6) + 'px';
    tip.classList.add('visible');
}

function hideTip() {
    const tip = document.getElementById('global-tooltip');
    if (tip) tip.classList.remove('visible');
}

function showAddRemarkForm(cell, list, submissionId, addBtn) {
    const form = document.createElement('div');
    form.className = 'add-remark-form';
    form.innerHTML = `
        <textarea rows="2" placeholder="Add a remark..." maxlength="2000"></textarea>
        <div>
            <button type="button" class="save-btn">Save</button>
            <button type="button" class="cancel-btn">Cancel</button>
        </div>
    `;
    addBtn.style.display = 'none';
    cell.appendChild(form);

    const textarea = form.querySelector('textarea');
    textarea.focus();

    form.querySelector('.cancel-btn').addEventListener('click', () => {
        form.remove();
        addBtn.style.display = '';
    });

    form.querySelector('.save-btn').addEventListener('click', () => {
        const remarkText = textarea.value.trim();
        if (!remarkText) {
            showRemarksStatus('Remark cannot be empty.', 'error');
            return;
        }
        saveNewRemark(list, submissionId, remarkText, form, addBtn);
    });
}

function saveNewRemark(list, submissionId, remarkText, form, addBtn) {
    const saveBtn = form.querySelector('.save-btn');
    saveBtn.disabled = true;
    saveBtn.textContent = 'Saving...';

    const formData = new FormData();
    formData.append('submission_id', submissionId);
    formData.append('remark_text', remarkText);
    formData.append('csrf_token', getCsrfToken());

    fetch('../api/add_remark.php', { method: 'POST', body: formData })
        .then(res => {
            if (res.status === 401) {
                window.location.href = '../index.html';
                return;
            }
            return res.json();
        })
        .then(result => {
            if (!result) return;
            if (result.success) {
                form.remove();
                addBtn.style.display = '';
                const entry = addRemarkEntryEl(
                    list,
                    `${result.reply.author} (${formatDateTime(result.reply.created_at)})`,
                    result.reply.remark_text
                );
                entry.scrollIntoView({ block: 'nearest' });
                showRemarksStatus('Remark added.', 'success');
            } else {
                saveBtn.disabled = false;
                saveBtn.textContent = 'Save';
                showRemarksStatus(result.error || 'Failed to add remark.', 'error');
            }
        })
        .catch(err => {
            console.error('Failed to save remark:', err);
            saveBtn.disabled = false;
            saveBtn.textContent = 'Save';
            showRemarksStatus('Network error while saving remark.', 'error');
        });
}

function showRemarksStatus(message, type) {
    const statusEl = document.getElementById('remarks_save_status');
    if (!statusEl) return;
    statusEl.textContent = message;
    statusEl.className = type || '';
    setTimeout(() => {
        if (statusEl.textContent === message) {
            statusEl.textContent = '';
            statusEl.className = '';
        }
    }, 3000);
}

function formatDateTime(dateStr) {
    if (!dateStr) return '—';
    const months = ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"];
    const d = new Date(dateStr);
    const datePart = `${d.getDate()}-${months[d.getMonth()]}-${d.getFullYear()}`;
    const timePart = d.toLocaleTimeString('en-IN', { timeZone: 'Asia/Kolkata', hour: 'numeric', minute: '2-digit', hour12: true });
    return `${datePart}, ${timePart}`;
}

function escapeHtml(value) {
    if (value === null || value === undefined) return '';
    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function getCsrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]');
    return meta ? meta.getAttribute('content') : '';
}