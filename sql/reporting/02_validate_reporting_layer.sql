
WITH
customer_counts AS (
    SELECT COUNT(*)::numeric AS analytics_value
    FROM analytics.customer_segments
),
reporting_customer_counts AS (
    SELECT COUNT(*)::numeric AS reporting_value
    FROM reporting.rpt_customer_analysis
),
customer_revenue AS (
    SELECT COALESCE(SUM(total_revenue), 0)::numeric AS analytics_value
    FROM analytics.customer_segments
),
reporting_customer_revenue AS (
    SELECT COALESCE(SUM(total_revenue), 0)::numeric AS reporting_value
    FROM reporting.rpt_customer_analysis
),
conversion_counts AS (
    SELECT COUNT(*)::numeric AS analytics_value
    FROM analytics.customer_conversion
),
reporting_conversion_counts AS (
    SELECT COALESCE(SUM(customers), 0)::numeric AS reporting_value
    FROM reporting.rpt_conversion_analysis
),
daily_totals AS (
    SELECT
        COALESCE(SUM(total_events), 0)::numeric AS events,
        COALESCE(SUM(views), 0)::numeric AS views,
        COALESCE(SUM(carts), 0)::numeric AS carts,
        COALESCE(SUM(purchases), 0)::numeric AS purchases
    FROM analytics.daily_performance
),
reporting_daily_totals AS (
    SELECT
        COALESCE(SUM(total_events), 0)::numeric AS events,
        COALESCE(SUM(views), 0)::numeric AS views,
        COALESCE(SUM(carts), 0)::numeric AS carts,
        COALESCE(SUM(purchases), 0)::numeric AS purchases
    FROM reporting.rpt_daily_analysis
),
product_totals AS (
    SELECT
        COUNT(*)::numeric AS product_count,
        COALESCE(SUM(purchase_revenue), 0)::numeric AS revenue
    FROM analytics.product_performance
),
reporting_product_totals AS (
    SELECT
        COUNT(*)::numeric AS product_count,
        COALESCE(SUM(purchase_revenue), 0)::numeric AS revenue
    FROM reporting.rpt_product_analysis
),
checks AS (
    SELECT
        'customer_count' AS check_name,
        c.analytics_value,
        r.reporting_value
    FROM customer_counts c
    CROSS JOIN reporting_customer_counts r

    UNION ALL

    SELECT
        'customer_revenue',
        c.analytics_value,
        r.reporting_value
    FROM customer_revenue c
    CROSS JOIN reporting_customer_revenue r

    UNION ALL

    SELECT
        'conversion_bucket_customers',
        c.analytics_value,
        r.reporting_value
    FROM conversion_counts c
    CROSS JOIN reporting_conversion_counts r

    UNION ALL

    SELECT 'daily_event_total', d.events, rd.events
    FROM daily_totals d
    CROSS JOIN reporting_daily_totals rd

    UNION ALL

    SELECT 'daily_views', d.views, rd.views
    FROM daily_totals d
    CROSS JOIN reporting_daily_totals rd

    UNION ALL

    SELECT 'daily_carts', d.carts, rd.carts
    FROM daily_totals d
    CROSS JOIN reporting_daily_totals rd

    UNION ALL

    SELECT 'daily_purchases', d.purchases, rd.purchases
    FROM daily_totals d
    CROSS JOIN reporting_daily_totals rd

    UNION ALL

    SELECT 'product_count', p.product_count, rp.product_count
    FROM product_totals p
    CROSS JOIN reporting_product_totals rp

    UNION ALL

    SELECT 'product_revenue', p.revenue, rp.revenue
    FROM product_totals p
    CROSS JOIN reporting_product_totals rp
)
SELECT
    check_name,
    analytics_value,
    reporting_value,
    analytics_value = reporting_value AS matches
FROM checks
ORDER BY check_name;

