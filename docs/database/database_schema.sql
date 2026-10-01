--
-- PostgreSQL database dump
--

\restrict PQG0AkbZbDzkJqtvTKoIf4BihMc8l1AAqvZLzKKhbPZypf8SqYjrpHzTxy9x43D

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: analytics; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA analytics;


--
-- Name: raw; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA raw;


--
-- Name: reporting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA reporting;


--
-- Name: staging; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA staging;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cohort_summary; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.cohort_summary (
    cohort_month date,
    customers bigint,
    purchasing_customers bigint,
    non_purchasing_customers bigint,
    total_sessions numeric,
    total_views numeric,
    total_carts numeric,
    total_purchases numeric,
    total_revenue numeric,
    purchase_rate numeric
);


--
-- Name: customer_cohort; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.customer_cohort (
    user_id bigint,
    first_activity timestamp with time zone,
    cohort_month date,
    last_activity timestamp with time zone,
    total_sessions bigint,
    total_views bigint,
    total_carts bigint,
    total_purchases bigint,
    total_revenue numeric,
    is_purchaser integer
);


--
-- Name: customer_conversion; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.customer_conversion (
    user_id bigint,
    first_activity timestamp with time zone,
    first_purchase timestamp with time zone,
    hours_to_first_purchase numeric,
    conversion_bucket text
);


--
-- Name: customer_segments; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.customer_segments (
    user_id bigint,
    total_sessions bigint,
    total_views bigint,
    total_carts bigint,
    total_purchases bigint,
    unique_products_viewed bigint,
    unique_products_purchased bigint,
    total_revenue numeric,
    first_activity timestamp with time zone,
    last_activity timestamp with time zone,
    customer_segment text
);


--
-- Name: customer_summary; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.customer_summary (
    user_id bigint,
    total_sessions bigint,
    total_views bigint,
    total_carts bigint,
    total_purchases bigint,
    unique_products_viewed bigint,
    unique_products_purchased bigint,
    total_revenue numeric,
    first_activity timestamp with time zone,
    last_activity timestamp with time zone,
    is_purchaser integer
);


--
-- Name: daily_performance; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.daily_performance (
    event_date date,
    total_events bigint,
    views bigint,
    carts bigint,
    purchases bigint,
    active_users bigint,
    purchasing_users bigint,
    revenue numeric
);


--
-- Name: event_sequence; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.event_sequence (
    user_id bigint,
    user_session text,
    event_time timestamp with time zone,
    event_type character varying(20),
    product_id bigint,
    price numeric(10,2),
    event_sequence bigint,
    previous_event_type character varying,
    next_event_type character varying
);


--
-- Name: event_transitions; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.event_transitions (
    previous_event_type character varying,
    current_event_type character varying(20),
    transition_count bigint,
    transition_percentage numeric
);


--
-- Name: funnel_summary; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.funnel_summary (
    total_sessions bigint,
    sessions_with_view bigint,
    sessions_with_cart bigint,
    sessions_cart_to_purchase bigint,
    sessions_with_purchase bigint,
    view_to_cart_rate numeric,
    cart_to_purchase_rate numeric,
    view_to_purchase_rate numeric
);


--
-- Name: hourly_performance; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.hourly_performance (
    event_hour integer,
    total_events bigint,
    views bigint,
    carts bigint,
    purchases bigint,
    active_users bigint,
    purchasing_users bigint,
    revenue numeric
);


--
-- Name: product_performance; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.product_performance (
    product_id bigint,
    category_code text,
    brand text,
    view_count bigint,
    cart_count bigint,
    purchase_count bigint,
    purchase_revenue numeric,
    view_to_cart_rate numeric,
    cart_to_purchase_rate numeric,
    view_to_purchase_rate numeric
);


--
-- Name: sequential_funnel; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.sequential_funnel (
    user_id bigint,
    user_session text,
    first_view_time timestamp with time zone,
    first_cart_time timestamp with time zone,
    first_purchase_time timestamp with time zone,
    reached_view integer,
    reached_cart_after_view integer,
    completed_purchase_after_cart integer
);


