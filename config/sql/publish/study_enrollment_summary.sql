SELECT
    ds.study_id,
    ds.study_code,
    ds.study_title,
    ds.study_phase,
    ds.therapeutic_area,
    ds.indication,
    ds.drug_name,
    ds.study_status,
    dp.dosage_form,
    dp.route_of_administration,
    pe.gender,
    pe.randomization_group,
    pe.enrollment_status,
    COUNT(DISTINCT pe.patient_id)                                       AS total_patients,
    SUM(CASE WHEN pe.enrollment_status = 'Enrolled' THEN 1 ELSE 0 END) AS enrolled_count,
    SUM(CASE WHEN pe.enrollment_status = 'Withdrawn' THEN 1 ELSE 0 END) AS withdrawn_count,
    ROUND(AVG(pe.age_at_enrollment), 1)                                 AS avg_age_at_enrollment,
    MIN(pe.enrollment_date)                                             AS first_enrollment_date,
    MAX(pe.enrollment_date)                                             AS last_enrollment_date,
    ds.target_enrollment,
    ds.actual_enrollment,
    ROUND(
        (ds.actual_enrollment * 100.0) / NULLIF(ds.target_enrollment, 0), 2
    )                                                                   AS enrollment_pct,
    CURRENT_TIMESTAMP                                                   AS publish_timestamp
FROM unified.drug_studies ds
LEFT JOIN unified.patient_enrollment pe
    ON ds.study_id = pe.study_id
LEFT JOIN unified.drug_product dp
    ON ds.study_id = dp.study_id
GROUP BY
    ds.study_id,
    ds.study_code,
    ds.study_title,
    ds.study_phase,
    ds.therapeutic_area,
    ds.indication,
    ds.drug_name,
    ds.study_status,
    dp.dosage_form,
    dp.route_of_administration,
    pe.gender,
    pe.randomization_group,
    pe.enrollment_status,
    ds.target_enrollment,
    ds.actual_enrollment
