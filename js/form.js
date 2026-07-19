// ── CSRF token helper ─────────────────────────────────────
function getCsrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]');
    return meta ? meta.getAttribute('content') : '';
}

// ── Accordion ─────────────────────────────────────────────
function toggleSection(index) {
    const sections = document.querySelectorAll(".accordion-section");
    sections.forEach((section, i) => {
        const isTarget = i === index;
        const alreadyOpen = section.classList.contains("open");
        if (isTarget) {
            section.classList.toggle("open", !alreadyOpen);
        } else {
            section.classList.remove("open");
        }
        const icon = section.querySelector(".accordion-icon");
        if (icon) icon.textContent = section.classList.contains("open") ? "−" : "+";
    });
}

function openSection(index) {
    const sections = document.querySelectorAll(".accordion-section");
    sections.forEach((section, i) => {
        section.classList.toggle("open", i === index);
        const icon = section.querySelector(".accordion-icon");
        if (icon) icon.textContent = section.classList.contains("open") ? "−" : "+";
    });
    sections[index]?.scrollIntoView({ behavior: "smooth", block: "start" });
}

// ── Interdependent dropdown ──────────────────────────────
function updateSub() {
    const rows = ['pre_row', 'analytic_row', 'post_row', 'others_row'];
    rows.forEach(id => {
        document.getElementById(id).style.display = 'none';
    });
    const val = document.getElementById('main_category').value;
    if (val) {
        document.getElementById(val + '_row').style.removeProperty('display');
    }
}

// ── Risk Score calculator ────────────────────────────────
function calcRisk(impactId, freqId, resultId) {
    const impact = parseFloat(document.getElementById(impactId).value) || 0;
    const freq = parseFloat(document.getElementById(freqId).value) || 0;
    const result = impact * freq;
    document.getElementById(resultId).innerHTML = result;
    calcAverage();
}

// ── Date formatter: "1-July-2026" ────────────────────────
function formatDisplayDate(d) {
    const months = ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"];
    return `${d.getDate()}-${months[d.getMonth()]}-${d.getFullYear()}`;
}

function calcAverage() {
    let sumImpact = 0;
    let sumFreq = 0;
    let sumRisk = 0;
    let count = 0;

    for (let i = 1; i <= 5; i++) {
        const impact = parseFloat(document.getElementById('impact_score' + i).value) || 0;
        const freq = parseFloat(document.getElementById('freq_score' + i).value) || 0;
        const risk = parseFloat(document.getElementById('risk_score' + i).innerHTML) || 0;

        if (impact > 0 || freq > 0) {
            sumImpact += impact;
            sumFreq += freq;
            sumRisk += risk;
            count++;
        }
    }

    if (count > 0) {
        document.getElementById('impact_score').value = (sumImpact / count).toFixed(2);
        document.getElementById('freq_score').value = (sumFreq / count).toFixed(2);
        const avgRisk = (sumRisk / count).toFixed(2);
        document.getElementById('risk_score').innerHTML = avgRisk;
        const hiddenRisk = document.getElementById('risk_score_hidden');
        if (hiddenRisk) hiddenRisk.value = avgRisk;
    } else {
        document.getElementById('impact_score').value = '';
        document.getElementById('freq_score').value = '';
        document.getElementById('risk_score').innerHTML = '0';
        const hiddenRisk = document.getElementById('risk_score_hidden');
        if (hiddenRisk) hiddenRisk.value = '0';
    }
}

// ── Populate all field-option selects from the backend ───
// Fetches api/get_field_options.php once and fills in every
// <select> whose id matches a key in the returned JSON.
// Expected shape: { "given_by": ["A","B"], "department_section": [...],
//                    "main_category": [...], "pre_analytic_error": [...],
//                    "analytic_error": [...], "post_analytic_error": [...],
//                    "no_lab_error": [...] }
// Returns a Promise so callers can chain work that needs the
// selects to be populated first (e.g. loadDraft()).
function populateFieldOptions() {
    return fetch('../api/get_field_options.php')
        .then(res => res.json())
        .then(result => {
            if (!result.success) {
                console.error('get_field_options.php returned an error:', result.error);
                return;
            }
            const data = result.data || {};
            Object.entries(data).forEach(([fieldId, options]) => {
                const select = document.getElementById(fieldId);
                if (!select || !Array.isArray(options)) return;

                // Keep the existing "-- Select --" placeholder (first option) if present
                const placeholder = select.querySelector('option[value=""]');
                select.innerHTML = '';
                if (placeholder) {
                    select.appendChild(placeholder);
                } else {
                    const ph = document.createElement('option');
                    ph.value = '';
                    ph.textContent = '-- Select --';
                    select.appendChild(ph);
                }

                options.forEach(opt => {
                    const option = document.createElement('option');
                    if (opt && typeof opt === 'object') {
                        option.value = opt.value ?? opt.label ?? '';
                        option.textContent = opt.label ?? opt.value ?? '';
                    } else {
                        option.value = opt;
                        option.textContent = opt;
                    }
                    select.appendChild(option);
                });
            });
        })
        .catch(err => console.error('Could not load field options:', err));
}

