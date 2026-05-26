-- Average Delivery Time
SELECT
    ROUND(
        AVG(
            DATE_PART(
                'day',
                o.order_delivered_customer_date::timestamp
                - o.order_purchase_timestamp::timestamp
            )
        ),
        2
    ) AS avg_delivery_days
FROM orders o
WHERE o.order_status = 'delivered';

-- Late Delivery
SELECT
    COUNT(*) AS late_orders
FROM orders
WHERE order_delivered_customer_date::timestamp
    > order_estimated_delivery_date::timestamp;