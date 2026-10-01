# E-Commerce Customer Journey & Conversion Funnel Analytics

## Overview
An end-to-end e-commerce analytics project using PostgreSQL, Python, pandas, and Power BI to analyze customer behavior, conversion funnels, product performance, and time-based trends.

## Data Pipeline
Raw Data -> Staging -> Analytics -> Reporting -> Power BI

## Dataset
This project uses the October 2019 REES46 eCommerce Behavior Data from a multi-category store.

The original CSV is approximately 5.67 GB and is intentionally excluded from GitHub. Place it locally at data/raw/2019-Oct.csv.

## Key Analysis
- Customer purchase segmentation
- Session-based conversion funnel
- Sequential view -> cart -> purchase analysis
- Product performance and recorded purchase revenue
- Daily and hourly activity analysis
- Time-to-first-purchase analysis
- Data quality validation

## Validated Metrics
- Total events: 42,448,764
- Unique customers: 3,022,290
- Sessions: 9,244,770
- Sessions with view followed by cart: 569,143
- Sessions completing the strict view -> cart -> purchase sequence: 278,727
- Strict view-to-purchase conversion rate: 3.02%
- Recorded purchase-event revenue: 229,957,502.27

Revenue is based on recorded purchase-event prices, not audited accounting revenue. The dataset covers one month and does not contain campaign attribution fields.

## Technology Stack
- PostgreSQL and SQL
- Python and pandas
- Microsoft Power BI
- Git and GitHub

## Project Structure
- scripts/: Python EDA and data quality scripts
- sql/staging/: Data preparation SQL
- sql/analytics/: Analytical transformations
- sql/reporting/: Reporting tables and views
- dashboard/: Power BI report documentation
- docs/: Project documentation

## Local Setup
1. Install Python and PostgreSQL.
2. Clone this repository.
3. Create and activate a Python virtual environment.
4. Install dependencies using pip install -r requirements.txt.
5. Obtain the original dataset and place it at data/raw/2019-Oct.csv.
6. Follow the SQL setup instructions provided in the repository.

## Author
Ponnam Vishal

GitHub: https://github.com/ponnamvishal
LinkedIn: https://www.linkedin.com/in/ponnam-vishal-935406387
