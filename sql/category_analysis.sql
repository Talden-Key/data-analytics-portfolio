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

--Shipping Cost as a Percentage of Product Price
SELECT
    p.product_category_name,
    ROUND(AVG(oi.price),2) AS avg_price,
    ROUND(AVG(oi.freight_value),2) AS avg_shipping,
    ROUND(AVG(oi.freight_value)/AVG(oi.price)*100,2) AS shipping_percent
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY shipping_percent DESC; 

--Customer Review by Category
SELECT
    p.product_category_name,

    ROUND(
        AVG(r.review_score),
        2
    ) AS avg_review

FROM products p

JOIN order_items oi
ON p.product_id = oi.product_id

JOIN orders o
ON oi.order_id = o.order_id

JOIN order_reviews r
ON o.order_id = r.order_id

GROUP BY 1

ORDER BY avg_review DESC;