
WITH rebuilt AS (
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
),
rates AS (
    SELECT
        *,
        ROUND(
            100.0 * cart_count / NULLIF(view_count, 0), 2
        ) AS view_to_cart_rate,
        ROUND(
            100.0 * purchase_count / NULLIF(cart_count, 0), 2
        ) AS cart_to_purchase_rate,
        ROUND(
            100.0 * purchase_count / NULLIF(view_count, 0), 2
        ) AS view_to_purchase_rate
    FROM rebuilt
),
differences AS (
    SELECT
        r.product_id,
        r.category_code IS DISTINCT FROM p.category_code
            AS category_diff,
        r.brand IS DISTINCT FROM p.brand
            AS brand_diff,
        r.view_count IS DISTINCT FROM p.view_count
            AS views_diff,
        r.cart_count IS DISTINCT FROM p.cart_count
            AS carts_diff,
        r.purchase_count IS DISTINCT FROM p.purchase_count
            AS purchases_diff,
        r.purchase_revenue IS DISTINCT FROM p.purchase_revenue
            AS revenue_diff,
        r.view_to_cart_rate IS DISTINCT FROM p.view_to_cart_rate
            AS view_cart_rate_diff,
        r.cart_to_purchase_rate
            IS DISTINCT FROM p.cart_to_purchase_rate
            AS cart_purchase_rate_diff,
        r.view_to_purchase_rate
            IS DISTINCT FROM p.view_to_purchase_rate
            AS view_purchase_rate_diff
    FROM rates r
    FULL OUTER JOIN analytics.product_performance p
        ON r.product_id = p.product_id
)
SELECT
    COUNT(*) AS compared_products,
    COUNT(*) FILTER (WHERE category_diff) AS category_mismatches,
    COUNT(*) FILTER (WHERE brand_diff) AS brand_mismatches,
    COUNT(*) FILTER (WHERE views_diff) AS view_count_mismatches,
    COUNT(*) FILTER (WHERE carts_diff) AS cart_count_mismatches,
    COUNT(*) FILTER (WHERE purchases_diff) AS purchase_count_mismatches,
    COUNT(*) FILTER (WHERE revenue_diff) AS revenue_mismatches,
    COUNT(*) FILTER (WHERE view_cart_rate_diff) AS view_cart_rate_mismatches,
    COUNT(*) FILTER (WHERE cart_purchase_rate_diff) AS cart_purchase_rate_mismatches,
    COUNT(*) FILTER (WHERE view_purchase_rate_diff) AS view_purchase_rate_mismatches
FROM differences;