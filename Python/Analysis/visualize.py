import os
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Ensure target output directory exists
os.makedirs("visualizations", exist_ok=True)

# 1. Load data
customers = pd.read_csv("data/customers.csv")
products = pd.read_csv("data/products.csv")
orders = pd.read_csv("data/orders.csv")

# 2. Pipeline transformation
orders["payment_method"] = orders["payment_method"].str.strip().str.upper()

natural_key = [
    "customer_id",
    "product_id",
    "order_date",
    "quantity",
    "discount_pct",
    "payment_method",
    "rating",
    "returned",
]
orders_clean = orders.drop_duplicates(subset=natural_key, keep="first").copy()
orders_clean["discount_pct"] = orders_clean["discount_pct"].fillna(0)
orders_clean["rating"] = orders_clean["rating"].fillna(orders_clean["rating"].median())

merged = orders_clean.merge(products, on="product_id", how="left").merge(
    customers, on="customer_id", how="left"
)
merged["order_value"] = (
    merged["quantity"] * merged["price"] * (1 - merged["discount_pct"] / 100.0)
)

# Detect outliers via IQR
q1 = merged["quantity"].quantile(0.25)
q3 = merged["quantity"].quantile(0.75)
iqr = q3 - q1
upper_bound = q3 + 1.5 * iqr
lower_bound = q1 - 1.5 * iqr
merged["is_outlier"] = (merged["quantity"] < lower_bound) | (merged["quantity"] > upper_bound)

# ------------------------------------------------------------------------------
# Visualization 1: Return Rate by Payment Method
# ------------------------------------------------------------------------------
payment_stat = (
    merged.groupby("payment_method")["returned"]
    .mean()
    .mul(100)
    .sort_values(ascending=False)
)

plt.figure(figsize=(7, 5))
bars = plt.bar(payment_stat.index, payment_stat.values, color=["#d9534f", "#337ab7", "#5cb85c"], width=0.55)
plt.title("COD Returns at 44.4% — 3x Card", fontsize=13, fontweight="bold", pad=12)
plt.xlabel("Payment Method", fontsize=11)
plt.ylabel("Return Rate (%)", fontsize=11)
plt.ylim(0, 52)
plt.grid(axis="y", linestyle="--", alpha=0.5)

for bar in bars:
    height = bar.get_height()
    plt.annotate(
        f"{height:.1f}%",
        xy=(bar.get_x() + bar.get_width() / 2, height),
        xytext=(0, 4),
        textcoords="offset points",
        ha="center",
        va="bottom",
        fontsize=10,
        fontweight="bold",
    )

plt.tight_layout()
plt.savefig("visualizations/return_rate_by_payment.png", dpi=300)
plt.close()
print("Saved visualizations/return_rate_by_payment.png")

# ------------------------------------------------------------------------------
# Visualization 2: Monthly Revenue Trend (Outlier-Corrected)
# ------------------------------------------------------------------------------
merged["order_date"] = pd.to_datetime(merged["order_date"])
merged["year_month"] = merged["order_date"].dt.to_period("M").astype(str)

clean_monthly = (
    merged[~merged["is_outlier"]]
    .groupby("year_month")["order_value"]
    .sum()
)

plt.figure(figsize=(8, 5))
plt.plot(clean_monthly.index, clean_monthly.values, marker="o", linewidth=2.5, color="#2e6da4")
plt.title("Outlier-Corrected Revenue Trend — Peak Month: March 2026", fontsize=13, fontweight="bold", pad=12)
plt.xlabel("Month", fontsize=11)
plt.ylabel("Total Revenue (₹)", fontsize=11)
plt.ylim(7000, 23000)
plt.grid(True, linestyle="--", alpha=0.5)

for x, y in zip(clean_monthly.index, clean_monthly.values):
    plt.annotate(
        f"₹{y:,.2f}",
        xy=(x, y),
        xytext=(0, 7),
        textcoords="offset points",
        ha="center",
        fontsize=9,
        fontweight="bold" if x == "2026-03" else "normal",
        color="#d9534f" if x == "2026-03" else "#333333",
    )

plt.tight_layout()
plt.savefig("visualizations/monthly_revenue_trend.png", dpi=300)
plt.close()
print("Saved visualizations/monthly_revenue_trend.png")
