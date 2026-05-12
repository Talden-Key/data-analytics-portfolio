-- Monthly revenue
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY 1
ORDER BY 1;