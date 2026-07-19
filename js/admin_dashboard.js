// ── Auth guard ───────────────────────────────────────────
(function () {
    document.documentElement.style.visibility = 'hidden';
    fetch('../admin/admin_check_session.php')
        .then(res => res.json())
        .then(result => {
            if (!result.loggedIn) {
                window.location.href = '../admin_login.html';
            } else {
                document.documentElement.style.visibility = 'visible';
                const el = document.getElementById('admin_welcome');
                if (el) el.textContent = 'Logged in as: ' + result.admin_id;
            }
        })
        .catch(() => { window.location.href = '../admin_login.html'; });
})();

// ── Logout ───────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('admin_logout').addEventListener('click', function (e) {
        e.preventDefault();
        fetch('../admin/admin_logout.php')
            .then(() => { window.location.href = '../admin_login.html'; })
            .catch(() => { window.location.href = '../admin_login.html'; });
    });

    loadEmployees();
    loadSubmissions();
});

// ── Tab switching ────────────────────────────────────────
function switchTab(tab) {
    document.querySelectorAll('.admin-tab').forEach((t, i) => {
        t.classList.toggle('active',
            (tab === 'employees' && i === 0) ||
            (tab === 'submissions' && i === 1) ||
            (tab === 'options' && i === 2)
        );
    });
    document.getElementById('tab_employees').classList.toggle('active', tab === 'employees');
    document.getElementById('tab_submissions').classList.toggle('active', tab === 'submissions');
    document.getElementById('tab_options').classList.toggle('active', tab === 'options');
    if (tab === 'options') loadFieldOptions();
}

// ── Helpers ──────────────────────────────────────────────
function escapeHtml(val) {
    if (val === null || val === undefined) return '';
    return String(val)
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

function showStatus(elId, message, type) {
    const el = document.getElementById(elId);
    el.textContent = message;
    el.className = 'status-msg ' + type;
    setTimeout(() => { el.className = 'status-msg'; el.textContent = ''; }, 4000);
}

// ── Global floating tooltip ──────────────────────────────
function showTip(btn, title, desc) {
    const tip = document.getElementById('global-tooltip');
    tip.innerHTML = `<strong>${escapeHtml(title)}</strong><p style="margin:4px 0 0;">${escapeHtml(desc)}</p>`;
    const rect = btn.getBoundingClientRect();
    tip.style.left = (rect.left + rect.width / 2) + 'px';
    tip.style.top = (rect.top - 8) + 'px';
    tip.style.transform = 'translate(-50%, -100%)';
    tip.classList.add('visible');
}

function hideTip() {
    document.getElementById('global-tooltip').classList.remove('visible');
}
// ── Manage Dropdown Options ───────────────────────────────
let allFieldOptions = [];

function loadFieldOptions() {
    fetch('../admin/admin_get_field_options.php')
        .then(res => res.json())
        .then(result => {
            if (!result.success) {
                document.getElementById('option_list').innerHTML = `<p style="color:red;">${escapeHtml(result.error)}</p>`;
                return;
            }
            allFieldOptions = result.data;
            renderFieldOptions();
        })
        .catch(() => {
            document.getElementById('option_list').innerHTML = '<p style="color:red;">Failed to load options.</p>';
        });
}

function renderFieldOptions() {
    const field = document.getElementById('option_field_select').value;
    const list = allFieldOptions.filter(o => o.field_name === field);
    const container = document.getElementById('option_list');

    if (list.length === 0) {
        container.innerHTML = '<p class="option-empty">No options yet for this field.</p>';
        return;
    }

    container.innerHTML = list.map(o => `
        <div class="option-row">
            <span>${escapeHtml(o.option_value)}</span>
            <button class="btn-delete" onclick="removeFieldOption(${escapeHtml(o.id)})">✕</button>
        </div>
    `).join('');
}

function addFieldOption() {
    const field = document.getElementById('option_field_select').value;
    const input = document.getElementById('new_option_text');
    const value = input.value.trim();

    if (!value) {
        alert('Enter option text first.');
        return;
    }

    const formData = new FormData();
    formData.append('field_name', field);
    formData.append('option_value', value);

    formData.append('csrf_token', getCsrfToken());

    fetch('../admin/admin_add_field_option.php', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                input.value = '';
                loadFieldOptions();
            } else {
                alert('Error: ' + result.error);
            }
        })
        .catch(err => alert('Network error: ' + err.message));
}

