/* =========================================================
   EDA ANALYSIS ON dbo.orders_cleaned
   ========================================================= */


/* =========================================================
   1. PRODUCT REVENUE ANALYSIS
   Question:
   Which products are driving revenue versus causing losses?
   ========================================================= */

SELECT
    product_name,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(total_sales) AS gross_revenue,
    SUM(CASE WHEN order_status = 'Delivered' THEN total_sales ELSE 0
        END) AS delivered_revenue,
    SUM(CASE WHEN order_status = 'Returned' THEN total_sales ELSE 0
        END) AS returned_value,
    SUM(CASE WHEN order_status = 'Cancelled' THEN total_sales ELSE 0
        END) AS cancelled_value,
    SUM(CASE WHEN order_status = 'Refunded' THEN total_sales ELSE 0
        END) AS refunded_value,
    SUM(CASE WHEN order_status NOT IN ('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
        END) AS net_revenue,
    AVG(total_sales) AS average_order_value
FROM dbo.orders_cleaned
GROUP BY product_name
ORDER BY net_revenue DESC;

/* =========================================================
   1B. PRODUCT PROFITABILITY / LOSS IMPACT
   ========================================================= */

SELECT
    product_name,
    SUM(total_sales) AS gross_revenue,
    SUM(CASE WHEN order_status IN('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
        END) AS lost_revenue,
    SUM(CASE WHEN order_status NOT IN ('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
        END) AS net_revenue,
    CASE WHEN SUM(total_sales) = 0 THEN 0
        ELSE
        (
        SUM(CASE WHEN order_status IN ('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0 END)/ SUM(total_sales)
        ) * 100
    END AS loss_rate_percentage
FROM dbo.orders_cleaned
GROUP BY product_name
ORDER BY loss_rate_percentage DESC;

/* =========================================================
   2. CUSTOMER VALUE ANALYSIS
   Question:
   Who are the high-value and repeat customers?
   ========================================================= */

SELECT
    customer_name,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_units_purchased,
    SUM(total_sales) AS gross_customer_value,
    SUM(CASE WHEN order_status NOT IN ('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
      END) AS net_customer_value,
    AVG(total_sales) AS average_order_value,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS latest_order_date,
    DATEDIFF(DAY,MIN(order_date),MAX(order_date)) AS customer_lifetime_days
FROM dbo.orders_cleaned
GROUP BY customer_name
ORDER BY net_customer_value DESC;

/* =========================================================
   2B. IDENTIFY REPEAT CUSTOMERS
   ========================================================= */

SELECT
    customer_name,
    COUNT(*) AS number_of_orders,
    SUM(total_sales) AS total_customer_revenue,
    AVG(total_sales) AS average_order_value,
    CASE WHEN COUNT(*) > 1 THEN 'Repeat Customer' ELSE 'One-Time Customer'
    END AS customer_type
FROM dbo.orders_cleaned
GROUP BY customer_name
ORDER BY number_of_orders DESC, total_customer_revenue DESC;

/* =========================================================
   2C. HIGH-VALUE CUSTOMERS
   Customers contributing the highest net revenue
   ========================================================= */

SELECT TOP 20
    customer_name,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status NOT IN('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
        END) AS net_customer_value,
    AVG(total_sales) AS average_order_value
FROM dbo.orders_cleaned
GROUP BY customer_name
ORDER BY net_customer_value DESC;

/* =========================================================
   3. COUNTRY-WISE PERFORMANCE
   Question:
   How do orders perform across different countries?
   ========================================================= */

SELECT
    country,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(total_sales) AS gross_revenue,
    SUM(CASE WHEN order_status = 'Delivered' THEN total_sales ELSE 0
        END) AS delivered_revenue,
    SUM(CASE WHEN order_status = 'Returned' THEN total_sales ELSE 0
        END) AS returned_value,
    SUM(CASE WHEN order_status = 'Cancelled' THEN total_sales ELSE 0
        END) AS cancelled_value,
    SUM(CASE WHEN order_status NOT IN ('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
        END) AS net_revenue,
    AVG(total_sales) AS average_order_value,
    CAST(SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS delivery_rate_percentage
FROM dbo.orders_cleaned
GROUP BY country
ORDER BY net_revenue DESC;

/* =========================================================
   4A. MONTHLY REVENUE BY PRODUCT
   Question:
   How does monthly sales vary across products?
   ========================================================= */

SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    DATENAME(MONTH, order_date) AS month_name,
    product_name,
    SUM(total_sales) AS gross_revenue,
    SUM(CASE WHEN order_status NOT IN ('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
        END) AS net_revenue,
    SUM(quantity) AS units_sold,
    COUNT(*) AS number_of_orders
FROM dbo.orders_cleaned
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(MONTH, order_date),
    product_name
ORDER BY
    sales_year,
    sales_month,
    net_revenue DESC;

/* =========================================================
   4B. MONTHLY TOTAL REVENUE
   Question:
   What is the overall sales trend by month?
   ========================================================= */

SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    DATENAME(MONTH, order_date) AS month_name,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(total_sales) AS gross_revenue,
    SUM(CASE WHEN order_status NOT IN ('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
        END) AS net_revenue,
    SUM(CASE WHEN order_status IN('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
        END) AS lost_revenue,
    AVG(total_sales) AS average_order_value
FROM dbo.orders_cleaned
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(MONTH, order_date)
ORDER BY
    sales_year,
    sales_month;

/* =========================================================
   4C. MONTH-OVER-MONTH REVENUE GROWTH
   ========================================================= */

WITH MonthlySales AS
(
    SELECT
        YEAR(order_date) AS sales_year,
        MONTH(order_date) AS sales_month,
        SUM(CASE WHEN order_status NOT IN('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
            END) AS net_revenue
    FROM dbo.orders_cleaned
    WHERE order_date IS NOT NULL
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)

SELECT
    sales_year,
    sales_month,
    net_revenue,
    LAG(net_revenue) OVER (
        ORDER BY sales_year, sales_month
    ) AS previous_month_revenue,
    net_revenue
    -
    LAG(net_revenue) OVER (
        ORDER BY sales_year, sales_month
    ) AS revenue_change,

    CAST(
        (
            net_revenue
            -
            LAG(net_revenue) OVER (
                ORDER BY sales_year, sales_month
            )
        )
        * 100.0
        /
        NULLIF(
            LAG(net_revenue) OVER (
                ORDER BY sales_year, sales_month
            ),
            0
        )
        AS DECIMAL(10,2)
    ) AS month_over_month_growth_percentage
FROM MonthlySales
ORDER BY sales_year, sales_month;

/* =========================================================
   5. PRODUCT RETURN & CANCELLATION ANALYSIS
   Question:
   Which products have the highest return or cancellation rates?
   ========================================================= */

SELECT
    product_name,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0
        END) AS returned_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0
        END) AS cancelled_orders,
    SUM(CASE WHEN order_status = 'Refunded' THEN 1 ELSE 0
        END) AS refunded_orders,

    CAST(SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0
        END ) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS return_rate_percentage,
    CAST(SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS cancellation_rate_percentage,
    CAST(SUM(CASE WHEN order_status IN ('Returned', 'Cancelled', 'Refunded') THEN 1 ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS total_failure_rate_percentage,

    SUM(CASE WHEN order_status IN ('Returned', 'Cancelled', 'Refunded') THEN total_sales ELSE 0
       END) AS lost_revenue
FROM dbo.orders_cleaned
GROUP BY product_name
ORDER BY total_failure_rate_percentage DESC;

/* =========================================================
   6A. ORDER STATUS DISTRIBUTION
   Question:
   What proportion of orders are Delivered, Shipped,
   Pending, Returned, Cancelled, Refunded, etc.?
   ========================================================= */

SELECT
    order_status,
    COUNT(*) AS total_orders,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()AS DECIMAL(10,2)) AS percentage_of_orders,
SUM(total_sales) AS total_order_value,
CAST(SUM(total_sales) * 100.0 / SUM(SUM(total_sales)) OVER() AS DECIMAL(10,2)) AS percentage_of_revenue
FROM dbo.orders_cleaned
GROUP BY order_status
ORDER BY total_orders DESC;

/* =========================================================
   6B. ORDER STATUS SUMMARY
   ========================================================= */

SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status = 'Shipped' THEN 1 ELSE 0 END) AS shipped_orders,
    SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) AS pending_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    SUM(CASE WHEN order_status = 'Refunded' THEN 1 ELSE 0 END) AS refunded_orders,
    SUM(CASE WHEN order_status = 'Unknown' THEN 1 ELSE 0 END) AS unknown_orders
FROM dbo.orders_cleaned;