// ── Load an existing draft into the form ─────────────────
function loadDraft(draftId) {
    fetch(`../api/get_draft.php?draft_id=${draftId}`)
        .then(res => res.json())
        .then(result => {
            if (!result.success) {
                alert('Could not load draft: ' + result.error);
                return;
            }
            const d = result.data;

            document.getElementById('draft_id_hidden').value = d.id;
            document.body.classList.add('completing-draft');

            // Form number: reuse the one already assigned to this draft
            const formnoEl = document.getElementById('formno');
            if (formnoEl) formnoEl.textContent = d.form_no || '';
            document.getElementById('formno_hidden').value = d.form_no || '';

            // Operation radio
            if (d.operation) {
                const radio = document.querySelector(`input[name="operation"][value="${d.operation}"]`);
                if (radio) radio.checked = true;
            }

            // Simple selects / textareas
            const directFields = {
                given_by: d.given_by,
                department_section: d.depatment_section,
                incident_description: d.incident_description,
                main_category: d.main_error_category,
                root_cause: d.root_cause,
                immediate_correction: d.immediate_correction,
                corrective_action: d.corrective_action,
                preventive_action: d.preventive_action,
                remarks: d.remarks,
            };
            Object.entries(directFields).forEach(([id, value]) => {
                const el = document.getElementById(id);
                if (el && value !== null && value !== undefined) el.value = value;
            });

            // Sub-error category depends on main_category
            updateSub();
            const subErrorMap = {
                pre: 'pre_analytic_error',
                analytic: 'analytic_error',
                post: 'post_analytic_error',
                others: 'no_lab_error',
            };
            const subFieldId = subErrorMap[d.main_error_category];
            if (subFieldId && d.sub_error_categor) {
                const el = document.getElementById(subFieldId);
                if (el) el.value = d.sub_error_categor;
            }

            // Checkboxes (stored as "yes"/"no")
            ['active_error', 'latent_error', 'cognitive_error', 'non_cognitive_error'].forEach(id => {
                const el = document.getElementById(id);
                if (el) el.checked = (d[id] === 'yes');
            });

            // Patient consequences radio
            if (d.patient_consequences) {
                const radio = document.querySelector(`input[name="patient_consequences"][value="${d.patient_consequences}"]`);
                if (radio) radio.checked = true;
            }

            // Risk table rows
            for (let i = 1; i <= 5; i++) {
                const descEl = document.querySelector(`[name="Risk_discription${i}"]`);
                const impactEl = document.getElementById(`impact_score${i}`);
                const freqEl = document.getElementById(`freq_score${i}`);
                if (descEl) descEl.value = d[`risk_discription${i}`] || '';
                if (impactEl) impactEl.value = d[`impact_score${i}`] || '';
                if (freqEl) freqEl.value = d[`freq_score${i}`] || '';
                if (impactEl && freqEl) calcRisk(`impact_score${i}`, `freq_score${i}`, `risk_score${i}`);
            }

            // Date: keep the stored date if present, otherwise leave today's default
            if (d.date_of_submission) {
                const dateEl = document.getElementById('date');
                const dateHiddenEl = document.getElementById('date_hidden');
                const parsed = new Date(d.date_of_submission);
                if (dateEl) dateEl.innerHTML = formatDisplayDate(parsed);
                if (dateHiddenEl) dateHiddenEl.value = d.date_of_submission;
            }

            const banner = document.getElementById('draft_banner');
            if (banner) banner.textContent = `Editing draft ${d.form_no} — last saved ${new Date(d.drafted_at.replace(' ', 'T')).toLocaleString('en-IN')}`;
        })
        .catch(err => alert('Network error loading draft: ' + err.message));
}