function removeFieldOption(id) {
    if (!confirm('Remove this option? Existing submissions that used it will keep their stored value.')) return;

    const formData = new FormData();
    formData.append('id', id);

    formData.append('csrf_token', getCsrfToken());

    fetch('../admin/admin_remove_field_option.php', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                loadFieldOptions();
            } else {
                alert('Error: ' + result.error);
            }
        })
        .catch(err => alert('Network error: ' + err.message));
}
// ── Employees ────────────────────────────────────────────
function loadEmployees() {
    fetch('../admin/admin_get_employees.php')
        .then(res => {
            if (res.status === 401) { window.location.href = '../admin_login.html'; return; }
            return res.json();
        })
        .then(result => {
            if (!result) return;
            const tbody = document.getElementById('emp_tbody');
            if (!result.success) {
                tbody.innerHTML = `<tr><td colspan="3">${escapeHtml(result.error)}</td></tr>`;
                return;
            }
            if (!result.data || result.data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3">No employees found.</td></tr>';
                return;
            }
            tbody.innerHTML = result.data.map((emp, i) => `
                <tr>
                    <td>${i + 1}</td>
                    <td>${escapeHtml(emp.employee_id)}</td>
                    <td style="display:flex; gap:8px; align-items:center;">
                        <button class="btn-delete" data-empid="${escapeHtml(emp.employee_id)}" onclick="deleteEmployee(this.dataset.empid)"
                            onmouseenter="showTip(this, 'Remove Employee', 'Permanently deletes this employee from the system.')"
                            onmouseleave="hideTip()">✕</button>
                        <button class="btn-edit" data-empid="${escapeHtml(emp.employee_id)}" onclick="openResetModal(this.dataset.empid)"
                            onmouseenter="showTip(this, 'New Password', 'Set a new password for this employee.')"
                            onmouseleave="hideTip()">Reset</button>
                    </td>
                </tr>
            `).join('');
        })
        .catch(err => {
            console.error('Load employees error:', err);
            document.getElementById('emp_tbody').innerHTML = '<tr><td colspan="3">Failed to load employees.</td></tr>';
        });
}

function addEmployee() {
    const empId = document.getElementById('new_emp_id').value.trim();
    const empPass = document.getElementById('new_emp_pass').value;
    const statusEl = document.getElementById('add_emp_status');

    if (!empId || !empPass) {
        statusEl.style.color = 'red';
        statusEl.textContent = 'Please enter both Employee ID and Password.';
        return;
    }

    const formData = new FormData();
    formData.append('employee_id', empId);
    formData.append('password', empPass);

    formData.append('csrf_token', getCsrfToken());

    fetch('../admin/admin_add_employee.php', { method: 'POST', body: formData })
        .then(res => {
            if (res.status === 401) { window.location.href = '../admin_login.html'; return; }
            return res.json();
        })
        .then(result => {
            if (!result) return;
            if (result.success) {
                statusEl.style.color = 'green';
                statusEl.textContent = `Employee "${empId}" added successfully.`;
                document.getElementById('new_emp_id').value = '';
                document.getElementById('new_emp_pass').value = '';
                document.getElementById('new_emp_pass').type = 'password';
                document.getElementById('eye_icon').src = '../icons8-eye-50.png';
                loadEmployees();
            } else {
                statusEl.style.color = 'red';
                statusEl.textContent = result.error || 'Failed to add employee.';
            }
        })
        .catch(err => {
            console.error('Add employee error:', err);
            statusEl.style.color = 'red';
            statusEl.textContent = 'Network error.';
        });
}

