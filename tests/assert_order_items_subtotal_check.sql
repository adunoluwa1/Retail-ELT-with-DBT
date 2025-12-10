SELECT *
FROM {{ref('int_retail__order_items')}}
WHERE (quantity * product_price) != subtotal