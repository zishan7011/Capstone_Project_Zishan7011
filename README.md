# E-Commerce Data Analysis

## Project Overview

This project analyzes e-commerce data using SQL and Python to generate reports, explore trends, visualize key metrics, and produce business insights.

## 1. Database Setup and SQL Reports

From the repository root, execute the SQL scripts in this order: schema, seed data, and reports.

For SQLite (if the scripts are compatible):

```bash
sqlite3 ecommerce.db < sql/schema.sql
sqlite3 ecommerce.db < sql/seed_data.sql
sqlite3 ecommerce.db < sql/reports.sql
```

These scripts create the database structure, load the data, and generate analytical reports.

## 2. Data Cleaning, EDA, and Visualizations

Install Python and the required dependencies:

```bash
pip install pandas matplotlib seaborn
```

Run the analysis scripts in order:

```bash
python analysis/clean_and_eda.py
python analysis/visualize.py
```

The scripts clean the data, perform exploratory data analysis, and generate visualizations in the `visualizations/` directory.

**Task 5 of Part 2** writes the findings to `narrator/findings.json`. Ensure this task is completed before generating the narrative.

## 3. Narrative Generation

Run the narrative generator using a Gemini API key or its offline mode.

**With a Gemini API key**

Linux/macOS:

```bash
export GEMINI_API_KEY="your_api_key"
python narrator/generate_narrative.py
```

Windows PowerShell:

```powershell
$env:GEMINI_API_KEY="your_api_key"
python narrator/generate_narrative.py
```

**Without an API key (offline mode)**

```bash
python narrator/generate_narrative.py
```

The offline path depends on the fallback implemented in the script.

## Reproducibility

Run every step from the repository root and in the order shown above. Use the same source datasets, dependencies, database configuration, and analysis settings to reproduce the results.
