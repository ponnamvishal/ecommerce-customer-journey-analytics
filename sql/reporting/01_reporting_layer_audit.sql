
SELECT
    'rpt_conversion_analysis' AS table_name,
    COUNT(*) AS row_count
FROM reporting.rpt_conversion_analysis

UNION ALL

SELECT
    'rpt_customer_analysis',
    COUNT(*)
FROM reporting.rpt_customer_analysis

UNION ALL

SELECT
    'rpt_daily_analysis',
    COUNT(*)
FROM reporting.rpt_daily_analysis

UNION ALL

SELECT
    'rpt_event_transitions',
    COUNT(*)
FROM reporting.rpt_event_transitions

UNION ALL

SELECT
    'rpt_funnel_overview',
    COUNT(*)
FROM reporting.rpt_funnel_overview

UNION ALL

SELECT
    'rpt_hourly_analysis',
    COUNT(*)
FROM reporting.rpt_hourly_analysis

UNION ALL

SELECT
    'rpt_product_analysis',
    COUNT(*)
FROM reporting.rpt_product_analysis

ORDER BY table_name;

