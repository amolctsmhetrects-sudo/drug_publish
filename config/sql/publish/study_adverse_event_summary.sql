SELECT
    ds.study_id,
    ds.study_code,
    ds.study_title,
    ds.study_phase,
    ds.therapeutic_area,
    ds.indication,
    ds.drug_name,
    ae.severity,
    ae.seriousness,
    ae.causality_assessment,
    ae.outcome,
    COUNT(DISTINCT ae.adverse_event_id)                                     AS total_adverse_events,
    COUNT(DISTINCT ae.patient_id)                                           AS patients_with_ae,
    SUM(CASE WHEN ae.seriousness = 'Serious' THEN 1 ELSE 0 END)            AS serious_ae_count,
    SUM(CASE WHEN ae.seriousness = 'Non-Serious' THEN 1 ELSE 0 END)        AS non_serious_ae_count,
    SUM(CASE WHEN ae.severity = 'Severe' THEN 1 ELSE 0 END)                AS severe_ae_count,
    SUM(CASE WHEN ae.severity = 'Moderate' THEN 1 ELSE 0 END)              AS moderate_ae_count,
    SUM(CASE WHEN ae.severity = 'Mild' THEN 1 ELSE 0 END)                  AS mild_ae_count,
    SUM(CASE WHEN ae.causality_assessment = 'Related' THEN 1 ELSE 0 END)   AS related_ae_count,
    MIN(ae.onset_date)                                                      AS earliest_ae_onset,
    MAX(ae.onset_date)                                                      AS latest_ae_onset,
    ROUND(
        (COUNT(DISTINCT ae.patient_id) * 100.0)
        / NULLIF(ds.actual_enrollment, 0), 2
    )                                                                       AS ae_incidence_rate_pct,
    CURRENT_TIMESTAMP                                                       AS publish_timestamp
FROM unified.drug_studies ds
LEFT JOIN unified.adverse_event ae
    ON ds.study_id = ae.study_id
GROUP BY
    ds.study_id,
    ds.study_code,
    ds.study_title,
    ds.study_phase,
    ds.therapeutic_area,
    ds.indication,
    ds.drug_name,
    ae.severity,
    ae.seriousness,
    ae.causality_assessment,
    ae.outcome,
    ds.actual_enrollment
