--Number of Orders by Category
SELECT
    p.product_category_name,
    COUNT(*) AS total_items_sold
FROM order_items oi 
JOIN products p
    ON oi.product_id = p.product_id 
GROUP BY p.product_category_name 
ORDER BY total_items_sold DESC;

--Average Selling Price
SELECT 
    p.product_category_name,
    ROUND(AVG(oi.price),2) AS avg_price 
FROM order_items oi 
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_price DESC;

--Shipping Cost by Category
SELECT 
    p.product_category_name,
    ROUND(AVG(oi.freight_value),2) AS avg_shipping_cost
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.prodcut_category_name
ORDER BY avg_shipping_cost DESC;