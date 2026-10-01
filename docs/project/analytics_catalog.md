# Analytics Layer Catalog

The analytics layer contains prepared datasets for customer behavior,
conversion funnel analysis, product performance, and time-based reporting.

## Tables

| Table | Purpose |
|---|---|
| analytics.cohort_summary | Aggregated customer and purchase metrics by cohort month |
| analytics.customer_cohort | Customer activity and purchasing status by cohort |
| analytics.customer_conversion | Time from first activity to first purchase and conversion bucket |
| analytics.customer_segments | Customer-level metrics and purchase segment |
| analytics.customer_summary | Customer-level activity, product, and revenue metrics |
| analytics.daily_performance | Daily event, user, purchase, and revenue metrics |
| analytics.event_sequence | Events ordered by user and session, with previous and next events |
| analytics.event_transitions | Counts and percentages of event-to-event transitions |
| analytics.funnel_summary | Session-based funnel metrics |
| analytics.hourly_performance | Hourly event, user, purchase, and revenue metrics |
| analytics.product_performance | Product-level views, carts, purchases, and recorded purchase revenue |
| analytics.sequential_funnel | Session-level view-to-cart-to-purchase sequence indicators |
| analytics.session_summary | Session duration, event counts, and funnel indicators |

## Interpretation Notes

- Funnel results depend on the definition of a qualifying session and event sequence.
- Sequential funnel metrics must be distinguished from event-count conversion rates.
- Recorded purchase-event prices are a revenue proxy, not audited accounting revenue.
- The dataset covers October 2019 only; it does not support robust multi-month retention analysis.
- The source dataset does not contain campaign attribution fields.

## Source of Documentation

Table names and structures are documented in `docs/database/database_schema.sql`.
Descriptions summarize the intended analytical purpose of each table and should not
be interpreted as a replacement for the original transformation SQL.
