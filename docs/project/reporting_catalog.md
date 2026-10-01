# Reporting Layer Catalog

The reporting layer provides prepared datasets for business reporting and
Power BI visualization. It sits after the analytics layer in the project pipeline.

## Tables

| Table | Purpose |
|---|---|
| reporting.rpt_conversion_analysis | Customer counts grouped by time-to-purchase conversion bucket |
| reporting.rpt_customer_analysis | Customer segments, activity metrics, revenue buckets, and session frequency |
| reporting.rpt_daily_analysis | Daily activity, customer, revenue, and event-rate metrics |
| reporting.rpt_event_transitions | Event transition counts and percentages |
| reporting.rpt_funnel_overview | Session funnel metrics, sequential conversion rates, and purchases outside the strict funnel |
| reporting.rpt_hourly_analysis | Hourly activity, customer, revenue, and event-rate metrics |
| reporting.rpt_product_analysis | Product performance, conversion rates, and view-volume buckets |

## Funnel Definitions

The strict sequential funnel requires a session to progress through:

1. View
2. Cart after view
3. Purchase after cart

Validated project metrics:

- Total sessions: 9,244,770
- Sessions with a cart after a view: 569,143
- Sessions completing the strict sequence: 278,727
- Sequential view-to-cart rate: 6.16%
- Sequential cart-to-purchase rate: 48.97%
- Sequential view-to-purchase rate: 3.02%
- Purchase sessions outside the strict funnel: 350,833

Purchases outside the strict funnel should not automatically be interpreted as
failed tracking; they simply do not satisfy the defined sequence.

## Data Interpretation

- Revenue represents the sum of recorded purchase-event prices, not audited accounting revenue.
- The source dataset covers October 2019.
- The dataset has no campaign attribution fields.
- Event-level rates and strict sequential session conversion rates use different denominators and must not be treated as interchangeable.

## Source of Documentation

Table names and structures are recorded in `docs/database/database_schema.sql`.
Descriptions and metric definitions summarize the project documentation and
validated results; this file does not contain the original SQL transformations.
