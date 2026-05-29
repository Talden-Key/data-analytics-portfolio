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