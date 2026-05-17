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