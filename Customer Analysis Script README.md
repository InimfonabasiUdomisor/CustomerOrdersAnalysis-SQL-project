/* =========================================================
   ORDERS TABLE CLEANING SCRIPT
   ========================================================= */
DROP TABLE dbo.orders_cleaned;
SELECT
    ---------------------------------------------------------
    -- 1. ORDER ID
    ---------------------------------------------------------
    TRY_CAST(order_id AS INT) AS order_id,

    ---------------------------------------------------------
    -- 2. CUSTOMER NAME
    -- Remove leading/trailing spaces
    -- Convert inconsistent capitalization
    ---------------------------------------------------------
    CASE
        WHEN NULLIF(LTRIM(RTRIM(customer_name)), '') IS NULL
            THEN 'Unknown Customer'
        ELSE
            CONCAT(
                UPPER(LEFT(LOWER(LTRIM(RTRIM(customer_name))), 1)),
                SUBSTRING(
                    LOWER(LTRIM(RTRIM(customer_name))),
                    2,
                    LEN(LTRIM(RTRIM(customer_name)))
                )
            )
    END AS customer_name,

    ---------------------------------------------------------
    -- 3. EMAIL
    -- Remove spaces
    -- Convert to lowercase
    ---------------------------------------------------------
    CASE
        WHEN NULLIF(LTRIM(RTRIM(email)), '') IS NULL
            THEN 'null'
        ELSE LOWER(LTRIM(RTRIM(email)))
    END AS email,

    ---------------------------------------------------------
    -- 4. ORDER DATE
    -- Convert text date into DATE
    ---------------------------------------------------------
    TRY_CAST(LTRIM(RTRIM(order_date)) AS DATE) AS order_date,

    ---------------------------------------------------------
    -- 5. PRODUCT NAME
    -- Standardize common product variations
    ---------------------------------------------------------
    CASE
        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%iphone 14 pro%'
            THEN 'iPhone 14 Pro'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%iphone 14%'
            THEN 'iPhone 14'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%iphone 13%'
            THEN 'iPhone 13'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%i phone 13%'
            THEN 'iPhone 13'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%iphone%'
            THEN 'iPhone'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%mac book pro%'
            THEN 'MacBook Pro'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%macbook pro%'
            THEN 'MacBook Pro'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%macbook air%'
            THEN 'MacBook Air'

        WHEN LOWER(LTRIM(RTRIM(product_name))) = 'macbook'
            THEN 'MacBook'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%samsung galaxy s21%'
            THEN 'Samsung Galaxy S21'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%samsung galaxy s23 ultra%'
            THEN 'Samsung Galaxy S23 Ultra'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%samsung galaxy s23%'
            THEN 'Samsung Galaxy S23'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%samsung galaxy s22%'
            THEN 'Samsung Galaxy S22'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%google pixel 7a%'
            THEN 'Google Pixel 7a'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%google pixel%'
            THEN 'Google Pixel'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%airpods pro%'
            THEN 'AirPods Pro'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%airPods%'
            THEN 'AirPods'

        WHEN LOWER(LTRIM(RTRIM(product_name))) LIKE '%apple watch%'
            THEN 'Apple Watch'

        WHEN NULLIF(LTRIM(RTRIM(product_name)), '') IS NULL
            THEN 'Unknown Product'

        ELSE
            LTRIM(RTRIM(product_name))
    END AS product_name,

    ---------------------------------------------------------
    -- 6. QUANTITY
    -- Convert words to numbers
    ---------------------------------------------------------
    CASE
        WHEN LOWER(LTRIM(RTRIM(quantity))) = 'one'
            THEN 1

        WHEN LOWER(LTRIM(RTRIM(quantity))) = 'two'
            THEN 2

        WHEN LOWER(LTRIM(RTRIM(quantity))) = 'three'
            THEN 3

        ELSE TRY_CAST(
            LTRIM(RTRIM(quantity))
            AS INT
        )
    END AS quantity,

    ---------------------------------------------------------
    -- 7. PRICE
    -- Remove $, commas and spaces
    ---------------------------------------------------------
    TRY_CAST(
        REPLACE(
            REPLACE(
                LTRIM(RTRIM(price)),
                '$',
                ''
            ),
            ',',
            ''
        )
        AS DECIMAL(12,2)
    ) AS price,

    ---------------------------------------------------------
    -- 8. COUNTRY
    -- Standardize country names
    ---------------------------------------------------------
    CASE
        WHEN LOWER(LTRIM(RTRIM(country))) IN
            ('usa', 'u.s.a', 'u s a', 'Us', 'united states')
            THEN 'United States'

        WHEN LOWER(LTRIM(RTRIM(country))) IN
            ('uk', 'u.k.', 'united kingdom')
            THEN 'United Kingdom'

        WHEN LOWER(LTRIM(RTRIM(country))) = 'canada'
            THEN 'Canada'

        WHEN LOWER(LTRIM(RTRIM(country))) = 'india'
            THEN 'India'

        WHEN LOWER(LTRIM(RTRIM(country))) = 'spain'
            THEN 'Spain'

        ELSE
            CONCAT(
                UPPER(LEFT(LOWER(LTRIM(RTRIM(country))), 1)),
                SUBSTRING(
                    LOWER(LTRIM(RTRIM(country))),
                    2,
                    LEN(LTRIM(RTRIM(country)))
                )
            )
    END AS country,

    ---------------------------------------------------------
    -- 9. ORDER STATUS
    -- Standardize status values
    ---------------------------------------------------------
    CASE
        WHEN LOWER(LTRIM(RTRIM(order_status))) = 'delivered'
            THEN 'Delivered'

        WHEN LOWER(LTRIM(RTRIM(order_status))) = 'shipped'
            THEN 'Shipped'

        WHEN LOWER(LTRIM(RTRIM(order_status))) = 'pending'
            THEN 'Pending'

        WHEN LOWER(LTRIM(RTRIM(order_status))) = 'returned'
            THEN 'Returned'

        WHEN LOWER(LTRIM(RTRIM(order_status))) = 'cancelled'
            THEN 'Cancelled'

        WHEN LOWER(LTRIM(RTRIM(order_status))) = 'refunded'
            THEN 'Refunded'

        WHEN NULLIF(LTRIM(RTRIM(order_status)), '') IS NULL
            THEN 'Unknown'

        ELSE
            CONCAT(
                UPPER(LEFT(LOWER(LTRIM(RTRIM(order_status))), 1)),
                SUBSTRING(
                    LOWER(LTRIM(RTRIM(order_status))),
                    2,
                    LEN(LTRIM(RTRIM(order_status)))
                )
            )
    END AS order_status

