-- ============================================================================
-- Report (a): Order totals
-- ============================================================================
/*
Output:
total_orders | total_revenue | avg_order_value
180          | 99860.20      | 554.78
*/
SELECT 
    COUNT(*) AS total_orders,
    ROUND(SUM(o.quantity * p.price * (1.0 - COALESCE(o.discount_pct, 0) / 100.0)), 2) AS total_revenue,
    ROUND(AVG(o.quantity * p.price * (1.0 - COALESCE(o.discount_pct, 0) / 100.0)), 2) AS avg_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id;


-- ============================================================================
-- Report (b): COUNT(*) vs COUNT(column)
-- ============================================================================
/*
Output:
total_orders | rated_orders | unrated_orders
180          | 165          | 15
*/
SELECT 
    COUNT(*) AS total_orders,
    COUNT(rating) AS rated_orders,
    COUNT(*) - COUNT(rating) AS unrated_orders
FROM orders;


-- ============================================================================
-- Report (c): LEFT JOIN with a genuine zero-match row
-- ============================================================================
/*
Output (Query 1):
customer_id | name
C045        | Vihaan

Output (Query 2):
customer_id | name
C045        | Vihaan
*/
-- Query 1: Using LEFT JOIN and HAVING
SELECT 
    c.customer_id,
    c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) = 0;

-- Query 2: Independent verification using NOT IN
SELECT 
    customer_id,
    name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM orders
);


-- ============================================================================
-- Report (d): GROUP BY + HAVING (High return rate cities)
-- ============================================================================
/*
Output:
city    | total_orders | returned_orders | return_rate_pct
Jaipur  | 19           | 8               | 42.1
Lucknow | 49           | 15              | 30.6
Bangalore | 33         | 8               | 24.2
*/
SELECT 
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.returned) AS returned_orders,
    ROUND(100.0 * SUM(o.returned) / COUNT(o.order_id), 1) AS return_rate_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING return_rate_pct > 20
ORDER BY return_rate_pct DESC;


-- ============================================================================
-- Report (e): Ranking with ORDER BY + LIMIT / OFFSET
-- ============================================================================
/*
Output (LIMIT 5):
customer_id | name    | total_spend
C043        | Reyansh | 12920.00
C026        | Isha    | 8371.60
C008        | Meera   | 4564.60
C011        | Arjun   | 4111.00
C042        | Sanya   | 3785.00

Output (LIMIT 3 OFFSET 2):
customer_id | name    | total_spend
C008        | Meera   | 4564.60
C011        | Arjun   | 4111.00
C042        | Sanya   | 3785.00
*/
-- Deterministic tie-breaking on customer_id ASC prevents arbitrary result ordering when total_spend is identical.
SELECT 
    c.customer_id,
    c.name,
    ROUND(SUM(o.quantity * p.price * (1.0 - COALESCE(o.discount_pct, 0) / 100.0)), 2) AS total_spend
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spend DESC, c.customer_id ASC
LIMIT 5;

-- Slicing ranks 3 to 5 using OFFSET:
SELECT 
    c.customer_id,
    c.name,
    ROUND(SUM(o.quantity * p.price * (1.0 - COALESCE(o.discount_pct, 0) / 100.0)), 2) AS total_spend
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spend DESC, c.customer_id ASC
LIMIT 3 OFFSET 2;


-- ============================================================================
-- Report (f): Three-table JOIN with GROUP BY
-- ============================================================================
/*
Output:
category     | order_count | category_revenue
Haircare     | 54          | 44956.10
Skincare     | 60          | 27346.00
Babycare     | 30          | 16805.00
PersonalCare | 36          | 10753.10
*/
SELECT 
    p.category,
    COUNT(o.order_id) AS order_count,
    ROUND(SUM(o.quantity * p.price * (1.0 - COALESCE(o.discount_pct, 0) / 100.0)), 2) AS category_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY p.category
ORDER BY category_revenue DESC;


-- ============================================================================
-- Report (g): LIKE pattern match (Name starts with 'A')
-- ============================================================================
/*
Output:
customer_id | name    | city      | city_tier | signup_date | acquisition_source
C001        | Aarav   | Mumbai    | 1         | 2026-01-07  | Organic
C003        | Aditi   | Mumbai    | 1         | 2026-06-23  | Organic
C004        | Ananya  | Lucknow   | 2         | 2026-01-23  | Organic
C011        | Arjun   | Bangalore | 1         | 2026-03-13  | Referral
C021        | Aryan   | Bangalore | 1         | 2026-02-11  | Ad
C030        | Anika   | Bangalore | 1         | 2026-02-24  | Organic
C031        | Aditya  | Jaipur    | 2         | 2026-06-14  | Ad
C036        | Aisha   | Delhi     | 1         | 2026-05-11  | Ad
C041        | Ayaan   | Lucknow   | 2         | 2026-01-03  | Organic
C044        | Aria    | Bangalore | 1         | 2026-04-22  | Referral
*/
SELECT * 
FROM customers 
WHERE name LIKE 'A%';


-- ============================================================================
-- Report (h): DISTINCT acquisition sources
-- ============================================================================
/*
Output:
acquisition_source
Ad
Organic
Referral
Social
*/
SELECT DISTINCT acquisition_source 
FROM customers;


-- ============================================================================
-- Report (i): ALTER TABLE + UPDATE with CASE
-- ============================================================================
/*
Output:
loyalty_tier | customer_count
Gold         | 28
Silver       | 17
*/
-- Step 1: Add new column
ALTER TABLE customers ADD COLUMN loyalty_tier VARCHAR(10);

-- Step 2: Populate all rows based on city_tier
UPDATE customers 
SET loyalty_tier = CASE 
    WHEN city_tier = 1 THEN 'Gold' 
    ELSE 'Silver' 
END;

-- Step 3: Verification aggregation query
SELECT 
    loyalty_tier, 
    COUNT(*) AS customer_count
FROM customers 
GROUP BY loyalty_tier;
