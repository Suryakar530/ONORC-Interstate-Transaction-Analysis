# ONORC-Interstate-Transaction-Analysis
End-to-end ONORC interstate transaction analysis using PostgreSQL, SQL, Python, and Power BI.
# ONORC INTERSTATE TRANSACTION & DISTRIBUTION ANALYSIS

## End-to-End Data Analytics Project using PostgreSQL, SQL, Python & Power BI

![ONORC Dashboard](DASHBOARD/ONORC%20DASHBOARD.png)

---

## 📌 PROJECT OVERVIEW

This project analyzes interstate transaction activity under the **One Nation One Ration Card (ONORC)** initiative.

The objective is to analyze transaction volumes across home states and sale states, identify high-volume interstate routes, understand transaction trends over time, and present the findings through an interactive Power BI dashboard.

The project follows an end-to-end data analytics workflow:

**Raw Data → Data Validation → PostgreSQL → SQL Analysis → Python Analysis → Matplotlib Visualization → Power BI Dashboard → Business Insights**

---

## 🎯 BUSINESS OBJECTIVES

- Analyze overall ONORC transaction activity
- Identify major home states by transaction volume
- Identify major sale states
- Analyze interstate transaction routes
- Identify the highest-volume interstate routes
- Analyze monthly and yearly transaction trends
- Calculate key business KPIs
- Build an interactive Power BI dashboard
- Generate actionable business insights

---

## 📊 DATASET

**Dataset:** ONORC Transaction Data

### Dataset Characteristics

| Metric | Value |
|---|---:|
| Total Records | 18,756 |
| Total Transactions | 28,788,091 |
| Home States | 32 |
| Sale States | 36 |
| Active State Routes | 633 |
| Year Range | 2020–2026 |
| Transaction Count | 1 – 354,078 |

### Main Columns

- `homestatecode`
- `salestatecode`
- `month`
- `year`
- `txn_count`
- `salestatename`
- `homestatename`

> **Note:** The dataset contains aggregated transaction records rather than individual customer-level transactions.

---

# 🛠️ TOOLS & TECHNOLOGIES

### PostgreSQL
Used for:

- Data loading
- Data validation
- KPI calculation
- State-wise analysis
- Interstate route analysis
- Time-based analysis
- Year-over-Year analysis

### SQL
Used for:

- Aggregations
- GROUP BY analysis
- Window functions
- LAG()
- CASE statements
- DISTINCT counts
- Top-N analysis

### Python
Used for:

- Data loading
- Data inspection
- Data preparation
- KPI analysis
- Interstate transaction analysis
- Time-series analysis

### Python Libraries

- Pandas
- NumPy
- Matplotlib

### Power BI
Used for:

- KPI cards
- Interactive filters
- State-wise analysis
- Interstate route analysis
- Transaction distribution
- Trend analysis
- Interactive dashboard

---

# 🔍 DATA ANALYSIS WORKFLOW

## 1. DATA VALIDATION

The dataset was loaded into PostgreSQL and validated for:

- Total row count
- Data types
- Missing values
- Duplicate records
- Transaction value range
- Year range
- State coverage

### Validation Results

- **18,756 records**
- **No missing values**
- **No duplicate records**
- Transaction count range: **1 to 354,078**
- Year range: **2020–2026**

---

# 2. BUSINESS KPIs

The following KPIs were calculated:

| KPI | Result |
|---|---:|
| Total Transactions | 28.79M |
| Home States | 32 |
| Sale States | 36 |
| Active State Routes | 633 |
| Interstate Transactions | 28.79M |
| Average Transactions per Record | 1.53K |

---

# 3. STATE-WISE ANALYSIS

The analysis examined transaction volumes by:

- Home State
- Sale State
- State transaction contribution
- Top 10 Home States
- Top 10 Sale States

### Key Findings

**Highest Home State by Transactions:**  
Bihar — **12,918,798**

**Highest Sale State by Transactions:**  
Delhi — **18,936,878**

