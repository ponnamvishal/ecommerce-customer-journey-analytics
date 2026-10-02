
WITH rebuilt AS (
    SELECT
        user_id,
        COUNT(DISTINCT user_session) AS total_sessions,
        COUNT(*) FILTER (WHERE event_type = 'view') AS total_views,
        COUNT(*) FILTER (WHERE event_type = 'cart') AS total_carts,
        COUNT(*) FILTER (WHERE event_type = 'purchase') AS total_purchases,
        COUNT(DISTINCT product_id)
            FILTER (WHERE event_type = 'view') AS unique_products_viewed,
        COUNT(DISTINCT product_id)
            FILTER (WHERE event_type = 'purchase') AS unique_products_purchased,
        SUM(price) FILTER (
            WHERE event_type = 'purchase'
        ) AS total_revenue,
        MIN(event_time) AS first_activity,
        MAX(event_time) AS last_activity,
        CASE
            WHEN COUNT(*) FILTER (WHERE event_type = 'purchase') > 0
            THEN 1 ELSE 0
        END AS is_purchaser
    FROM staging.events
    GROUP BY user_id
),
differences AS (
    SELECT r.user_id
    FROM rebuilt r
    FULL OUTER JOIN analytics.customer_summary c
        ON r.user_id = c.user_id
    WHERE r.user_id IS NULL
       OR c.user_id IS NULL
       OR r.total_sessions IS DISTINCT FROM c.total_sessions
       OR r.total_views IS DISTINCT FROM c.total_views
       OR r.total_carts IS DISTINCT FROM c.total_carts
       OR r.total_purchases IS DISTINCT FROM c.total_purchases
       OR r.unique_products_viewed
            IS DISTINCT FROM c.unique_products_viewed
       OR r.unique_products_purchased
            IS DISTINCT FROM c.unique_products_purchased
       OR r.total_revenue IS DISTINCT FROM c.total_revenue
       OR r.first_activity IS DISTINCT FROM c.first_activity
       OR r.last_activity IS DISTINCT FROM c.last_activity
       OR r.is_purchaser IS DISTINCT FROM c.is_purchaser
)
SELECT
    (SELECT COUNT(*) FROM analytics.customer_summary)
        AS existing_customer_rows,
    (SELECT COUNT(*) FROM differences)
        AS customers_with_differences;