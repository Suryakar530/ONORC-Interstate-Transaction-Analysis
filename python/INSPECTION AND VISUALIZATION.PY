import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# ==========================================
# 1.1 LOAD ONORC DATASET
# ==========================================

df = pd.read_csv("ONORC.csv")

print("Dataset loaded successfully!")
print("Rows:", df.shape[0])
print("Columns:", df.shape[1])

# Display first 5 records
print("\nFirst 5 Records:")
print(df.head())

# ==========================================
# 1.2 DATA STRUCTURE & DATA TYPES
# ==========================================

print("\nDataset Information:")
print(df.info())

print("\nData Types:")
print(df.dtypes)

# ==========================================
# 1.3 MISSING VALUES & DUPLICATE CHECK
# ==========================================

print("\nMissing Values:")
print(df.isnull().sum())

print("\nTotal Missing Values:")
print(df.isnull().sum().sum())

print("\nDuplicate Rows:")
print(df.duplicated().sum())

# ==========================================
# 1.4 BASIC STATISTICAL SUMMARY
# ==========================================

print("\nStatistical Summary:")
print(df.describe())

print("\nTransaction Count Summary:")
print(df["txn_count"].describe())

# ==========================================
# 1.5 DATASET OVERVIEW & UNIQUE STATES
# ==========================================

print("\nDataset Shape:")
print(df.shape)

print("\nNumber of Unique Home States:")
print(df["homestatecode"].nunique())

print("\nNumber of Unique Sale States:")
print(df["salestatecode"].nunique())

print("\nYear Range:")
print(df["year"].min(), "to", df["year"].max())

print("\nMonth Range:")
print(df["month"].min(), "to", df["month"].max())


# ==========================================
# STEP 2 — DATA PREPARATION
# ==========================================

# 2.1 Remove unnecessary column
df = df.drop(columns=["Unnamed: 7"], errors="ignore")

print("\nColumns after removing unnecessary column:")
print(df.columns.tolist())

# ==========================================
# 2.2 CLEAN STATE NAMES & CHECK TEXT VALUES
# ==========================================

# Remove extra spaces from state names
df["homestatename"] = df["homestatename"].str.strip()
df["salestatename"] = df["salestatename"].str.strip()

# Check missing state names
print("\nMissing Home State Names:")
print(df["homestatename"].isnull().sum())

print("\nMissing Sale State Names:")
print(df["salestatename"].isnull().sum())

# Check unique state names
print("\nUnique Home State Names:")
print(df["homestatename"].nunique())

print("\nUnique Sale State Names:")
print(df["salestatename"].nunique())

# ==========================================
# 2.4 VALIDATE TRANSACTION VALUES
# ==========================================

print("\nTransaction Count Validation:")

print("Minimum Transaction Count:", df["txn_count"].min())

print("Maximum Transaction Count:", df["txn_count"].max())

print("Zero Transaction Counts:",
      (df["txn_count"] == 0).sum())

print("Negative Transaction Counts:",
      (df["txn_count"] < 0).sum())

print("Missing Transaction Counts:",
      df["txn_count"].isnull().sum())



# ==========================================
# STEP 3 — TRANSACTION & KPI ANALYSIS
# ==========================================

# 3.1 TOTAL TRANSACTIONS

total_transactions = df["txn_count"].sum()

print("\nTotal Transactions:")
print(total_transactions)

# ==========================================
# 3.2 HOME STATES & SALE STATES
# ==========================================

total_home_states = df["homestatecode"].nunique()
total_sale_states = df["salestatecode"].nunique()

print("\nTotal Home States:")
print(total_home_states)

print("\nTotal Sale States:")
print(total_sale_states)

# ==========================================
# 3.3 ACTIVE STATE ROUTES
# ==========================================

active_routes = df[
    ["homestatecode", "salestatecode"]
].drop_duplicates().shape[0]

print("\nActive State-to-State Routes:")
print(active_routes)

# ==========================================
# 3.4 AVERAGE TRANSACTIONS PER RECORD
# ==========================================

average_transactions = df["txn_count"].mean()

print("\nAverage Transactions per Record:")
print(round(average_transactions, 2))



# ==========================================
# STEP 5 — INTERSTATE MOVEMENT ANALYSIS
# ==========================================

# 5.1 CLASSIFY TRANSACTION TYPE

df["transaction_type"] = np.where(
    df["homestatecode"] == df["salestatecode"],
    "Intrastate",
    "Interstate"
)

print("\nTransaction Type:")
print(df["transaction_type"].value_counts())

# ==========================================
# 5.2 INTERSTATE VS INTRASTATE TRANSACTIONS
# ==========================================

transaction_type_summary = (
    df.groupby("transaction_type")["txn_count"]
      .sum()
      .sort_values(ascending=False)
)

print("\nInterstate vs Intrastate Transactions:")
print(transaction_type_summary)

# ==========================================
# 5.3 TRANSACTION SHARE
# ==========================================

transaction_share = (
    transaction_type_summary /
    transaction_type_summary.sum() * 100
)

print("\nTransaction Share (%):")
print(transaction_share.round(2))

