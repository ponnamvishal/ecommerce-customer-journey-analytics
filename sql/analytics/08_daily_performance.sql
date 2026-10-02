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
)

SELECT *
FROM rebuilt
ORDER BY event_date;
```
