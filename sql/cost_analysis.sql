-- Freight Cost Analysis
SELECT
    p.product_category_name,
    ROUND(AVG(oi.freight_value), 2) AS avg_shipping
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY avg_shipping DESC;

-- Monthly Freight Cost Trend
SELECT
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp::timestamp
    ) AS month,

    ROUND(SUM(oi.freight_value), 2) AS freight_cost

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY 1
ORDER BY 1;

-- Freight Cost as % of Revenue
SELECT
    ROUND(
        100.0 *
        SUM(freight_value)
        / SUM(price),
        2
    ) AS freight_percent_of_sales
FROM order_items;

-- Product Categories with Highest Shipping Cost
SELECT
    p.product_category_name,
    ROUND(
        AVG(oi.freight_value),
        2
    ) AS avg_shipping_cost

FROM order_items oi
JOIN products payment_type
    ON oi.product_id = p.product_id

GROUP BY 1
ORDER BY avg_shipping_cost DESC 
LIMIT 10;

-- Shipping Cost vs Product Price
SELECT
    p.product_category_name, 
    ROUND(AVG(oi.price),2) AS avg_price,
    ROUND(AVG(oi.freight_value),2) AS avg_shipping,
    ROUND(AVG(oi.freight_value)/ AVG(oi.price) * 100, 2) AS shipping_percentage
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY shipping_percent DESC;

-- States With Highest Delivery Cost
SELECT
    p.product_category_name,

    ROUND(AVG(oi.price), 2) AS avg_price,

    ROUND(AVG(oi.freight_value), 2) AS avg_shipping,

    ROUND(
        AVG(oi.freight_value)
        / AVG(oi.price) * 100,
        2
    ) AS shipping_percent

FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id

GROUP BY 1
ORDER BY shipping_percent DESC;

-- Sellet Shipping Cost Analysis
SELECT 
    seller_id,

    ROUND(
        AVG(freight_value),
        2
    ) AS avg_shipping_cost

FROM order_items

GROUP BY 1
ORDER BY avg_shipping_cost DESC
LIMIT 20;

--Delivery Delay Cost Analysis
SELECT
    CASE
        WHEN order_delivered_customer_date::timestamp
             > order_estimated_delivery_date::timestamp
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,

    ROUND(
        AVG(oi.freight_value),
        2
    ) AS avg_shipping_cost

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY 1;

-- Revenue vs Freight by Category
SELECT 
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(SUM(oi.freight_value),2 ) AS avg_shipping_cost
FROM order_items oi
JOIN products payment_type
    ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY revenue DESC;

--Estimated Gross Margin Analysis
SELECT
    order_id,

    ROUND(SUM(price), 2) AS revenue,

    ROUND(
        SUM(price) * 0.70,
        2
    ) AS estimated_product_cost,

    ROUND(
        SUM(freight_value),
        2
    ) AS shipping_cost,

    ROUND(
        SUM(price)
        - (SUM(price) * 0.70)
        - SUM(freight_value),
        2
    ) AS estimated_profit

FROM order_items

GROUP BY 1;

-- Estimated Gross Margin Analysis
SELECT 
    order_id,
    ROUND(SUM(price), 2) AS revenue,
    ROUND(SUM(price) * 0.70, 2) AS estimated_product_cost,
    ROUND(SUM(freight_value), 2) AS shipping_cost,
    ROUND(SUM(price) - (SUM(price)*0.70)-(SUM(freight_value),2) AS estimated_profit)
FROM order_items
GROUP BY 1;

-- Cost Per Order
SELECT
    ROUND(
        AVG(order_shipping_cost),
        2
    ) AS avg_shipping_per_order
FROM (
    SELECT
        order_id,
        SUM(freight_value) AS order_shipping_cost
    FROM order_items
    GROUP BY order_id
) t;

-- Freight Cost Distribution
SELECT
    CASE 
        WHEN freight_value < 10 THEN 'Low'
        WHEN freight_value < 30 THEN 'Medium'
        ELSE 'High'
    END AS cost_bucket,

    COUNT(*) AS total_orders

FROM order_items
GROUP BY 1
ORDER BY total_orders DESC;