---

# 4. INTERSTATE MOVEMENT ANALYSIS

The project analyzed movement between home states and sale states.

### Key Analysis

- Top interstate routes
- Top interstate home states
- Top interstate sale states
- Active interstate routes
- Interstate transaction volume

### Highest-Volume Interstate Route

**Bihar → Delhi**

Total Transactions:

**9,360,129**

---

# 5. TIME-BASED ANALYSIS

Transaction trends were analyzed by:

- Year
- Month
- Year + Month
- Peak transaction period
- Year-over-Year transaction change

### Peak Transaction Period

**March 2026**

Transactions:

**945,825**

> **Important:** 2026 data is available only through March. Therefore, the 2026 figure should not be interpreted as a complete-year total or compared directly with full-year totals from previous years.

---

# 📈 POWER BI DASHBOARD

The Power BI dashboard provides an interactive view of ONORC interstate transaction activity.

### Dashboard Features

- Total Transactions KPI
- Active State Routes KPI
- Interstate Transactions KPI
- Home States KPI
- Sale States KPI
- Average Transactions KPI
- Home State filter
- Sale State filter
- Year filter
- Month filter
- Monthly transaction distribution
- Top 10 Home States
- Top Sale States
- Top 10 Interstate Routes
- Transaction share by Top 5 Sale States
- Yearly transaction trend

---
# 💡 KEY BUSINESS INSIGHTS

### 1. High Transaction Volume

The dataset contains approximately **28.79 million transactions**, indicating substantial transaction activity across the covered interstate routes.

### 2. Bihar as Major Home State

Bihar records the highest transaction volume among the home states, with approximately **12.92 million transactions**.

### 3. Delhi as Major Sale State

Delhi records the highest transaction volume among the sale states, with approximately **18.94 million transactions**.

### 4. Major Interstate Route

The **Bihar → Delhi** route is the highest-volume interstate route, with approximately **9.36 million transactions**.

### 5. Extensive Interstate Network

The dataset contains **633 active state-to-state routes**, demonstrating broad interstate transaction coverage.

### 6. Peak Transaction Period

**March 2026** is the highest year-month period in the available dataset, with **945,825 transactions**.

### 7. 2026 Data Limitation

The available 2026 data covers only **January through March**, so the apparent year-over-year reduction in 2026 should not be interpreted as a full-year decline.

---

# 🐍 PYTHON ANALYSIS

Python was used for:

- Dataset loading
- Data inspection
- Data preparation
- Transaction validation
- KPI analysis
- Interstate movement analysis
- Time-series analysis
- Matplotlib visualizations

### Visualizations Created

1. Yearly Transaction Trend
2. Monthly Transaction Distribution
3. Interstate Transaction Analysis
4. Top 10 Interstate Routes
5. Year-Month Transaction Trend

---

# 🗄️ SQL ANALYSIS

The SQL analysis includes:

### Data Validation
- Row count
- Sample records
- Date range
- Missing values
- Duplicate records
- Transaction value validation

### Business KPIs
- Total transactions
- Home states
- Sale states
- Active routes
- Average transactions

### State Analysis
- Home state analysis
- Sale state analysis
- Top 10 states
- State transaction contribution

### Interstate Analysis
- Interstate routes
- Interstate transaction analysis
- Top interstate home states
- Top interstate sale states
- Active interstate routes

### Time Analysis
- Yearly trend
- Monthly trend
- Year-month trend
- Top transaction periods
- Year-over-Year analysis

---

# 📁 PROJECT STRUCTURE

```text
ONORC-Interstate-Transaction-Analysis/
│
├── data/
│   └── ONORC.csv
│
├── sql/
│   └── ONORC_SQL_Analysis.sql
│
├── python/
│   └── ONORC_Analysis.py
│
├── powerbi/
│   └── ONORC_Interstate_Transaction_Dashboard.pbix
│
├── dashboard/
│   └── ONORC_Dashboard.png
│
└── README.md
