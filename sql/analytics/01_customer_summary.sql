/*
File: 01_customer_summary.sql
Purpose: Reconstruct customer-level analytics from staging.events.

Source: staging.events
Reference table: analytics.customer_summary

Validation:
3,022,290 customers compared.
0 customers with differences.

Important:
- This script is read-only.
- Non-purchasing customers retain NULL total_revenue.
- Session counts exclude NULL session IDs.
- Revenue is the sum of purchase-event prices.
*/

WITH customer_summary_rebuilt AS (
    SELECT
        user_id,
        COUNT(DISTINCT user_session) AS total_sessions,

        COUNT(*) FILTER (
            WHERE event_type = 'view'
        ) AS total_views,

        COUNT(*) FILTER (
            WHERE event_type = 'cart'
        ) AS total_carts,

        COUNT(*) FILTER (
            WHERE event_type = 'purchase'
        ) AS total_purchases,

        COUNT(DISTINCT product_id) FILTER (
            WHERE event_type = 'view'
        ) AS unique_products_viewed,

        COUNT(DISTINCT product_id) FILTER (
            WHERE event_type = 'purchase'
        ) AS unique_products_purchased,

        SUM(price) FILTER (
            WHERE event_type = 'purchase'
        ) AS total_revenue,

        MIN(event_time) AS first_activity,
        MAX(event_time) AS last_activity,

        CASE
            WHEN COUNT(*) FILTER (
                WHERE event_type = 'purchase'
            ) > 0 THEN 1
            ELSE 0
        END AS is_purchaser

    FROM staging.events
    GROUP BY user_id
)
SELECT *
FROM customer_summary_rebuilt;