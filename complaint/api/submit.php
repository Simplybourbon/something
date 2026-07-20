<?php
require_once __DIR__ . '/../session_init.php';
require_once __DIR__ . '/../csrf.php';
if (!isset($_SESSION['employee_id'])) {
    header('Content-Type: application/json');
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Unauthorized']);
    exit;
}
csrf_verify();

include '../connection.php';

header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);

// ---- Get submitted_by from session ----
$submitted_by = $_SESSION['employee_id'];

// ---- Collect POST data ----
$remarks              = trim($_POST["remarks"] ?? "");
$draft_id             = trim($_POST["draft_id"] ?? "");
$Operation            = trim($_POST["operation"] ?? "");
$form_no              = trim($_POST["form_no"] ?? "");
$Given_by             = trim($_POST["given_by"] ?? "");
$Date_of_submission   = trim($_POST["date"] ?? "");
$Depatment_Section    = trim($_POST["department_section"] ?? "");
$incident_description = trim($_POST["incident_description"] ?? "");
$main_category        = trim($_POST["main_category"] ?? "");
$active_error         = isset($_POST["active_error"]) ? "yes" : "no";
$latent_error         = isset($_POST["latent_error"]) ? "yes" : "no";
$cognitive_error      = isset($_POST["cognitive_error"]) ? "yes" : "no";
$non_cognitive_error  = isset($_POST["non_cognitive_error"]) ? "yes" : "no";
$root_cause           = trim($_POST["root_cause"] ?? "");
$immediate_correction = trim($_POST["immediate_correction"] ?? "");
$corrective_action    = trim($_POST["corrective_action"] ?? "");
$preventive_action    = trim($_POST["preventive_action"] ?? "");
$patient_consequences = trim($_POST["patient_consequences"] ?? "");

$avg_impact_score     = trim($_POST["impact_score"] ?? "");
$avg_freq_score       = trim($_POST["freq_score"] ?? "");
$avg_risk_score       = trim($_POST["risk_score"] ?? "");

$Risk_discription1    = trim($_POST["Risk_discription1"] ?? "");
$Risk_discription2    = trim($_POST["Risk_discription2"] ?? "");
$Risk_discription3    = trim($_POST["Risk_discription3"] ?? "");
$Risk_discription4    = trim($_POST["Risk_discription4"] ?? "");
$Risk_discription5    = trim($_POST["Risk_discription5"] ?? "");
$impact_score1        = trim($_POST["impact_score1"] ?? "");
$impact_score2        = trim($_POST["impact_score2"] ?? "");
$impact_score3        = trim($_POST["impact_score3"] ?? "");
$impact_score4        = trim($_POST["impact_score4"] ?? "");
$impact_score5        = trim($_POST["impact_score5"] ?? "");
$freq_score1          = trim($_POST["freq_score1"] ?? "");
$freq_score2          = trim($_POST["freq_score2"] ?? "");
$freq_score3          = trim($_POST["freq_score3"] ?? "");
$freq_score4          = trim($_POST["freq_score4"] ?? "");
$freq_score5          = trim($_POST["freq_score5"] ?? "");

$sub_error = "";
if ($main_category === "pre") {
    $sub_error = trim($_POST["pre_analytic_error"] ?? "");
} elseif ($main_category === "analytic") {
    $sub_error = trim($_POST["analytic_error"] ?? "");
} elseif ($main_category === "post") {
    $sub_error = trim($_POST["post_analytic_error"] ?? "");
} elseif ($main_category === "others") {
    $sub_error = trim($_POST["no_lab_error"] ?? "");
}

// ---- VALIDATION ----
$errors = [];

if (empty($Operation))            $errors[] = "Operation is required";
if (empty($Given_by))             $errors[] = "Given by is required";
if (empty($Date_of_submission))   $errors[] = "Date is required";
if (empty($Depatment_Section))    $errors[] = "Department/Section is required";
if (empty($incident_description)) $errors[] = "Incident description is required";
if (empty($main_category))        $errors[] = "Error category is required";
if (empty($sub_error))            $errors[] = "Sub error category is required";
if (empty($root_cause))           $errors[] = "Root cause is required";
if (empty($immediate_correction)) $errors[] = "Immediate correction is required";
if (empty($corrective_action))    $errors[] = "Corrective action is required";

