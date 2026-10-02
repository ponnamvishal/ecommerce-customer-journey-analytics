
WITH rebuilt AS (
    SELECT
        user_id,
        user_session,
        MIN(event_time) AS session_start,
        MAX(event_time) AS session_end,
        EXTRACT(
            EPOCH FROM MAX(event_time) - MIN(event_time)
        )::numeric AS session_duration_seconds,
        COUNT(*) AS total_events,
        COUNT(*) FILTER (
            WHERE event_type = 'view'
        ) AS view_events,
        COUNT(*) FILTER (
            WHERE event_type = 'cart'
        ) AS cart_events,
        COUNT(*) FILTER (
            WHERE event_type = 'purchase'
        ) AS purchase_events,
        CASE
            WHEN COUNT(*) FILTER (
                WHERE event_type = 'cart'
            ) > 0 THEN 1
            ELSE 0
        END AS reached_cart,
        CASE
            WHEN COUNT(*) FILTER (
                WHERE event_type = 'purchase'
            ) > 0 THEN 1
            ELSE 0
        END AS reached_purchase
    FROM staging.events
    WHERE user_session IS NOT NULL
    GROUP BY user_id, user_session
),
comparison AS (
    SELECT
        e.user_id AS existing_user_id,
        r.user_id AS rebuilt_user_id,
        e.user_session AS existing_session,
        r.user_session AS rebuilt_session,

        e.session_start AS existing_start,
        r.session_start AS rebuilt_start,
        e.session_end AS existing_end,
        r.session_end AS rebuilt_end,

        e.session_duration_seconds AS existing_duration,
        r.session_duration_seconds AS rebuilt_duration,

        e.total_events AS existing_events,
        r.total_events AS rebuilt_events,
        e.view_events AS existing_views,
        r.view_events AS rebuilt_views,
        e.cart_events AS existing_carts,
        r.cart_events AS rebuilt_carts,
        e.purchase_events AS existing_purchases,
        r.purchase_events AS rebuilt_purchases,

        e.reached_cart AS existing_reached_cart,
        r.reached_cart AS rebuilt_reached_cart,
        e.reached_purchase AS existing_reached_purchase,
        r.reached_purchase AS rebuilt_reached_purchase

    FROM analytics.session_summary e
    FULL OUTER JOIN rebuilt r
        ON e.user_id = r.user_id
       AND e.user_session = r.user_session
)
SELECT
    COUNT(*) AS compared_sessions,

    COUNT(*) FILTER (
        WHERE existing_user_id IS NULL
           OR rebuilt_user_id IS NULL
    ) AS missing_session_records,

    COUNT(*) FILTER (
        WHERE existing_start IS DISTINCT FROM rebuilt_start
    ) AS start_mismatches,

    COUNT(*) FILTER (
        WHERE existing_end IS DISTINCT FROM rebuilt_end
    ) AS end_mismatches,

    COUNT(*) FILTER (
        WHERE existing_duration IS DISTINCT FROM rebuilt_duration
    ) AS duration_mismatches,

    COUNT(*) FILTER (
        WHERE existing_events IS DISTINCT FROM rebuilt_events
    ) AS total_event_mismatches,

    COUNT(*) FILTER (
        WHERE existing_views IS DISTINCT FROM rebuilt_views
    ) AS view_mismatches,

    COUNT(*) FILTER (
        WHERE existing_carts IS DISTINCT FROM rebuilt_carts
    ) AS cart_mismatches,

    COUNT(*) FILTER (
        WHERE existing_purchases IS DISTINCT FROM rebuilt_purchases
    ) AS purchase_mismatches,

    COUNT(*) FILTER (
        WHERE existing_reached_cart
              IS DISTINCT FROM rebuilt_reached_cart
    ) AS reached_cart_mismatches,

    COUNT(*) FILTER (
        WHERE existing_reached_purchase
              IS DISTINCT FROM rebuilt_reached_purchase
    ) AS reached_purchase_mismatches

FROM comparison;

