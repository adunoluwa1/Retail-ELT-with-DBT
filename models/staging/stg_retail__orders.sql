with orders as
    (SELECT *
    FROM {{source('public','orders')}})

SELECT 
    order_id,
    order_date,
    order_customer_id AS customer_id,
    order_status
FROM orders