$valid_operations = ["Complaint", "Feedback", "Non-Conforming Activity"];
if (!empty($Operation) && !in_array($Operation, $valid_operations))
    $errors[] = "Invalid operation value";

function isValidOption($conn, $field_name, $value)
{
    if (empty($value)) return true;
    $check = pg_query_params($conn, "SELECT 1 FROM form_field_options WHERE field_name = $1 AND option_value = $2", [$field_name, $value]);
    return $check && pg_num_rows($check) > 0;
}

if (!isValidOption($conn, 'given_by', $Given_by))
    $errors[] = "Invalid 'Given by' value";

if (!isValidOption($conn, 'department_section', $Depatment_Section))
    $errors[] = "Invalid department/section value";

$valid_main_categories = ["pre", "analytic", "post", "others"];
if (!empty($main_category) && !in_array($main_category, $valid_main_categories))
    $errors[] = "Invalid error category value";

$valid_consequences = ["yes", "no"];
if (!empty($patient_consequences) && !in_array($patient_consequences, $valid_consequences))
    $errors[] = "Invalid patient consequences value";

if (!empty($Date_of_submission)) {
    $d = DateTime::createFromFormat('Y-m-d', $Date_of_submission);
    if (!$d || $d->format('Y-m-d') !== $Date_of_submission) {
        $errors[] = "Invalid date format";
    } elseif ($d > new DateTime()) {
        $errors[] = "Date cannot be in the future";
    }
}

if (strlen($remarks) > 5000)
    $errors[] = "Remarks is too long (max 5000 characters)";

$range_score_fields = [
    'Average Impact Score' => $avg_impact_score,
    'Average Frequency Score' => $avg_freq_score,
    'Impact Score 1' => $impact_score1,
    'Freq Score 1' => $freq_score1,
    'Impact Score 2' => $impact_score2,
    'Freq Score 2' => $freq_score2,
    'Impact Score 3' => $impact_score3,
    'Freq Score 3' => $freq_score3,
    'Impact Score 4' => $impact_score4,
    'Freq Score 4' => $freq_score4,
    'Impact Score 5' => $impact_score5,
    'Freq Score 5' => $freq_score5,
];
foreach ($range_score_fields as $label => $value) {
    if ($value !== "" && (!is_numeric($value) || $value < 0 || $value > 5))
        $errors[] = "$label must be a number between 0 and 5";
}

if ($avg_risk_score !== "" && (!is_numeric($avg_risk_score) || $avg_risk_score < 0 || $avg_risk_score > 25))
    $errors[] = "Average Risk Score must be a number between 0 and 25";

if ($impact_score1 === "" || $freq_score1 === "")
    $errors[] = "Risk Score row 1 (Impact and Frequency) is required";

$text_fields = [
    'Incident description' => $incident_description,
    'Root cause' => $root_cause,
    'Immediate correction' => $immediate_correction,
    'Corrective action' => $corrective_action,
    'Preventive action' => $preventive_action,
];
foreach ($text_fields as $label => $value) {
    if (strlen($value) > 5000)
        $errors[] = "$label is too long (max 5000 characters)";
}

if (!empty($errors)) {
    echo json_encode(['success' => false, 'error' => implode(", ", $errors)]);
    pg_close($conn);
    exit;
}

// ---- Convert empty strings to NULL for numeric PostgreSQL columns ----
function toNullable($value)
{
    return ($value === "" || $value === null) ? null : $value;
}

