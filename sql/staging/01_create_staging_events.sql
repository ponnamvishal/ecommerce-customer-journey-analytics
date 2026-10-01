-- File: 01_create_staging_events.sql
-- Purpose: Transform raw e-commerce events into typed staging data.
-- Source: raw.events_import
-- Target: staging.events
--
-- WARNING:
-- This script rebuilds staging.events. Run only when intentionally
-- refreshing the staging layer from the raw import.

BEGIN;

TRUNCATE TABLE staging.events;

INSERT INTO staging.events (
    event_time,
    event_type,
    product_id,
    category_id,
    category_code,
    brand,
    price,
    user_id,
    user_session
)
SELECT
    NULLIF(TRIM(event_time), '')::timestamptz AS event_time,
    event_type,
    product_id,
    category_id,
    NULLIF(TRIM(category_code), '')::text AS category_code,
    NULLIF(TRIM(brand), '')::text AS brand,
    price,
    user_id,
    NULLIF(TRIM(user_session), '')::text AS user_session
FROM raw.events_import;

COMMIT;

-- Validation: compare source and staging row counts.
SELECT 'raw.events_import' AS table_name, COUNT(*) AS row_count
FROM raw.events_import
UNION ALL
SELECT 'staging.events', COUNT(*)
FROM staging.events;
