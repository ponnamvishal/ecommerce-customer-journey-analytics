
/*
File: 06_product_performance.sql
Purpose: Reconstruct product-level performance metrics.

Source: staging.events
Reference: analytics.product_performance

Read-only reconstruction.
Rates are expressed as percentages.
*/

WITH product_metrics AS (
    SELECT
        product_id,
        MODE() WITHIN GROUP (
            ORDER BY category_code
        ) FILTER (
            WHERE category_code IS NOT NULL
        ) AS category_code,
                MAX(brand) FILTER (
            WHERE brand IS NOT NULL
        ) AS brand,
        COUNT(*) FILTER (
            WHERE event_type = 'view'
        ) AS view_count,
        COUNT(*) FILTER (
            WHERE event_type = 'cart'
        ) AS cart_count,
        COUNT(*) FILTER (
            WHERE event_type = 'purchase'
        ) AS purchase_count,
        SUM(price) FILTER (
    WHERE event_type = 'purchase'
) AS purchase_revenue
    FROM staging.events
    WHERE product_id IS NOT NULL
    GROUP BY product_id
)
SELECT
    product_id,
    category_code,
    brand,
    view_count,
    cart_count,
    purchase_count,
    purchase_revenue,
    ROUND(
        100.0 * cart_count / NULLIF(view_count, 0),
        2
    ) AS view_to_cart_rate,
    ROUND(
        100.0 * purchase_count / NULLIF(cart_count, 0),
        2
    ) AS cart_to_purchase_rate,
    ROUND(
        100.0 * purchase_count / NULLIF(view_count, 0),
        2
    ) AS view_to_purchase_rate
FROM product_metrics;