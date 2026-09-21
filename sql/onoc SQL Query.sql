================================================
                 DATA VALIDATION
================================================
1.1: Check total rows

select count(*)as total_rows
from onorc_transactions

1.2: Check the data

SELECT *
FROM onorc_transactions
LIMIT 10;

1.3: Check date range

SELECT
    MIN(year) AS start_year,
    MAX(year) AS end_year
FROM onorc_transactions;

1.4: Check total transactions

SELECT
    SUM(txn_count) AS total_transactions
FROM onorc_transactions;

1.5: Check missing values

SELECT
    COUNT(*) FILTER (WHERE homestatecode IS NULL) AS missing_home_state,
    COUNT(*) FILTER (WHERE salestatecode IS NULL) AS missing_sale_state,
    COUNT(*) FILTER (WHERE month IS NULL) AS missing_month,
    COUNT(*) FILTER (WHERE year IS NULL) AS missing_year,
    COUNT(*) FILTER (WHERE txn_count IS NULL) AS missing_transactions,
    COUNT(*) FILTER (WHERE salestatename IS NULL) AS missing_sale_state_name,
    COUNT(*) FILTER (WHERE homestatename IS NULL) AS missing_home_state_name
FROM onorc_transactions;

1.6:Check duplicate rows

SELECT
    COUNT(*) - COUNT(DISTINCT (
        homestatecode,
        salestatecode,
        month,
        year,
        txn_count,
        salestatename,
        homestatename
    )) AS duplicate_rows
FROM onorc_transactions;

1.7: Check transaction values

SELECT
    MIN(txn_count) AS minimum_transactions,
    MAX(txn_count) AS maximum_transactions,
    round(AVG(txn_count),2)AS average_transactions
FROM onorc_transactions;
================================================
              DEFINE BUSINESS KPIs
================================================
2.1: Total Transactions

SELECT
    SUM(txn_count) AS total_transactions
FROM onorc_transactions;

2.2: Total Home States

SELECT
    COUNT(DISTINCT homestatecode) AS total_home_states
FROM onorc_transactions;

2.3: Total Sale States

SELECT
    COUNT(DISTINCT salestatecode) AS total_sale_states
FROM onorc_transactions;

2.4: Active State-to-State Routes

SELECT
    COUNT(DISTINCT (homestatecode, salestatecode)) AS active_state_routes
FROM onorc_transactions;

2.5: Average Transactions per Record

SELECT
    ROUND(AVG(txn_count), 2) AS avg_transactions_per_record
FROM onorc_transactions;


================================================                               
		 STATE-WISE BUSINESS ANALYSIS
================================================
3.1: Total Transactions by Home State

SELECT
    homestatename AS home_state,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY homestatename
ORDER BY total_transactions DESC;

3.2: Total Transactions by Sale State

SELECT
    salestatename AS sale_state,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY salestatename
ORDER BY total_transactions DESC;

3.3: Top 10 Home States

SELECT
    homestatename AS home_state,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY homestatename
ORDER BY total_transactions DESC
LIMIT 10;

3.4: Top 10 Sale States

SELECT
    salestatename AS sale_state,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY salestatename
ORDER BY total_transactions DESC
LIMIT 10;


3.5: State Contribution %

SELECT
    homestatename AS home_state,
    SUM(txn_count) AS total_transactions,
    ROUND(
        SUM(txn_count) * 100.0 /
        SUM(SUM(txn_count)) OVER (),
        2
    ) AS transaction_share_pct
FROM onorc_transactions
GROUP BY homestatename
ORDER BY total_transactions DESC;
================================================
         INTERSTATE MOVEMENT ANALYSIS
================================================
4.1: Top 10 Home State → Sale State Routes

SELECT
    homestatename AS home_state,
    salestatename AS sale_state,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
WHERE homestatecode <> salestatecode
GROUP BY homestatename, salestatename
ORDER BY total_transactions DESC
LIMIT 10;

4.2: Interstate vs Intrastate Transactions

SELECT
    CASE
        WHEN homestatecode = salestatecode THEN 'Intrastate'
        ELSE 'Interstate'
    END AS transaction_type,
    SUM(txn_count) AS total_transactions,
    ROUND(
        SUM(txn_count) * 100.0 /
        SUM(SUM(txn_count)) OVER (),
        2
    ) AS share_pct
FROM onorc_transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

4.3: Top 10 Interstate Home States

SELECT
    homestatename AS home_state,
    SUM(txn_count) AS interstate_transactions
FROM onorc_transactions
WHERE homestatecode <> salestatecode
GROUP BY homestatename
ORDER BY interstate_transactions DESC
LIMIT 10;

4.4: Top 10 Interstate Sale States

SELECT
    salestatename AS sale_state,
    SUM(txn_count) AS interstate_transactions
FROM onorc_transactions
WHERE homestatecode <> salestatecode
GROUP BY salestatename
ORDER BY interstate_transactions DESC
LIMIT 10;

4.5: Total Active Interstate Routes

