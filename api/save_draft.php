<?php
require_once __DIR__ . '/../session_init.php';
require_once __DIR__ . '/../csrf.php';
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);

if (!isset($_SESSION['employee_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Unauthorized']);
    exit;
}
csrf_verify();

include '../connection.php';

$submitted_by = $_SESSION['employee_id'];

function toNullable($value)
{
    return ($value === "" || $value === null) ? null : $value;
}

$draft_id = trim($_POST["draft_id"] ?? "");

$fields = [
    'form_no'               => trim($_POST["form_no"] ?? ""),
    'Operation'             => trim($_POST["operation"] ?? ""),
    'Given_by'              => trim($_POST["given_by"] ?? ""),
    'Date_of_submission'    => toNullable(trim($_POST["date"] ?? "")),
    'Depatment_section'     => trim($_POST["department_section"] ?? ""),
    'Incident_description'  => trim($_POST["incident_description"] ?? ""),
    'Main_Error_category'   => trim($_POST["main_category"] ?? ""),
    'Sub_Error_categor'     => trim($_POST["pre_analytic_error"] ?? $_POST["analytic_error"] ?? $_POST["post_analytic_error"] ?? $_POST["no_lab_error"] ?? ""),
    'active_error'          => isset($_POST["active_error"]) ? "yes" : "no",
    'latent_error'          => isset($_POST["latent_error"]) ? "yes" : "no",
    'cognitive_error'       => isset($_POST["cognitive_error"]) ? "yes" : "no",
    'non_cognitive_error'   => isset($_POST["non_cognitive_error"]) ? "yes" : "no",
    'Root_cause'            => trim($_POST["root_cause"] ?? ""),
    'avg_impact_score'      => toNullable(trim($_POST["impact_score"] ?? "")),
    'avg_freq_score'        => toNullable(trim($_POST["freq_score"] ?? "")),
    'avg_risk_score'        => toNullable(trim($_POST["risk_score"] ?? "")),
    'immediate_correction'  => trim($_POST["immediate_correction"] ?? ""),
    'corrective_action'     => trim($_POST["corrective_action"] ?? ""),
    'preventive_action'     => toNullable(trim($_POST["preventive_action"] ?? "")),
    'patient_consequences'  => toNullable(trim($_POST["patient_consequences"] ?? "")),
    'Risk_discription1'     => trim($_POST["Risk_discription1"] ?? ""),
    'impact_score1'         => toNullable(trim($_POST["impact_score1"] ?? "")),
    'freq_score1'           => toNullable(trim($_POST["freq_score1"] ?? "")),
    'Risk_discription2'     => trim($_POST["Risk_discription2"] ?? ""),
    'impact_score2'         => toNullable(trim($_POST["impact_score2"] ?? "")),
    'freq_score2'           => toNullable(trim($_POST["freq_score2"] ?? "")),
    'Risk_discription3'     => trim($_POST["Risk_discription3"] ?? ""),
    'impact_score3'         => toNullable(trim($_POST["impact_score3"] ?? "")),
    'freq_score3'           => toNullable(trim($_POST["freq_score3"] ?? "")),
    'Risk_discription4'     => trim($_POST["Risk_discription4"] ?? ""),
    'impact_score4'         => toNullable(trim($_POST["impact_score4"] ?? "")),
    'freq_score4'           => toNullable(trim($_POST["freq_score4"] ?? "")),
    'Risk_discription5'     => trim($_POST["Risk_discription5"] ?? ""),
    'impact_score5'         => toNullable(trim($_POST["impact_score5"] ?? "")),
    'freq_score5'           => toNullable(trim($_POST["freq_score5"] ?? "")),
    'remarks'               => toNullable(trim($_POST["remarks"] ?? "")),
];

if (!empty($draft_id)) {
    // ---- UPDATE existing draft (only if it's still a draft AND owned by this user) ----
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
                drafted_at = NOW()
            WHERE id=$37 AND submitted_by=$38 AND status='draft'";

    $params = array_merge(array_values($fields), [$draft_id, $submitted_by]);
    $result = pg_query_params($conn, $sql, $params);

    if ($result && pg_affected_rows($result) === 0) {
        // either not found, not theirs, or already submitted
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'This form can no longer be edited as a draft.']);
        pg_close($conn);
        exit;
    }

    $id = $draft_id;
} else {
    // ---- INSERT new draft ----
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
             submitted_by, status, drafted_at)
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,
                     $21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,
                     $36,
                     $37,'draft',NOW())
            RETURNING id";

    $params = array_merge(array_values($fields), [$submitted_by]);
    $result = pg_query_params($conn, $sql, $params);

    if (!$result) {
        error_log("save_draft insert error: " . pg_last_error($conn));
        echo json_encode(['success' => false, 'error' => 'Could not save draft.']);
        pg_close($conn);
        exit;
    }
    $id = pg_fetch_result($result, 0, 'id');
}

echo json_encode(['success' => true, 'draft_id' => $id]);
pg_close($conn);