SELECT
    ds.study_id,
    ds.study_code,
    ds.study_title,
    ds.study_phase,
    ds.therapeutic_area,
    ds.drug_name,
    dp.dosage_form,
    dp.strength,
    dp.strength_unit,
    scm.country_code,
    scm.country_name,
    scm.regulatory_authority,
    scm.country_status,
    COUNT(DISTINCT rs.submission_id)                                              AS total_submissions,
    SUM(CASE WHEN rs.review_status = 'Approved'  THEN 1 ELSE 0 END)             AS approved_count,
    SUM(CASE WHEN rs.review_status = 'Pending'   THEN 1 ELSE 0 END)             AS pending_count,
    SUM(CASE WHEN rs.review_status = 'Rejected'  THEN 1 ELSE 0 END)             AS rejected_count,
    MIN(rs.submission_date)                                                       AS earliest_submission_date,
    MAX(rs.approval_date)                                                         AS latest_approval_date,
    DATEDIFF(MAX(rs.approval_date), MIN(rs.submission_date))                      AS avg_approval_days,
    scm.planned_sites                                                             AS country_planned_sites,
    scm.active_sites                                                              AS country_active_sites,
    scm.first_patient_in_date,
    scm.last_patient_out_date,
    CURRENT_TIMESTAMP                                                             AS publish_timestamp
FROM unified.drug_studies ds
LEFT JOIN unified.regulatory_submission rs
    ON ds.study_id = rs.study_id
LEFT JOIN unified.drug_product dp
    ON rs.drug_product_id = dp.drug_product_id
LEFT JOIN unified.study_country_milestone scm
    ON ds.study_id = scm.study_id
    AND rs.country_code = scm.country_code
GROUP BY
    ds.study_id,
    ds.study_code,
    ds.study_title,
    ds.study_phase,
    ds.therapeutic_area,
    ds.drug_name,
    dp.dosage_form,
    dp.strength,
    dp.strength_unit,
    scm.country_code,
    scm.country_name,
    scm.regulatory_authority,
    scm.country_status,
    scm.planned_sites,
    scm.active_sites,
    scm.first_patient_in_date,
    scm.last_patient_out_date
