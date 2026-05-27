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

-- Late Delivery Impact on Review Score
SELECT
    CASE
        WHEN o.order_delivered_customer_date::timestamp
            > o.order_estimated_delivery_date::timestamp
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,

    ROUND(AVG(r.review_score), 2) AS avg_review_score

FROM orders o
JOIN order_reviews r
    ON o.order_id = r.order_id

GROUP BY 1;