if (!empty($draft_id)) {
    // ---- Finalize an existing draft: must still be a draft owned by this user ----
    // Placeholders: $1-$35 unchanged fields, $36 = remarks (NEW), $37 = id, $38 = submitted_by
    $sql = "UPDATE feedback_complaint_data SET
                form_no=$1, Operation=$2, Given_by=$3, Date_of_submission=$4, Depatment_section=$5,
                Incident_description=$6, Main_Error_category=$7, Sub_Error_categor=$8,
                active_error=$9, latent_error=$10, cognitive_error=$11, non_cognitive_error=$12,
                Root_cause=$13, avg_impact_score=$14, avg_freq_score=$15, avg_risk_score=$16,
                immediate_correction=$17, corrective_action=$18, preventive_action=$19, patient_consequences=$20,
                Risk_discription1=$21, impact_score1=$22, freq_score1=$23,
                Risk_discription2=$24, impact_score2=$25, freq_score2=$26,
                Risk_discription3=$27, impact_score3=$28, freq_score3=$29,
                Risk_discription4=$30, impact_score4=$31, freq_score4=$32,
                Risk_discription5=$33, impact_score5=$34, freq_score5=$35,
                remarks=$36,
                status='submitted', submitted_at=NOW()
            WHERE id=$37 AND submitted_by=$38 AND status='draft'";

    $params = [
        $form_no,
        $Operation,
        $Given_by,
        $Date_of_submission,
        $Depatment_Section,
        $incident_description,
        $main_category,
        $sub_error,
        $active_error,
        $latent_error,
        $cognitive_error,
        $non_cognitive_error,
        $root_cause,
        toNullable($avg_impact_score),
        toNullable($avg_freq_score),
        toNullable($avg_risk_score),
        $immediate_correction,
        $corrective_action,
        toNullable($preventive_action),
        toNullable($patient_consequences),
        $Risk_discription1,
        toNullable($impact_score1),
        toNullable($freq_score1),
        $Risk_discription2,
        toNullable($impact_score2),
        toNullable($freq_score2),
        $Risk_discription3,
        toNullable($impact_score3),
        toNullable($freq_score3),
        $Risk_discription4,
        toNullable($impact_score4),
        toNullable($freq_score4),
        $Risk_discription5,
        toNullable($impact_score5),
        toNullable($freq_score5),
        toNullable($remarks),
        $draft_id,
        $submitted_by,
    ];

    $result = pg_query_params($conn, $sql, $params);

    if ($result && pg_affected_rows($result) === 0) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'This draft can no longer be submitted (already finalized or not yours).']);
        pg_close($conn);
        exit;
    }
} else {
    // ---- Brand new submission (no draft involved) ----
    // Placeholders: $1-$35 unchanged fields, $36 = remarks (NEW), $37 = submitted_by
    $sql = "INSERT INTO feedback_complaint_data 
            (form_no, Operation, Given_by, Date_of_submission, Depatment_section, 
             Incident_description, Main_Error_category, Sub_Error_categor,
             active_error, latent_error, cognitive_error, non_cognitive_error,
             Root_cause, avg_impact_score, avg_freq_score, avg_risk_score,
             immediate_correction, corrective_action, preventive_action, patient_consequences,
             Risk_discription1, impact_score1, freq_score1,
             Risk_discription2, impact_score2, freq_score2,
             Risk_discription3, impact_score3, freq_score3,
             Risk_discription4, impact_score4, freq_score4,
             Risk_discription5, impact_score5, freq_score5,
             remarks,
             submitted_by, status, submitted_at)
            VALUES
            ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,
             $21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,
             $36,
             $37,'submitted',NOW())";

    $params = [
        $form_no,
        $Operation,
        $Given_by,
        $Date_of_submission,
        $Depatment_Section,
        $incident_description,
        $main_category,
        $sub_error,
        $active_error,
        $latent_error,
        $cognitive_error,
        $non_cognitive_error,
        $root_cause,
        toNullable($avg_impact_score),
        toNullable($avg_freq_score),
        toNullable($avg_risk_score),
        $immediate_correction,
        $corrective_action,
        toNullable($preventive_action),
        toNullable($patient_consequences),
        $Risk_discription1,
        toNullable($impact_score1),
        toNullable($freq_score1),
        $Risk_discription2,
        toNullable($impact_score2),
        toNullable($freq_score2),
        $Risk_discription3,
        toNullable($impact_score3),
        toNullable($freq_score3),
        $Risk_discription4,
        toNullable($impact_score4),
        toNullable($freq_score4),
        $Risk_discription5,
        toNullable($impact_score5),
        toNullable($freq_score5),
        toNullable($remarks),
        $submitted_by,
    ];

    $result = pg_query_params($conn, $sql, $params);
}

if ($result) {
    echo json_encode(['success' => true]);
} else {
    error_log("SQL Error: " . pg_last_error($conn));
    echo json_encode(['success' => false, 'error' => 'Something went wrong. Please try again.']);
}

pg_close($conn);