// ── Form number with prefix ──────────────────────────────
function updateFormNumber() {
    fetch('../api/get_form_number.php')
        .then(res => res.text())
        .then(number => {
            const el = document.getElementById('formno');
            const hiddenEl = document.getElementById('formno_hidden');
            if (!el) return;
            const selected = document.querySelector('input[name="operation"]:checked');
            const year = new Date().getFullYear();
            let formattedNumber;
            if (selected && selected.value.toLowerCase() === 'complaint') {
                formattedNumber = `COMP-${year}-${number}`;
            } else if (selected && selected.value.toLowerCase() === 'feedback') {
                formattedNumber = `FB-${year}-${number}`;
            } else if (selected && selected.value.toLowerCase() === 'non-conforming activity') {
                formattedNumber = `NCA-${year}-${number}`;
            } else {
                formattedNumber = `FORM-${year}-${number}`;
            }
            el.textContent = formattedNumber;
            if (hiddenEl) hiddenEl.value = formattedNumber;
        })
        .catch(err => console.error('Could not load form number:', err));
}

// ── Save as Draft (no validation required) ───────────────
function saveDraft() {
    const btn = event.target;
    btn.disabled = true;
    btn.textContent = "Saving...";

    const formData = new FormData(document.querySelector('form'));
    formData.append('csrf_token', getCsrfToken());

    fetch('../api/save_draft.php', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                document.getElementById('draft_id_hidden').value = data.draft_id;
                document.body.classList.add('completing-draft');
                alert('Draft saved.');
            } else {
                alert('Error: ' + data.error);
            }
            btn.disabled = false;
            btn.textContent = "Save as Draft";
        })
        .catch(err => {
            alert('Network error: ' + err.message);
            btn.disabled = false;
            btn.textContent = "Save as Draft";
        });
}

// ── Form validation ──────────────────────────────────────
function validateform() {
    const operation = [...document.querySelectorAll('input[name="operation"]:checked')]
        .map(cb => cb.value);
    const given_by = document.getElementById("given_by").value;
    const department_section = document.getElementById("department_section").value;
    const incident_description = document.getElementById("incident_description").value;
    const main_category = document.getElementById("main_category").value;
    const root_cause = document.getElementById("root_cause").value;
    const immediate_correction = document.getElementById("immediate_correction").value;
    const corrective_action = document.getElementById("corrective_action").value;

    let anyRiskRowFilled = false;
    for (let i = 1; i <= 5; i++) {
        const impact = document.getElementById('impact_score' + i).value;
        const freq = document.getElementById('freq_score' + i).value;
        if (impact && freq) {
            anyRiskRowFilled = true;
            break;
        }
    }

    let operation_empty = document.getElementById("operation_empty");
    let given_by_empty = document.getElementById("given_by_empty");
    let department_section_empty = document.getElementById("department_section_empty");
    let incident_description_empty = document.getElementById("incident_description_empty");
    let main_category_empty = document.getElementById("main_category_empty");
    let root_cause_empty = document.getElementById("root_cause_empty");
    let immediate_correction_empty = document.getElementById("immediate_correction_empty");
    let corrective_action_empty = document.getElementById("corrective_action_empty");
    let risk_score_evaluation = document.getElementById("risk_score_evaluation");

    let valid = true;
    let missingFields = [];
    let firstErrorSection = null;

    [operation_empty, given_by_empty, department_section_empty,
        incident_description_empty, main_category_empty, root_cause_empty,
        immediate_correction_empty, corrective_action_empty,
        risk_score_evaluation
    ].forEach(el => { if (el) el.textContent = ""; });

    if (operation.length === 0) {
        operation_empty.textContent = "Choose an operation!";
        missingFields.push("Operation");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 0;
    }
    if (!given_by) {
        given_by_empty.textContent = "Choose an option!";
        missingFields.push("Given by");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 0;
    }
    if (!department_section) {
        department_section_empty.textContent = "Choose an option!";
        missingFields.push("Department/Section");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 1;
    }
    if (!incident_description.trim()) {
        incident_description_empty.textContent = "Cannot be left empty!";
        missingFields.push("Incident Description");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 1;
    }
    if (!main_category) {
        main_category_empty.textContent = "Choose an option!";
        missingFields.push("Error Category");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 2;
    }
    if (!root_cause.trim()) {
        root_cause_empty.textContent = "Cannot be left empty!";
        missingFields.push("Root Cause");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 3;
    }
    if (!anyRiskRowFilled) {
        risk_score_evaluation.textContent = "Fill at least one risk row!";
        missingFields.push("Risk Score (at least one row)");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 4;
    }
    if (!immediate_correction.trim()) {
        immediate_correction_empty.textContent = "Cannot be left empty!";
        missingFields.push("Immediate Correction");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 5;
    }
    if (!corrective_action.trim()) {
        corrective_action_empty.textContent = "Cannot be left empty!";
        missingFields.push("Corrective Action");
        valid = false;
        if (firstErrorSection === null) firstErrorSection = 5;
    }

    if (!valid) {
        alert("Please fill the following required fields:\n\n• " + missingFields.join("\n• "));
        openSection(firstErrorSection);
        return false;
    }

    const submitBtn = document.querySelector('button[type="submit"]');
    submitBtn.disabled = true;
    submitBtn.textContent = "Submitting...";

    const formData = new FormData(document.querySelector('form'));
    formData.append('csrf_token', getCsrfToken());

    fetch('../api/submit.php', {
        method: 'POST',
        body: formData
    })
        .then(res => {
            return res.text().then(text => ({ status: res.status, ok: res.ok, text }));
        })
        .then(({ status, ok, text }) => {
            let data;
            try {
                data = JSON.parse(text);
            } catch (parseErr) {
                console.error('Could not parse JSON:', parseErr);
                alert('Server returned an unexpected response.');
                submitBtn.disabled = false;
                submitBtn.textContent = "Submit";
                return;
            }

            if (data.success) {
                alert('Form submitted successfully!');
                document.querySelector('form').reset();
                document.getElementById('draft_id_hidden').value = ''; // clear so next submit starts fresh
                updateSub();
                openSection(0);
                updateFormNumber();
            } else {
                alert('Error: ' + data.error);
            }
            submitBtn.disabled = false;
            submitBtn.textContent = "Submit";
        })
        .catch(err => {
            console.error('Fetch failed:', err);
            alert('Network error: ' + err.message);
            submitBtn.disabled = false;
            submitBtn.textContent = "Submit";
        });

    return false;
}

