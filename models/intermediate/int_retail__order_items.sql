WITH order_items AS (
    SELECT * FROM {{ref('stg_retail__order_items')}}
)

SELECT
order_item_id,
order_id,
product_id,
quantity,
subtotal,
product_price 
FROM order_items