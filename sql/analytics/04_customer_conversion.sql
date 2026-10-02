
/*
File: 04_customer_conversion.sql
Purpose: Reconstruct customer conversion timing and buckets.

Source: staging.events
Reference: analytics.customer_conversion

Read-only reconstruction.
Bucket classification uses unrounded elapsed time.
*/

WITH customer_activity AS (
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
    FROM customer_activity
)
SELECT
    user_id,
    first_activity,
    first_purchase,
    hours_to_first_purchase,
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
FROM conversion_metrics;