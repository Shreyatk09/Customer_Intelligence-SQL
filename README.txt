# Customer Intelligence & Retention Analysis Using SQL

## Project Overview
A SQL-based data analytics project that explores customer purchasing behavior, identifies potentially inactive customers, and analyzes product and city-level sales performance.

## Business Objectives
- Identify high-value customers based on delivered-purchase spending.
- Analyze customer purchase frequency and recency.
- Segment customers using defined business rules.
- Compare product performance and city-wise revenue.
- Validate sales calculations and order statuses.

## Tools & Technologies
- MySQL
- MySQL Workbench
- SQL

## Database Schema
The project uses three relational tables:

- **customers:** Customer details, city, and signup date.
- **products:** Product names, categories, and prices.
- **orders:** Customer purchases, dates, quantities, and order statuses.

## SQL Concepts Demonstrated
- Primary and foreign keys
- INNER JOIN and LEFT JOIN
- GROUP BY and ORDER BY
- Aggregate functions: SUM, COUNT, MAX
- CASE statements and conditional aggregation
- Common Table Expressions (CTEs)
- Date calculations using DATEDIFF
- Data validation and filtering

## Business Questions
1. Which customers generate the most revenue?
2. Which customers have not purchased recently?
3. How can customers be segmented by spending and purchase recency?
4. Which products generate the most revenue?
5. Which cities contribute the most delivered-order revenue?

## Project Structure
- `customer_intelligence.sql` — database setup, sample data, and analysis queries.
- `results/` — exported CSV results from the analyses.
- `screenshots/` — selected query results, if available.

## Dataset & Limitations
This project uses a small synthetic dataset created for learning and demonstration. Customer segment thresholds are illustrative and would need validation against real business data.

## Future Improvements
- Analyze a larger dataset.
- Build an interactive Power BI dashboard.
- Automate customer retention reporting.
