# CustomerOrdersAnalysis-SQL-project
Data cleaning and transformation of customer orders dataset using SQL
# 📊 Customer Orders Analysis | SQL & Power BI

## 📌 Project Overview

This project focuses on cleaning, transforming, and analyzing customer order data using **Microsoft SQL Server (SSMS)** and **Power BI** to uncover actionable business insights.

The dataset contains customer information, product details, order dates, quantities, prices, countries, and order statuses. It includes common data quality issues such as inconsistent capitalization, duplicate product naming conventions, malformed email addresses, inconsistent country names, and missing order statuses.

I developed SQL scripts to prepare the data for analysis, investigate sales performance, evaluate customer value, monitor order fulfillment, and identify products associated with returns, cancellations, and refunds. The results support data-driven decisions around customer retention, product performance, and operational efficiency.

## 🛠️ Skills & Tools Used

**Tools**
- Microsoft SQL Server Management Studio (SSMS)
- T-SQL (Transact-SQL)
- Microsoft Power BI
- CSV dataset

**Technical Skills**
- Data cleaning and transformation
- Exploratory Data Analysis (EDA)
- Data validation and duplicate detection
- Handling missing and inconsistent values
- Data type conversion using `TRY_CAST`
- Conditional logic using `CASE` statements
- Aggregations using `SUM()`, `COUNT()`, and `AVG()`
- Common Table Expressions (CTEs)
- Window functions using `LAG()`
- Month-over-month revenue analysis
- Customer segmentation and repeat-purchase analysis
- Product performance and revenue-loss analysis
- Data visualization and dashboard development

## 🔍 Business Questions Explored

1. Which products generate the highest net revenue?
2. Which products have the highest return, cancellation, and refund rates?
3. Who are the highest-value and repeat customers?
4. Which countries generate the most revenue?
5. How does revenue change month over month?
6. What proportion of orders are delivered, shipped, pending, returned, cancelled, or refunded?
7. How much revenue is associated with unsuccessful orders?

## 💡 Insights

The analysis examines several dimensions of business performance:

- **Customer value:** Identifies high-value customers, repeat purchasers, average order values, and customer purchasing timelines.
- **Product performance:** Compares gross revenue, net revenue, units sold, and revenue associated with returns, cancellations, and refunds.
- **Geographic performance:** Evaluates order volume, revenue, average order value, and delivery rates across countries.
- **Sales trends:** Tracks monthly revenue, identifies changes in sales performance, and calculates month-over-month growth.
- **Order fulfillment:** Examines order-status distribution to highlight potential fulfillment delays and revenue at risk.
- **Data quality:** Identifies inconsistencies that could distort reporting, customer analysis, and business decisions.

## 📈 Key Findings

Initial exploration of the 499-row dataset revealed the following:

- **176 delivered orders:** Approximately 35.3% of all records were marked as delivered.
- **100 returned orders:** Approximately 20.0% of records were marked as returned, highlighting the importance of investigating product and customer return patterns.
- **98 pending orders:** Approximately 19.6% of records were pending, suggesting an opportunity to examine fulfillment backlogs.
- **92 shipped orders:** Approximately 18.4% of records were shipped, indicating that a substantial portion of orders had not yet reached the delivered stage.
- **Data standardization matters:** Variations such as `iPhone 14`, `IPHONE14`, and differently formatted country names can fragment product and geographic reporting unless normalized.
- **Revenue protection is essential:** Separating delivered sales from returned, cancelled, and refunded orders helps businesses distinguish gross sales from revenue that remains after unsuccessful order outcomes.

*Note: These findings are based on the initial dataset. Final financial totals and product or country rankings should be taken from the cleaned data and validated Power BI measures.*

## 📁 Project Structure

```text
Customer Analysis/
│
├── Customer Analysis Script README.md
│   └── SQL script for data cleaning and validation
│
├── Exploratory Data Analysis Script.sql
│   └── SQL queries for customer, product, revenue,
│       country, monthly trend, and order-status analysis
│
├── Customer Analysis Visualization.pbix
│   └── Power BI dashboard and visual analysis
│
└── orders.csv
    └── Raw customer orders dataset
```

## 🚀 How to Use This Project

1. Import `orders.csv` into Microsoft SQL Server as the source `dbo.orders` table.
2. Open the data-cleaning SQL script in SSMS and execute it to create the cleaned `dbo.orders_cleaned` table.
3. Review the validation queries for missing values and duplicate order IDs.
4. Execute `Exploratory Data Analysis Script.sql` against the cleaned table to investigate the business questions.
5. Open `Customer Analysis Visualization.pbix` in Power BI Desktop to explore the visual analysis.

**Prerequisites:** SQL Server, SSMS, and Power BI Desktop.

## 🎓 What I Learned

This project strengthened my ability to translate raw, inconsistent data into structured information for business decision-making. It also improved my practical understanding of SQL-based data preparation, analytical querying, customer behavior analysis, revenue monitoring, and communicating findings through dashboards.

## 🙏 Credits

- **Project inspiration:** [CustomerOrders SQL Project by Ramsha Arshad](https://github.com/Ramsha-Arshad/CustomerOrders-SQL-project/tree/main)
- **Dataset:** `orders.csv`, included in this project repository.
- **Tools:** Microsoft SQL Server and Microsoft Power BI.

This project was developed as part of my continued growth in data analytics and business intelligence.

## 🤝 Connect With Me

**Inimfonabasi Udomisor**  
Business Analytics Professional

📧 Email: [inimfonabasiudomisor@gmail.com](mailto:inimfonabasiudomisor@gmail.com)

I'm open to opportunities, collaborations, and conversations around data analytics, SQL, Power BI, and business intelligence.

---

⭐ If you find this project useful, feel free to star the repository!
