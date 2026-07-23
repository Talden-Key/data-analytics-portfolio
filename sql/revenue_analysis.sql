-- Monthly revenue
SELECT
	DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    SUM(oi.price) AS revenue
FROM
    olist_order_items_dataset  oi
    JOIN olist_orders_dataset  o ON oi.order_id = o.order_id
GROUP BY
    1
ORDER BY
    1;

-- Revenue Growth
SELECT
    DATE_TRUNC ('month', o.order_purchase_timestamp::timestamp ) AS month,
    SUM(oi.price) AS revenue,
    LAG (SUM(oi.price)) OVER (
        ORDER BY
            DATE_TRUNC ('month', o.order_purchase_timestamp::timestamp)
    ) AS prev_month,
    SUM(oi.price) - LAG (SUM(oi.price)) OVER (
        ORDER BY
            DATE_TRUNC ('month', o.order_purchase_timestamp::timestamp)
    ) AS growth
FROM
    olist_order_items_dataset  oi
    JOIN olist_orders_dataset  o ON oi.order_id = o.order_id
GROUP BY
    1
ORDER BY
    1;

-- Revenue by Category / Product
SELECT
    product_id,
    SUM(price) AS revenue
FROM
    olist_order_items_dataset 
GROUP BY
    product_id
ORDER BY
    revenue DESC
LIMIT
    10;


-- Average Order Value 
SELECT
    AVG(order_total) AS avg_order_value
FROM
    (
        SELECT
            order_id,
            SUM(price) AS order_total
        FROM
            olist_order_items_dataset
        GROUP BY
            order_id
    );

-- Revenue per Customer
SELECT
    o.customer_id,
    SUM(oi.price) AS total_spent
FROM olist_orders_dataset o
JOIN olist_order_items_dataset  oi ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Repeat vs New Customer Revenue
WITH customer_orders AS ( 
    SELECT 
        customer_id,
        order_id,
        order_purchase_timestamp,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp) AS order_number
    FROM olist_orders_dataset
)
SELECT 
    CASE
        WHEN order_number = 1 THEN 'new'
        ELSE 'repeat'
    END AS customer_type,
    SUM(oi.price) as revenue
FROM customer_orders co
JOIN olist_order_items_dataset oi ON co.order_id = oi.order_id
GROUP BY 1;

-- Revenue by day of week
SELECT
    TO_CHAR(o.order_purchase_timestamp::timestamp, 'Day') AS day,
    SUM(oi.price) AS revenue
FROM olist_orders_dataset  o
JOIN olist_order_items_dataset  oi ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY revenue DESC;

-- Revenue Distribution
SELECT
    product_id,
    SUM(price) AS revenue
FROM olist_order_items_dataset 
GROUP BY product_id
ORDER BY revenue DESC;

-- Order Per State
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY 1
ORDER BY total_orders DESC;

-- Payment Type Distribution
SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM order_payments
GROUP BY 1
ORDER BY total_payments DESC;

-- Customers with Repeat Purchase
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY 1
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;

-- Order Status Funnel
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Cancellation Rate
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) / COUNT(*), 2 )
        AS Cancellation_rate
FROM orders;

-- Revenue Lost From Cancellations
SELECT 
    ROUND ( SUM(oi.price), 2) AS canceled_revenue
FROM orders o
    ON o.order_id = oi.order_id;
WHERE order_status = 'canceled';

-- Revenue by Order Status
SELECT
    order_status,
    ROUND(SUM(price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY revenue DESC;

-- Funnel by Customer State
SELECT 
    c.customer_state,
    o.order_status,
    COUNT(*) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = 0.customer_id
GROUP BY 1, 2
ORDER BY 1;

-- Funnel by Product Category
SELECT
    p.product_category_name,
    o.order_status,
    COUNT(*) AS total_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id

GROUP BY 1, 2
ORDER BY 1;

-- Average Review Score by Funnel Outcome
SELECT 
    o.order_status,
    ROUND(AVG(r.review_score), 2) AS avg_review
FROM orders o
JOIN order_reviews r
    ON o.order_id = r.order_id
GROUP BY 1;

--Seller Funnel Analysis
SELECT
    oi.seller_id,
    o.order_status,
    COUNT(*) AS total_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 1, 2
ORDER BY 1;

--Customer Repeat Purchase Funnel
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-Time'
        ELSE 'Repeat'
    END AS customer_type,

    COUNT(*) AS customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY 1
) t
GROUP BY 1;

--Order status distribution
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER (), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Revenue by Seller
SELECT
    seller_id
    ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC;