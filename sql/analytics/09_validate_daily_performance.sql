
WITH rebuilt AS (
    SELECT
        (event_time AT TIME ZONE 'UTC')::date AS event_date,
        COUNT(*) AS total_events,
        COUNT(*) FILTER (
            WHERE event_type = 'view'
        ) AS views,
        COUNT(*) FILTER (
            WHERE event_type = 'cart'
        ) AS carts,
        COUNT(*) FILTER (
            WHERE event_type = 'purchase'
        ) AS purchases,
        COUNT(DISTINCT user_id) AS active_users,
        COUNT(DISTINCT user_id) FILTER (
            WHERE event_type = 'purchase'
        ) AS purchasing_users,
        SUM(price) FILTER (
            WHERE event_type = 'purchase'
        ) AS revenue
    FROM staging.events
    GROUP BY (event_time AT TIME ZONE 'UTC')::date
),
comparison AS (

    SELECT
        COALESCE(r.event_date, e.event_date) AS event_date,

        r.total_events AS rebuilt_total_events,
        e.total_events AS existing_total_events,

        r.views AS rebuilt_views,
        e.views AS existing_views,

        r.carts AS rebuilt_carts,
        e.carts AS existing_carts,

        r.purchases AS rebuilt_purchases,
        e.purchases AS existing_purchases,

        r.active_users AS rebuilt_active_users,
        e.active_users AS existing_active_users,

        r.purchasing_users AS rebuilt_purchasing_users,
        e.purchasing_users AS existing_purchasing_users,

        r.revenue AS rebuilt_revenue,
        e.revenue AS existing_revenue

    FROM rebuilt r
    FULL OUTER JOIN analytics.daily_performance e
        ON r.event_date = e.event_date
)

SELECT
    COUNT(*) AS compared_days,

    COUNT(*) FILTER (
        WHERE rebuilt_total_events IS DISTINCT FROM existing_total_events
    ) AS total_events_mismatches,

    COUNT(*) FILTER (
        WHERE rebuilt_views IS DISTINCT FROM existing_views
    ) AS views_mismatches,

    COUNT(*) FILTER (
        WHERE rebuilt_carts IS DISTINCT FROM existing_carts
    ) AS carts_mismatches,

    COUNT(*) FILTER (
        WHERE rebuilt_purchases IS DISTINCT FROM existing_purchases
    ) AS purchases_mismatches,

    COUNT(*) FILTER (
        WHERE rebuilt_active_users IS DISTINCT FROM existing_active_users
    ) AS active_users_mismatches,

    COUNT(*) FILTER (
        WHERE rebuilt_purchasing_users IS DISTINCT FROM existing_purchasing_users
    ) AS purchasing_users_mismatches,

    COUNT(*) FILTER (
        WHERE rebuilt_revenue IS DISTINCT FROM existing_revenue
    ) AS revenue_mismatches

FROM comparison;