E-Commerce Data Analysis & Narrative Generation
Project Overview

This project analyzes e-commerce data using SQL and Python to generate business reports, visualizations, and AI-generated or offline narratives.

1. Run SQL Scripts

Ensure your SQL database is running and create a database for the project. Open your SQL client and execute the scripts in this order:

Load the database schema:
   SOURCE sql/schema.sql;

Import the sample data:
   SOURCE sql/seed_data.sql;

Generate analytical reports:
   SOURCE sql/reports.sql;


Run these commands from the project root using a compatible MySQL client. The CSV files are located in data/.

2. Run Data Analysis and Visualizations

Install the required Python libraries for your scripts, then run:

python analysis/clean_and_eda.py
python analysis/visualize.py


The first script cleans the data and performs exploratory data analysis. Task 5 of Part 2 writes narrator/findings.json, which contains the findings used by the narrative generator.

The visualization script generates charts, including monthly revenue trends and return rates by payment method, in the visualizations/ directory.

3. Generate the Narrative

To enable Gemini-powered narrative generation, set your API key as an environment variable.

Linux/macOS:

export GEMINI_API_KEY="your_api_key"
python narrator/generate_narrative.py


Windows PowerShell:

$env:GEMINI_API_KEY="your_api_key"
python narrator/generate_narrative.py


Offline mode (no API key):

Simply run:

python narrator/generate_narrative.py


The script can use the locally generated findings without a Gemini API key, provided offline fallback is implemented.

Reproducibility

Run all steps in order, from SQL setup through narrative generation, to reproduce the project's reports, charts, and findings.
