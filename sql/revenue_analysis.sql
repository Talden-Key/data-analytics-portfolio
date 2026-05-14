-- Monthly revenue
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY 1
ORDER BY 1;

-- Revenue Growth
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue,
    LAG(SUM(oi.price)) OVER (ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)) AS prev_month,
    SUM(oi.price) - LAG(SUM(oi.price)) OVER (ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)) AS growth
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY 1
ORDER BY 1;

-- Revenue by Category / Product
SELECT
    product_id,
    SUM(price) AS revenue
FROM order_items
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;