<?php
require_once __DIR__ . '/../session_init.php';
require_once __DIR__ . '/../csrf.php';
if (!isset($_SESSION['employee_id'])) {
    header('Location: ../index.html');
    exit;
}
$__csrf_token = csrf_token();
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="<?php echo htmlspecialchars($__csrf_token); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint and Feedback</title>
    <link rel="stylesheet" href="../style.css">
</head>

<body>
    <div class="container">
        <img src="../BBH-logo-1-1B.png" alt="" srcset="">
        <h1>Complaint and Feedback Form</h1>
        <p id="draft_banner" style="color:#555; font-style:italic;"></p>

        <form onsubmit="return validateform()">

            <!-- BASIC INFORMATION -->
            <div class="accordion-section open" data-section="0">
                <button type="button" class="accordion-header" onclick="toggleSection(0)">
                    <span class="accordion-icon">−</span>
                    <span>Basic Information</span>
                </button>
                <div class="accordion-content">
                    <fieldset class="boxes">
                        <table>
                            <tr class="blocks">
                                <td><label>Submitted By:</label></td>
                                <td><span id="submitted_by_display"></span></td>
                                <td></td>
                                <td>
                                    <span id="formno" class="formnobox"></span>
                                    <input type="hidden" name="form_no" id="formno_hidden">
                                    <input type="hidden" name="draft_id" id="draft_id_hidden">
                                </td>
                            </tr>
                            <tr class="blocks">
                                <td>Operation:<label class="necessary">*</label><label></label></td>
                                <td class="operation-group">
                                    <span class="operation-option">
                                        <input type="radio" name="operation" id="complaint" value="Complaint">
                                        <label for="complaint">Complaint</label>
                                    </span>
                                    <span class="operation-option">
                                        <input type="radio" name="operation" id="feedback" value="Feedback">
                                        <label for="feedback">Feedback</label>
                                    </span>
                                    <span class="operation-option">
                                        <input type="radio" name="operation" id="nca" value="Non-Conforming Activity">
                                        <label for="nca">Non-Conforming Activity</label>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="operation_empty" style="color:red;"></span></td>
                            </tr>
                            <tr class="blocks">
                                <td><label for="given_by">Given by:</label><label
                                        class="necessary">*</label><label></label></td>
                                <td>
                                    <select id="given_by" name="given_by">
                                        <option value="">-- Select --</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="given_by_empty" style="color:red;"></span></td>
                            </tr>
                            <tr class="blocks">
                                <td><label for="date">Date:</label></td>
                                <td>
                                    <span id="date"></span>
                                    <input type="hidden" name="date" id="date_hidden">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="formDate_empty" style="color:red;"></span></td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </div>

            <!-- INCIDENT DETAILS -->
            <div class="accordion-section" data-section="1">
                <button type="button" class="accordion-header" onclick="toggleSection(1)">
                    <span class="accordion-icon">+</span>
                    <span>Incident Details</span>
                </button>
                <div class="accordion-content">
                    <fieldset class="boxes">
                        <table>
                            <tr class="blocks">
                                <td><label for="department_section">Department / Section:</label><label
                                        class="necessary">*</label></td>
                                <td>
                                    <select id="department_section" name="department_section">
                                        <option value="">-- Select --</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="department_section_empty" style="color:red;"></span></td>
                            </tr>
                            <tr class="blocks">
                                <td><label for="incident_description">Incident Description:</label><label
                                        class="necessary">*</label></td>
                            </tr>
                            <tr class="blocks">
                                <td colspan="2">
                                    <textarea name="incident_description" id="incident_description" rows="10"
                                        placeholder="Describe the incident"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="incident_description_empty" style="color:red;"></span></td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </div>

            <!-- ERROR CLASSIFICATION -->
            <div class="accordion-section" data-section="2">
                <button type="button" class="accordion-header" onclick="toggleSection(2)">
                    <span class="accordion-icon">+</span>
                    <span>Error Classification</span>
                </button>
                <div class="accordion-content">
                    <fieldset class="boxes">
                        <table>
                            <tr class="blocks">
                                <td><label for="main_category">Examination Category:</label><label class="necessary">*</label>
                                </td>
                                <td>
                                    <select name="main_category" id="main_category" onchange="updateSub()">
                                        <option value="">-- Please select --</option>
                                        <option value="pre">Pre-Analytic Examination</option>
                                        <option value="analytic">Analytic Examination</option>
                                        <option value="post">Post-Analytic Examination</option>
                                        <option value="others">Clinically Not Correlating / No Lab Error / Others
                                        </option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="main_category_empty" style="color:red;"></span></td>
                            </tr>
                            <tr id="pre_row" style="display:none;" class="blocks">
                                <td><label for="pre_analytic_error">Pre-Analytic Examination:</label><label
                                        class="necessary">*</label></td>
                                <td>
                                    <select name="pre_analytic_error" id="pre_analytic_error">
                                        <option value="">-- Please select --</option>
                                    </select>
                                </td>
                            </tr>
                            <tr id="analytic_row" style="display:none;" class="blocks">
                                <td><label for="analytic_error">Analytic Examination:</label><label class="necessary">*</label></td>
                                <td>
                                    <select name="analytic_error" id="analytic_error">
                                        <option value="">-- Please select --</option>
                                    </select>
                                </td>
                            </tr>
                            <tr id="post_row" style="display:none;" class="blocks">
                                <td><label for="post_analytic_error">Post-Analytic Examination:</label><label class="necessary">*</label></td>
                                <td>
                                    <select name="post_analytic_error" id="post_analytic_error">
                                        <option value="">-- Please select --</option>
                                    </select>
                                </td>
                            </tr>
                            <tr id="others_row" style="display:none;" class="blocks">
                                <td><label for="no_lab_error">Clinically Not Correlating / No Lab Error / Others:</label><label class="necessary">*</label></td>
                                <td>
                                    <select name="no_lab_error" id="no_lab_error">
                                        <option value="">-- Please select --</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </div>

            <!-- ERROR ANALYSIS -->
            <div class="accordion-section" data-section="3">
                <button type="button" class="accordion-header" onclick="toggleSection(3)">
                    <span class="accordion-icon">+</span>
                    <span>Error Analysis</span>
                </button>
                <div class="accordion-content">
                    <fieldset class="boxes">
                        <table>
                            <tr class="blocks">
                                <td>Check from below:<label class="necessary">*</label></td>
                            </tr>
                            <tr class="blocks">
                                <td>
                                    <input type="checkbox" name="active_error" id="active_error">
                                    <label for="active_error">Active Error (front line / technician error)</label>
                                </td>
                            </tr>
                            <tr class="blocks">
                                <td>
                                    <input type="checkbox" name="latent_error" id="latent_error">
                                    <label for="latent_error">Latent Error (back end / underlying factors)</label>
                                </td>
                            </tr>
                            <tr class="blocks">
                                <td>
                                    <input type="checkbox" name="cognitive_error" id="cognitive_error">
                                    <label for="cognitive_error">Cognitive Error (insufficient knowledge)</label>
                                </td>
                            </tr>
                            <tr class="blocks">
                                <td>
                                    <input type="checkbox" name="non_cognitive_error" id="non_cognitive_error">
                                    <label for="non_cognitive_error">Non-Cognitive Error (slip / unconscious lapse)</label>
                                </td>
                            </tr>
                            <tr class="blocks">
                                <td><label for="root_cause">Root Cause:</label><label class="necessary">*</label></td>
                            </tr>
                            <tr class="blocks">
                                <td colspan="2">
                                    <textarea name="root_cause" id="root_cause" rows="10"
                                        placeholder="Describe the root cause"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="root_cause_empty" style="color:red;"></span></td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </div>

            <!-- RISK SCORE -->
            <div class="accordion-section" data-section="4">
                <button type="button" class="accordion-header" onclick="toggleSection(4)">
                    <span class="accordion-icon">+</span>
                    <span>Risk Score</span>
                </button>
                <div class="accordion-content">
                    <fieldset class="boxes">
                        <div class="risk-wrapper">
                            <div class="risk-left">
                                <table class="risk">
                                    <tr>
                                        <th>Risk Description</th>
                                        <th>Impact Score (0-5)</th>
                                        <th>Freq Score (0-5)</th>
                                        <th>Risk Score</th>
                                    </tr>
                                    <tr>
                                        <td class="risk-desc-cell"><textarea name="Risk_discription1" class="risk-desc" rows="1" placeholder="Describe the risk"></textarea></td>
                                        <td><input type="number" name="impact_score1" id="impact_score1" min="0" max="5"></td>
                                        <td><input type="number" name="freq_score1" id="freq_score1" min="0" max="5"></td>
                                        <td><span id="risk_score1"></span></td>
                                    </tr>
                                    <tr>
                                        <td class="risk-desc-cell"><textarea name="Risk_discription2" class="risk-desc" rows="1" placeholder="Describe the risk"></textarea></td>
                                        <td><input type="number" name="impact_score2" id="impact_score2" min="0" max="5"></td>
                                        <td><input type="number" name="freq_score2" id="freq_score2" min="0" max="5"></td>
                                        <td><span id="risk_score2"></span></td>
                                    </tr>
                                    <tr>
                                        <td class="risk-desc-cell"><textarea name="Risk_discription3" class="risk-desc" rows="1" placeholder="Describe the risk"></textarea></td>
                                        <td><input type="number" name="impact_score3" id="impact_score3" min="0" max="5"></td>
                                        <td><input type="number" name="freq_score3" id="freq_score3" min="0" max="5"></td>
                                        <td><span id="risk_score3"></span></td>
                                    </tr>
                                    <tr>
                                        <td class="risk-desc-cell"><textarea name="Risk_discription4" class="risk-desc" rows="1" placeholder="Describe the risk"></textarea></td>
                                        <td><input type="number" name="impact_score4" id="impact_score4" min="0" max="5"></td>
                                        <td><input type="number" name="freq_score4" id="freq_score4" min="0" max="5"></td>
                                        <td><span id="risk_score4"></span></td>
                                    </tr>
                                    <tr>
                                        <td class="risk-desc-cell"><textarea name="Risk_discription5" class="risk-desc" rows="1" placeholder="Describe the risk"></textarea></td>
                                        <td><input type="number" name="impact_score5" id="impact_score5" min="0" max="5"></td>
                                        <td><input type="number" name="freq_score5" id="freq_score5" min="0" max="5"></td>
                                        <td><span id="risk_score5"></span></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="risk-right">
                                <table>
                                    <tr class="blocks">
                                        <td><label for="impact_score">Average Impact Score (0–5):</label></td>
                                        <td><input type="number" name="impact_score" id="impact_score" min="0" max="5" readonly></td>
                                    </tr>
                                    <tr class="blocks">
                                        <td><label for="freq_score">Average Frequency Score (0–5):</label></td>
                                        <td><input type="number" name="freq_score" id="freq_score" min="0" max="5" readonly></td>
                                    </tr>
                                    <tr class="blocks">
                                        <td><label for="risk_score">Average Risk Score:</label></td>
                                        <td>
                                            <span id="risk_score"></span>
                                            <input type="hidden" name="risk_score" id="risk_score_hidden">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><span id="risk_score_evaluation" style="color:red;"></span></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>

            <!-- ACTIONS TAKEN -->
            <div class="accordion-section" data-section="5">
                <button type="button" class="accordion-header" onclick="toggleSection(5)">
                    <span class="accordion-icon">+</span>
                    <span>Actions Taken</span>
                </button>
                <div class="accordion-content">
                    <fieldset class="boxes">
                        <table>
                            <tr class="blocks">
                                <td><label for="immediate_correction">Immediate Correction:</label><label class="necessary">*</label></td>
                            </tr>
                            <tr class="blocks">
                                <td colspan="2">
                                    <textarea name="immediate_correction" id="immediate_correction" rows="10"
                                        placeholder="Describe the immediate correction taken"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="immediate_correction_empty" style="color:red;"></span></td>
                            </tr>
                            <tr class="blocks">
                                <td><label for="corrective_action">Corrective Action:</label><label class="necessary">*</label></td>
                            </tr>
                            <tr class="blocks">
                                <td colspan="2">
                                    <textarea name="corrective_action" id="corrective_action" rows="10"
                                        placeholder="To prevent recurrence of the same problem"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="corrective_action_empty" style="color:red;"></span></td>
                            </tr>
                            <tr class="blocks">
                                <td><label for="preventive_action">Preventive Action:</label></td>
                            </tr>
                            <tr class="blocks">
                                <td colspan="2">
                                    <textarea name="preventive_action" id="preventive_action" rows="10"
                                        placeholder="To prevent occurrence of similar problem"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="preventive_action_empty" style="color:red;"></span></td>
                            </tr>
                            <tr class="blocks">
                                <td>Patient Consequences:</td>
                            </tr>
                            <tr class="blocks">
                                <td>
                                    <input type="radio" name="patient_consequences" id="consequences_yes" value="yes">
                                    <label for="consequences_yes">Yes</label>
                                    <input type="radio" name="patient_consequences" id="consequences_no" value="no">
                                    <label for="consequences_no">No</label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><span id="patient_consequences_empty" style="color:red;"></span></td>
                            </tr>
                            <tr class="blocks">
                                <td><label for="remarks">Remarks:</label></td>
                            </tr>
                            <tr class="blocks">
                                <td colspan="2">
                                    <textarea name="remarks" id="remarks" rows="6"
                                        placeholder="Any additional remarks (optional)"></textarea>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </div>

            <!-- SUBMIT -->
            <div class="form-footer">
                <button type="button" onclick="saveDraft()">Save as Draft</button>
                <button type="submit">Submit</button>
                <a href="dashboard.php" class="btn-link">Back to Dashboard</a>
            </div>

        </form>
    </div>

    <script src="../js/auth-guard.js"></script>
    <script src="../js/form.js"></script>

</body>

</html>