SELECT
    COUNT(DISTINCT (homestatecode, salestatecode)) AS active_interstate_routes
FROM onorc_transactions
WHERE homestatecode != salestatecode;
================================================
            TIME-BASED TREND ANALYSIS
================================================
5.1: Year-Wise Transaction Trend

SELECT
    year,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY year
ORDER BY year;

5.2: Month-Wise Transaction Trend

SELECT
    month,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY month
ORDER BY month;

5.3: Year + Month Transaction Trend

SELECT
    year,
    month,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY year, month
ORDER BY year, month;

5.4 Top 5 Months by Transaction Volume

SELECT
    year,
    month,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY year,month
ORDER BY total_transactions desc
limit 5

5.5: Year-over-Year Transaction Change

WITH yearly_transactions AS (
    SELECT
        year,
        SUM(txn_count) AS total_transactions
    FROM onorc_transactions
    GROUP BY year
)
SELECT
    year,
    total_transactions,
    LAG(total_transactions) OVER (ORDER BY year) AS previous_year_transactions,
    ROUND(
       (total_transactions - LAG(total_transactions) OVER (ORDER BY year))
        * 100.0
        / NULLIF(LAG(total_transactions) OVER (ORDER BY year), 0),
        2
    ) AS yoy_change_pct
FROM yearly_transactions
ORDER BY year;
==============================================
         BUSINESS INSIGHTS & CONCLUSION
==============================================
6.1: Overall Transaction Activity

SELECT
    SUM(txn_count) AS total_transactions,
    COUNT(DISTINCT homestatecode) AS home_states,
    COUNT(DISTINCT salestatecode) AS sale_states,
    COUNT(DISTINCT (homestatecode, salestatecode)) AS active_routes
FROM onorc_transactions;

6.2: Highest Transaction Home State

SELECT
    homestatename AS home_state,
SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY homestatename
ORDER BY total_transactions DESC
LIMIT 1;

6.3: Highest Transaction Sale State

SELECT
    salestatename AS sale_state,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY salestatename
ORDER BY total_transactions DESC
LIMIT 1;

6.4: Highest-Volume Interstate Route

SELECT
    homestatename AS home_state,
    salestatename AS sale_state,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
WHERE homestatecode <> salestatecode
GROUP BY homestatename, salestatename
ORDER BY total_transactions DESC
LIMIT 1;

6.5: Peak Transaction Period

SELECT
    year,
    month,
    SUM(txn_count) AS total_transactions
FROM onorc_transactions
GROUP BY year, month
ORDER BY total_transactions DESC
LIMIT 1;

-- =====================================================
-- 6.6: BUSINESS INSIGHTS
-- =====================================================

-- Insight 1: Overall Transaction Activity
-- The ONORC dataset records 28,788,091 transactions
-- across 32 home states and 36 sale states, with
-- 633 active state-to-state routes.

-- Insight 2: Highest Home-State Transaction Activity
-- Bihar recorded the highest home-state transaction
-- volume, with 12,918,798 transactions.

-- Insight 3: Highest Sale-State Transaction Activity
-- Delhi recorded the highest sale-state transaction
-- volume, with 18,936,878 transactions.

-- Insight 4: Major Interstate Route
-- Bihar to Delhi was the highest-volume interstate
-- route, recording 9,360,129 transactions.

-- Insight 5: Peak Transaction Period
-- March 2026 recorded the highest transaction volume
-- for a single year-month period in the dataset,
-- with 945,825 transactions.

-- Insight 6: Year-over-Year Transaction Trend
-- Transaction volume increased substantially between
-- 2020 and 2025, with the largest percentage increases
-- occurring in 2021 and 2022. Growth continued in 2023,
-- 2024 and 2025 at different rates.
--
-- The 2026 YoY value shows a decrease of 63.11%;
-- however, 2026 should be interpreted as a partial-year
-- period because the available data extends only through
-- March 2026. Therefore, this value should not be treated
-- as a full-year decline.


-- =====================================================
-- 6.7: FINAL CONCLUSION
-- =====================================================

-- This project analyzed ONORC transaction data using
-- PostgreSQL to understand transaction volume,
-- state-level activity, interstate movement,
-- geographic connectivity, and time-based trends.
--
-- The analysis covered 28,788,091 transactions across
-- 32 home states, 36 sale states, and 633 active
-- state-to-state routes.
--
-- Bihar recorded the highest home-state transaction
-- volume, while Delhi recorded the highest sale-state
-- transaction volume. The Bihar-to-Delhi route was the
-- highest-volume interstate route in the dataset.
--
-- The time-based analysis showed substantial changes
-- in transaction activity across the analyzed years,
-- while March 2026 recorded the highest individual
-- year-month transaction volume. The 2026 figures should
-- be interpreted as partial-year results based on the
-- available data.
--
-- Overall, the analysis provides a structured,
-- data-driven view of ONORC transaction activity and
-- establishes a strong foundation for further analysis
-- and visualization using Python and Power BI.





                                      















					  

