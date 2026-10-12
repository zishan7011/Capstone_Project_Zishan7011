E-Commerce Data Analysis and Narrative Generation
Project Overview

This project analyzes e-commerce data using SQL and Python to generate reports, visualizations, and business insights.

1. Database Setup and SQL Reports

Install MySQL and create the project database. Open a terminal in the repository root and connect to MySQL:

mysql -u root -p


Run the following commands inside the MySQL prompt in the given order:

CREATE DATABASE ecommerce;
USE ecommerce;
SOURCE sql/schema.sql;
SOURCE sql/seed_data.sql;
SOURCE sql/reports.sql;


The input CSV files are stored in the data/ directory. The SQL scripts create the schema, load the data, and generate analytical reports.

2. Data Analysis and Visualization

Install Python and the required dependencies. From the repository root, run:

python analysis/clean_and_eda.py
python analysis/visualize.py


Task 5 of Part 2 writes the analysis findings to narrator/findings.json.

The visualization script generates charts, including:

visualizations/return_rate_by_payment.png
visualizations/monthly_revenue_trend.png
3. Generate the Business Narrative

To use Gemini, set your API key as an environment variable.

Linux/macOS:

export GEMINI_API_KEY="your_api_key"
python narrator/generate_narrative.py


Windows PowerShell:

$env:GEMINI_API_KEY="your_api_key"
python narrator/generate_narrative.py


Offline mode (without an API key):

python narrator/generate_narrative.py


When no API key is set, the script should use its offline fallback, if implemented.

Reproducibility

Run the steps in order, using the same CSV files and database configuration to reproduce the reports, findings, and visualizations. Verify dependencies and offline behavior against the actual scripts.
