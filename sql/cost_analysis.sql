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