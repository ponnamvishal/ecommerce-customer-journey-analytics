
WITH rebuilt AS (
    SELECT
        user_id,
        MIN(event_time) AS first_activity,
        MIN(event_time) FILTER (
            WHERE event_type = 'purchase'
        ) AS first_purchase
    FROM staging.events
    GROUP BY user_id
),
conversion_metrics AS (
    SELECT
        user_id,
        first_activity,
        first_purchase,
        CASE
            WHEN first_purchase IS NOT NULL
            THEN (
                EXTRACT(
                    EPOCH FROM (first_purchase - first_activity)
                ) / 3600
            )::numeric
            ELSE NULL
        END AS hours_to_first_purchase
    FROM rebuilt
),
classified AS (
    SELECT
        *,
        CASE
            WHEN first_purchase IS NULL
                THEN 'No Purchase'
            WHEN hours_to_first_purchase = 0
                THEN 'Immediate'
            WHEN hours_to_first_purchase <= 1
                THEN 'Within 1 Hour'
            WHEN hours_to_first_purchase <= 24
                THEN 'Within 24 Hours'
            WHEN hours_to_first_purchase <= 72
                THEN 'Within 3 Days'
            WHEN hours_to_first_purchase <= 168
                THEN 'Within 7 Days'
            ELSE 'More Than 7 Days'
        END AS conversion_bucket
    FROM conversion_metrics
),
differences AS (
    SELECT r.user_id
    FROM classified r
    FULL OUTER JOIN analytics.customer_conversion c
        ON r.user_id = c.user_id
    WHERE r.user_id IS NULL
       OR c.user_id IS NULL
       OR r.first_activity IS DISTINCT FROM c.first_activity
       OR r.first_purchase IS DISTINCT FROM c.first_purchase
       OR r.hours_to_first_purchase
            IS DISTINCT FROM c.hours_to_first_purchase
       OR r.conversion_bucket
            IS DISTINCT FROM c.conversion_bucket
)
SELECT
    (SELECT COUNT(*) FROM analytics.customer_conversion)
        AS existing_customer_rows,
    (SELECT COUNT(*) FROM differences)
        AS customers_with_differences;