function deleteEmployee(employeeId) {
    if (!confirm(`Delete employee "${employeeId}"? This cannot be undone.`)) return;

    const formData = new FormData();
    formData.append('employee_id', employeeId);

    formData.append('csrf_token', getCsrfToken());

    fetch('../admin/admin_delete_employee.php', { method: 'POST', body: formData })
        .then(res => {
            if (res.status === 401) { window.location.href = '../admin_login.html'; return; }
            return res.json();
        })
        .then(result => {
            if (!result) return;
            if (result.success) {
                showStatus('emp_status', `Employee "${employeeId}" deleted.`, 'success');
                loadEmployees();
            } else {
                showStatus('emp_status', result.error || 'Failed to delete.', 'error');
            }
        })
        .catch(err => {
            console.error('Delete employee error:', err);
            showStatus('emp_status', 'Network error.', 'error');
        });
}
// ── Shared date formatters ────────────────────────────────
function formatDateOnly(dateStr) {
    if (!dateStr) return '—';
    const months = ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"];
    const d = new Date(dateStr + 'T00:00:00');
    return `${d.getDate()}-${months[d.getMonth()]}-${d.getFullYear()}`;
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
// ── Submissions ──────────────────────────────────────────
function loadSubmissions() {
    fetch('../admin/admin_get_submissions.php')
        .then(res => {
            if (res.status === 401) { window.location.href = '../admin_login.html'; return; }
            return res.json();
        })
        .then(result => {
            if (!result) return;
            const tbody = document.getElementById('sub_tbody');
            if (!result.success) {
                tbody.innerHTML = `<tr><td colspan="18">${escapeHtml(result.error)}</td></tr>`;
                return;
            }
            if (!result.data || result.data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="18">No submissions yet.</td></tr>';
                return;
            }
            tbody.innerHTML = result.data.map(row => `
                <tr data-id="${escapeHtml(row.id)}">
                    <td>
                        <button class="btn-edit" onclick="toggleEditRow(this)"
                            onmouseenter="showTip(this, 'Edit Row', 'Click to edit this submission inline, click again to save.')"
                            onmouseleave="hideTip()">Edit</button>
                    </td>
                    <td>
                        <button class="btn-delete" onclick="deleteSubmission(${escapeHtml(row.id)})"
                            onmouseenter="showTip(this, 'Delete Submission', 'Permanently deletes this submission.')"
                            onmouseleave="hideTip()">✕</button>
                    </td>
                    <td>${escapeHtml(row.id)}</td>
                    <td>${escapeHtml(row.submitted_by)}</td>
                    <td>${escapeHtml(row.form_no)}</td>
                    <td>${escapeHtml(row.operation)}</td>
                    <td>${escapeHtml(row.given_by)}</td>
                    <td>${formatDateOnly(row.date_of_submission)}</td>
                    <td>${formatDateTime(row.drafted_at)}</td>
                    <td>${formatDateTime(row.submitted_at)}</td>
                    <td class="editable" data-field="depatment_section">${escapeHtml(row.depatment_section)}</td><td class="editable" data-field="incident_description">${escapeHtml(row.incident_description)}</td>
                    <td class="editable" data-field="main_error_category">${escapeHtml(row.main_error_category)}</td>
                    <td class="editable" data-field="root_cause">${escapeHtml(row.root_cause)}</td>
                    <td class="editable" data-field="immediate_correction">${escapeHtml(row.immediate_correction)}</td>
                    <td class="editable" data-field="corrective_action">${escapeHtml(row.corrective_action)}</td>
                    <td class="editable" data-field="preventive_action">${escapeHtml(row.preventive_action)}</td>
                    <td class="editable" data-field="patient_consequences">${escapeHtml(row.patient_consequences)}</td>
                </tr>
            `).join('');
        })
        .catch(err => {
            console.error('Load submissions error:', err);
            document.getElementById('sub_tbody').innerHTML = '<tr><td colspan="18">Failed to load submissions.</td></tr>';
        });
}

function saveEdit(id, field, value, td, original) {
    const formData = new FormData();
    formData.append('id', id);
    formData.append('field', field);
    formData.append('value', value);

    formData.append('csrf_token', getCsrfToken());

    fetch('../admin/admin_edit_submission.php', { method: 'POST', body: formData })
        .then(res => {
            if (res.status === 401) { window.location.href = '../admin_login.html'; return; }
            return res.json();
        })
        .then(result => {
            if (!result) return;
            if (result.success) {
                td.textContent = value;
                showStatus('sub_status', 'Record updated successfully.', 'success');
            } else {
                td.textContent = original;
                showStatus('sub_status', result.error || 'Failed to update.', 'error');
            }
        })
        .catch(err => {
            console.error('Edit error:', err);
            td.textContent = original;
            showStatus('sub_status', 'Network error.', 'error');
        });
}

function deleteSubmission(id) {
    if (!confirm(`Delete submission #${id}? This cannot be undone.`)) return;

    const formData = new FormData();
    formData.append('id', id);

    formData.append('csrf_token', getCsrfToken());

    fetch('../admin/admin_delete_submission.php', { method: 'POST', body: formData })
        .then(res => {
            if (res.status === 401) { window.location.href = '../admin_login.html'; return; }
            return res.json();
        })
        .then(result => {
            if (!result) return;
            if (result.success) {
                showStatus('sub_status', `Submission #${id} deleted.`, 'success');
                loadSubmissions();
            } else {
                showStatus('sub_status', result.error || 'Failed to delete.', 'error');
            }
        })
        .catch(err => {
            console.error('Delete submission error:', err);
            showStatus('sub_status', 'Network error.', 'error');
        });
}

// ── Export ───────────────────────────────────────────────
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

window.onclick = function (e) {
    const modal = document.getElementById('exportModal');
    if (e.target === modal) closeExportModal();
}

// ── Eye toggle ───────────────────────────────────────────
function toggleEmpPass() {
    const input = document.getElementById('new_emp_pass');
    const icon = document.getElementById('eye_icon');
    if (input.type === 'password') {
        input.type = 'text';
        icon.src = '../icons8-closed-eye-50.png';
    } else {
        input.type = 'password';
        icon.src = '../icons8-eye-50.png';
    }
}

// ── Inline row editing ───────────────────────────────────
function toggleEditRow(btn) {
    const row = btn.closest('tr');
    const isEditing = row.classList.contains('editing');

    if (isEditing) {
        row.querySelectorAll('td.editable input').forEach(input => {
            const td = input.parentElement;
            const field = td.dataset.field;
            const newVal = input.value.trim();
            const original = input.dataset.original;
            if (newVal !== original) {
                saveEdit(row.dataset.id, field, newVal, td, original);
            } else {
                td.textContent = newVal;
            }
        });
        row.classList.remove('editing');
        btn.textContent = 'Edit';
    } else {
        row.querySelectorAll('td.editable').forEach(td => {
            const current = td.textContent;
            td.innerHTML = '';
            const input = document.createElement('input');
            input.type = 'text';
            input.value = current;
            input.setAttribute('data-original', current);
            td.appendChild(input);
        });
        row.classList.add('editing');
        btn.textContent = 'Save';
    }
}

// ── Reset Password ───────────────────────────────────────
let resetTargetId = '';

function openResetModal(employeeId) {
    resetTargetId = employeeId;
    document.getElementById('reset_emp_label').textContent = 'Employee: ' + employeeId;
    document.getElementById('reset_new_pass').value = '';
    document.getElementById('reset_confirm_pass').value = '';
    document.getElementById('reset_error').textContent = '';
    document.getElementById('resetModal').style.display = 'block';
}

function closeResetModal() {
    document.getElementById('resetModal').style.display = 'none';
}

function submitResetPassword() {
    const newPass = document.getElementById('reset_new_pass').value;
    const confirmPass = document.getElementById('reset_confirm_pass').value;
    const errorEl = document.getElementById('reset_error');

    errorEl.textContent = '';

    if (!newPass || !confirmPass) {
        errorEl.textContent = 'Both fields are required.';
        return;
    }
    if (newPass.length < 6) {
        errorEl.textContent = 'Password must be at least 6 characters.';
        return;
    }
    if (newPass !== confirmPass) {
        errorEl.textContent = 'Passwords do not match.';
        return;
    }

    const formData = new FormData();
    formData.append('employee_id', resetTargetId);
    formData.append('new_password', newPass);

    formData.append('csrf_token', getCsrfToken());

    fetch('../admin/admin_reset_password.php', { method: 'POST', body: formData })
        .then(res => {
            if (res.status === 401) { window.location.href = '../admin_login.html'; return; }
            return res.json();
        })
        .then(result => {
            if (!result) return;
            if (result.success) {
                closeResetModal();
                showStatus('emp_status', `Password for "${resetTargetId}" reset successfully.`, 'success');
            } else {
                errorEl.textContent = result.error || 'Failed to reset password.';
            }
        })
        .catch(() => {
            errorEl.textContent = 'Network error. Please try again.';
        });
}