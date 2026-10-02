/*
File: 02_customer_segments.sql
Purpose: Reconstruct customer segment classification.

Source: staging.events
Reference: analytics.customer_segments

Read-only reconstruction.
Does not modify existing database tables.
*/

WITH customer_metrics AS (
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
         COALESCE(
            SUM(price) FILTER (
            WHERE event_type = 'purchase'
            ),
            0
        ) AS total_revenue,
        MIN(event_time) AS first_activity,
        MAX(event_time) AS last_activity
    FROM staging.events
    GROUP BY user_id
)
SELECT
    *,
    CASE
        WHEN total_purchases = 0
            THEN 'Non-Purchaser'
        WHEN total_purchases = 1
            THEN 'Single-Purchase Customer'
        ELSE 'Repeat Purchaser'
    END AS customer_segment
FROM customer_metrics;