# ==========================================
# 5.4 INTERSTATE-ONLY DATA
# ==========================================

interstate_df = df[
    df["transaction_type"] == "Interstate"
].copy()

print("\nInterstate Records:")
print(interstate_df.shape[0])

# ==========================================
# 5.5 TOP INTERSTATE ROUTES
# ==========================================

top_interstate_routes = (
    interstate_df
    .groupby(
        ["homestatename", "salestatename"]
    )["txn_count"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

print("\nTop 10 Interstate Routes:")
print(top_interstate_routes)


# ==========================================
# STEP 6 — TIME TREND ANALYSIS
# ==========================================

# 6.1 YEAR-WISE TRANSACTION TREND

yearly_transactions = (
    df.groupby("year")["txn_count"]
      .sum()
      .sort_index()
)

print("\nYear-wise Transactions:")
print(yearly_transactions)

# ==========================================
# 6.2 MONTH-WISE TRANSACTION TREND
# ==========================================

monthly_transactions = (
    df.groupby("month")["txn_count"]
      .sum()
      .sort_index()
)

print("\nMonth-wise Transactions:")
print(monthly_transactions)

# ==========================================
# 6.3 YEAR-MONTH TRANSACTION TREND
# ==========================================

df["transaction_date"] = pd.to_datetime(
    df["year"].astype(str) + "-" +
    df["month"].astype(str) + "-01"
)

year_month_transactions = (
    df.groupby("transaction_date")["txn_count"]
      .sum()
      .sort_index()
)

print("\nYear-Month Transaction Trend:")
print(year_month_transactions)

# ==========================================
# 6.4 PEAK TRANSACTION PERIOD
# ==========================================

peak_period = year_month_transactions.idxmax()
peak_transactions = year_month_transactions.max()

print("\nPeak Transaction Period:")
print(peak_period.strftime("%B %Y"))

print("Peak Transactions:")
print(peak_transactions)

# ==========================================
# 6.5 YEAR-OVER-YEAR CHANGE
# ==========================================

yoy_analysis = yearly_transactions.to_frame(
    name="total_transactions"
)

yoy_analysis["previous_year_transactions"] = (
    yoy_analysis["total_transactions"].shift(1)
)

yoy_analysis["yoy_change_pct"] = (
    (
        yoy_analysis["total_transactions"]
        - yoy_analysis["previous_year_transactions"]
    )
    / yoy_analysis["previous_year_transactions"]
    * 100
)

print("\nYear-over-Year Analysis:")
print(yoy_analysis.round(2))



# ==========================================
# STEP 7 — VISUALIZATIONS WITH MATPLOTLIB
# ==========================================

# ==========================================
# 7.1 YEARLY TRANSACTION TREND
# ==========================================

plt.figure(figsize=(10, 5))

plt.plot(
    yearly_transactions.index,
    yearly_transactions.values,
    marker="o"
)

plt.title("ONORC Yearly Transaction Trend")
plt.xlabel("Year")
plt.ylabel("Total Transactions")

plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("chart_1_yearly_transaction_trend",dpi=150)
plt.close()

# ==========================================
# 7.2 MONTHLY TRANSACTION TREND
# ==========================================

plt.figure(figsize=(10, 5))

plt.plot(
    monthly_transactions.index,
    monthly_transactions.values,
    marker="o"
)

plt.title("ONORC Monthly Transaction Trend")
plt.xlabel("Month")
plt.ylabel("Total Transactions")

plt.xticks(range(1, 13))
plt.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("chart_2_monthly_transaction_trend",dpi=150)
plt.close()

# ==========================================
# 7.3 INTERSTATE VS INTRASTATE
# ==========================================

transaction_type_summary = (
    df.groupby("transaction_type")["txn_count"]
      .sum()
)

plt.figure(figsize=(7, 5))

transaction_type_summary.plot(
    kind="bar"
)

plt.title("Interstate vs Intrastate Transactions")
plt.xlabel("Transaction Type")
plt.ylabel("Total Transactions")

plt.xticks(rotation=0)

plt.tight_layout()
plt.savefig("chart_3_interstate vs intrastate",dpi=150)
plt.close()

# ==========================================
# 7.4 TOP 10 INTERSTATE ROUTES
# ==========================================

route_labels = [
    f"{home} → {sale}"
    for home, sale in top_interstate_routes.index
]

plt.figure(figsize=(10, 6))

plt.barh(
    route_labels[::-1],
    top_interstate_routes.values[::-1]
)

plt.title("Top 10 Interstate Routes by Transactions")
plt.xlabel("Total Transactions")
plt.ylabel("Interstate Route")

plt.tight_layout()
plt.savefig("chart_4_top10_interstate_routes",dpi=150)
plt.close()

# ==========================================
# 7.5 YEAR-MONTH TRANSACTION TREND
# ==========================================

plt.figure(figsize=(12, 5))

plt.plot(
    year_month_transactions.index,
    year_month_transactions.values,
    marker="o"
)

plt.title("ONORC Year-Month Transaction Trend")
plt.xlabel("Year")
plt.ylabel("Total Transactions")

plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("chart_5_year_month_transaction_trend",dpi=150)
plt.close()