// ── Risk description pop-out (bypasses table/fieldset overflow clipping) ──
function initRiskDescPopouts() {
    const popout = document.createElement('textarea');
    popout.className = 'risk-desc-popout';
    document.body.appendChild(popout);

    let activeField = null;

    function openPopout(field) {
        activeField = field;
        const rect = field.getBoundingClientRect();
        popout.value = field.value;
        popout.style.display = 'block';
        popout.style.top = `${rect.top + window.scrollY}px`;
        popout.style.left = `${rect.left + window.scrollX}px`;
        popout.focus();
        popout.selectionStart = popout.selectionEnd = popout.value.length;
    }

    function closePopout() {
        if (activeField) activeField.value = popout.value;
        popout.style.display = 'none';
        activeField = null;
    }

    document.querySelectorAll('.risk-desc').forEach(field => {
        field.addEventListener('focus', () => openPopout(field));
    });

    popout.addEventListener('input', () => {
        if (activeField) activeField.value = popout.value;
    });

    popout.addEventListener('blur', closePopout);
}

// ── Init ─────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    // Set today's date
    const d = new Date();
    const el = document.getElementById("date");
    const hiddenEl = document.getElementById("date_hidden");
    if (el) el.innerHTML = formatDisplayDate(d);
    if (hiddenEl) {
        const yyyy = d.getFullYear();
        const mm = String(d.getMonth() + 1).padStart(2, '0');
        const dd = String(d.getDate()).padStart(2, '0');
        hiddenEl.value = `${yyyy}-${mm}-${dd}`;
    }

    for (let i = 1; i <= 5; i++) {
        const impactEl = document.getElementById('impact_score' + i);
        const freqEl = document.getElementById('freq_score' + i);
        if (impactEl && freqEl) {
            impactEl.addEventListener('input', function () {
                calcRisk('impact_score' + i, 'freq_score' + i, 'risk_score' + i);
            });
            freqEl.addEventListener('input', function () {
                calcRisk('impact_score' + i, 'freq_score' + i, 'risk_score' + i);
            });
        }
    }

    initRiskDescPopouts();

    const params = new URLSearchParams(window.location.search);
    const draftId = params.get('draft_id');

    // Populate all selects first, THEN load draft or set form number,
    // so loadDraft() has real <option> elements to assign values into.
    populateFieldOptions().then(() => {
        if (draftId) {
            loadDraft(draftId);
        } else {
            updateFormNumber();
        }
    });

    document.querySelectorAll('input[name="operation"]').forEach(cb => {
        cb.addEventListener('change', updateFormNumber);
    });

    // Show submitted by
    fetch('../api/check_session.php')
        .then(res => res.json())
        .then(result => {
            const el = document.getElementById('submitted_by_display');
            if (el && result.employee_id) {
                el.textContent = result.employee_id;
            }
        });
});