--
-- Name: session_summary; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.session_summary (
    user_id bigint,
    user_session text,
    session_start timestamp with time zone,
    session_end timestamp with time zone,
    session_duration_seconds numeric,
    total_events bigint,
    view_events bigint,
    cart_events bigint,
    purchase_events bigint,
    reached_cart integer,
    reached_purchase integer
);


--
-- Name: events_import; Type: TABLE; Schema: raw; Owner: -
--

CREATE TABLE raw.events_import (
    event_time text,
    event_type character varying(20),
    product_id bigint,
    category_id bigint,
    category_code character varying(255),
    brand character varying(255),
    price numeric(10,2),
    user_id bigint,
    user_session character varying(100)
);


--
-- Name: rpt_conversion_analysis; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.rpt_conversion_analysis (
    conversion_bucket text,
    customers bigint
);


--
-- Name: rpt_customer_analysis; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.rpt_customer_analysis (
    user_id bigint,
    customer_segment text,
    total_sessions bigint,
    total_views bigint,
    total_carts bigint,
    total_purchases bigint,
    unique_products_viewed bigint,
    unique_products_purchased bigint,
    total_revenue numeric,
    first_activity timestamp with time zone,
    last_activity timestamp with time zone,
    session_frequency_bucket text,
    revenue_bucket text,
    revenue_bucket_sort integer
);


--
-- Name: rpt_daily_analysis; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.rpt_daily_analysis (
    event_date date,
    total_events bigint,
    views bigint,
    carts bigint,
    purchases bigint,
    active_users bigint,
    purchasing_users bigint,
    revenue numeric,
    view_to_cart_event_rate numeric,
    cart_to_purchase_event_rate numeric,
    purchasing_user_rate numeric
);


--
-- Name: rpt_event_transitions; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.rpt_event_transitions (
    previous_event_type character varying,
    current_event_type character varying(20),
    transition_count bigint,
    transition_percentage numeric
);


--
-- Name: rpt_funnel_overview; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.rpt_funnel_overview (
    total_sessions bigint,
    sessions_with_view bigint,
    sessions_with_cart bigint,
    sessions_cart_to_purchase bigint,
    sessions_with_purchase bigint,
    view_to_cart_rate numeric,
    cart_to_purchase_rate numeric,
    view_to_purchase_rate numeric,
    cart_after_view_sessions bigint,
    completed_purchase_sessions bigint,
    sequential_view_to_cart_rate numeric,
    sequential_cart_to_purchase_rate numeric,
    sequential_view_to_purchase_rate numeric,
    purchase_sessions_outside_strict_funnel bigint
);


--
-- Name: rpt_hourly_analysis; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.rpt_hourly_analysis (
    event_hour integer,
    total_events bigint,
    views bigint,
    carts bigint,
    purchases bigint,
    active_users bigint,
    purchasing_users bigint,
    revenue numeric,
    view_to_cart_event_rate numeric,
    cart_to_purchase_event_rate numeric,
    purchasing_user_rate numeric
);


--
-- Name: rpt_product_analysis; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.rpt_product_analysis (
    product_id bigint,
    category_code text,
    brand text,
    view_count bigint,
    cart_count bigint,
    purchase_count bigint,
    purchase_revenue numeric,
    view_to_cart_rate numeric,
    cart_to_purchase_rate numeric,
    view_to_purchase_rate numeric,
    view_volume_bucket text
);


--
-- Name: events; Type: TABLE; Schema: staging; Owner: -
--

CREATE TABLE staging.events (
    event_time timestamp with time zone,
    event_type character varying(20),
    product_id bigint,
    category_id bigint,
    category_code text,
    brand text,
    price numeric(10,2),
    user_id bigint,
    user_session text
);


--
-- PostgreSQL database dump complete
--

\unrestrict PQG0AkbZbDzkJqtvTKoIf4BihMc8l1AAqvZLzKKhbPZypf8SqYjrpHzTxy9x43D