INTO dbo.orders_cleaned

FROM dbo.orders;

---------------------------------------------------------
-- 10. CHECK FOR REMAINING NULLS
---------------------------------------------------------
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS missing_customer_name,
    SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS missing_email,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS missing_order_date,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS missing_product_name,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS missing_price,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS missing_order_status
FROM dbo.orders_cleaned;

---------------------------------------------------------
-- 11. CHECK FOR DUPLICATES
---------------------------------------------------------
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM dbo.orders_cleaned
GROUP BY order_id
HAVING COUNT(*) > 1;

---------------------------------------------------------
-- 12. CREATE HELPER COLUMN
---------------------------------------------------------
ALTER TABLE dbo.orders_cleaned
ADD total_sales AS (quantity * price);

---------------------------------------------------------
-- 13. FIXING IRREGULARITIES IN THE TABLE
---------------------------------------------------------
UPDATE o
SET o.price = p.correct_price
FROM dbo.orders_cleaned AS o
CROSS APPLY
(
    SELECT TOP 1
        price AS correct_price
    FROM dbo.orders_cleaned
    WHERE product_name = o.product_name
      AND product_name <> 'NULL'
      AND price > 0
    GROUP BY price
    ORDER BY COUNT(*) DESC, price DESC
) AS p
WHERE o.price <= 0
  AND o.product_name <> 'NULL'
UPDATE dbo.orders_cleaned
SET email =
    CASE
        WHEN email LIKE '%@@%'
            THEN REPLACE(email, '@@', '@')

        WHEN email LIKE '%@%'
             AND email NOT LIKE '%.com%'
            THEN email + '.com'

        ELSE email
    END;

---------------------------------------------------------
-- 14. CHECK CLEANED DATA
---------------------------------------------------------
SELECT *
FROM dbo.orders_cleaned;

-- CHECK NUMBER OF RECORDS
SELECT COUNT(*) AS total_rows
FROM dbo.orders_cleaned;

