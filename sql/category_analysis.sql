--Number of Orders by Category
SELECT
    p.product_category_name,
    COUNT(*) AS total_items_sold
FROM order_items oi 
JOIN products p
    ON oi.product_id = p.product_id 
GROUP BY p.product_category_name 
ORDER BY total_items_sold DESC;