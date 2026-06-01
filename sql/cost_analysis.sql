-- Freight Cost Analysis
SELECT
    p.product_category_name,
    ROUND(AVG(oi.freight_value), 2) AS avg_shipping
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY avg_shipping DESC;