SELECT
    ds.study_id,
    ds.study_code,
    ds.study_title,
    ds.study_phase,
    ds.therapeutic_area,
    ds.drug_name,
    smd.study_site_id,
    smd.site_number,
    smd.site_name,
    smd.principal_investigator,
    smd.site_status,
    smd.site_target_enrollment,
    smd.site_actual_enrollment,
    COUNT(DISTINCT smd.monitoring_visit_id)                                         AS total_monitoring_visits,
    SUM(CASE WHEN smd.visit_status = 'Completed' THEN 1 ELSE 0 END)                AS completed_visits,
    SUM(CASE WHEN smd.visit_status = 'Planned'   THEN 1 ELSE 0 END)                AS planned_visits,
    SUM(CASE WHEN smd.visit_status = 'Cancelled'  THEN 1 ELSE 0 END)               AS cancelled_visits,
    SUM(smd.findings_count)                                                         AS total_findings,
    SUM(smd.critical_findings_count)                                                AS total_critical_findings,
    ROUND(
        SUM(smd.critical_findings_count) * 100.0
        / NULLIF(SUM(smd.findings_count), 0), 2
    )                                                                               AS critical_findings_pct,
    SUM(CASE WHEN smd.follow_up_required = 'Y' THEN 1 ELSE 0 END)                  AS visits_needing_follow_up,
    MIN(smd.actual_start_date)                                                      AS first_visit_date,
    MAX(smd.actual_end_date)                                                        AS last_visit_date,
    ROUND(
        (smd.site_actual_enrollment * 100.0)
        / NULLIF(smd.site_target_enrollment, 0), 2
    )                                                                               AS site_enrollment_pct,
    CURRENT_TIMESTAMP                                                               AS publish_timestamp
FROM unified.drug_studies ds
LEFT JOIN unified.site_monitoring_detail smd
    ON ds.study_id = smd.study_id
GROUP BY
    ds.study_id,
    ds.study_code,
    ds.study_title,
    ds.study_phase,
    ds.therapeutic_area,
    ds.drug_name,
    smd.study_site_id,
    smd.site_number,
    smd.site_name,
    smd.principal_investigator,
    smd.site_status,
    smd.site_target_enrollment,
    smd.site_actual_enrollment
