# Digital Commerce Behavior & Conversion Intelligence

## Overview

A customer-journey analytics project built with PostgreSQL, SQL, Python, pandas, and Power BI. It examines event-level shopping behavior, session activity, sequential conversion funnels, product interactions, and time-to-purchase patterns.

This project is distinct from the **Retail Revenue Intelligence Platform**, which focuses on warehouse modeling and broader sales, revenue, and customer reporting.

## Data Pipeline

Raw Data -> Staging -> Analytics -> Reporting -> Power BI

## Dataset

This project uses the October 2019 REES46 eCommerce Behavior Data from a multi-category online store.

The original CSV is approximately 5.67 GB and is intentionally excluded from GitHub. Place it locally at `data/raw/2019-Oct.csv`.

## Key Analysis

- Customer purchase segmentation
- Session-based shopping behavior
- Strict sequential view -> cart -> purchase funnel
- Product interaction and purchase performance
- Daily and hourly activity patterns
- Time-to-first-purchase analysis
- Data quality and reporting-layer validation

## Validated Metrics

- Total events: 42,448,764
- Unique customers: 3,022,290
- Sessions: 9,244,770
- Sessions with a view followed by a cart: 569,143
- Sessions completing the strict view -> cart -> purchase sequence: 278,727
- Strict view-to-purchase conversion rate: 3.02%
- Recorded purchase-event revenue: 229,957,502.27

These metrics describe the October 2019 dataset. Revenue is the sum of recorded purchase-event prices, not audited accounting revenue; the dataset does not provide verified currency units, order IDs, or quantity fields. It also contains no campaign attribution fields, so this project does not claim campaign-level attribution.

The ordinary session transition metrics and strict sequential funnel metrics use different definitions. Purchases outside the strict sequence are an analysis point, not automatically data errors.

## Technology Stack

- PostgreSQL and SQL
- Python and pandas
- Microsoft Power BI
- Git and GitHub

## Repository Structure

- `scripts/`: Python exploratory analysis and data-quality scripts
- `sql/staging/`: Staging-table preparation SQL
- `sql/analytics/`: Analytical transformations and validation queries
- `sql/reporting/`: Reporting-layer validation and audit queries
- `docs/`: Schema and project documentation

The repository contains analysis and validation SQL, but it is not yet a one-command, end-to-end rebuild of every database object from a clean PostgreSQL installation. Review each SQL file before running it. In particular, the staging setup script truncates `staging.events`, so do not run it against a populated database unless you intend to replace that data.

## Local Setup

1. Install PostgreSQL and Python.
2. Clone this repository.
3. Create and activate a Python virtual environment.
4. Install dependencies with `pip install -r requirements.txt`.
5. Obtain the original REES46 October 2019 dataset and place it at `data/raw/2019-Oct.csv`.
6. Create/configure the database and schemas using the SQL files and schema documentation under `docs/` and `sql/`.
7. Run SQL scripts selectively in dependency order, checking each script's comments and validation queries first. These scripts are not a complete automated database bootstrap.

## Author

**Ponnam Vishal**

- GitHub: https://github.com/ponnamvishal
- LinkedIn: https://www.linkedin.com/in/ponnam-vishal-935406387
