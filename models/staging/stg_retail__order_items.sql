WITH order_items AS
    (SELECT * 
    FROM {{source('public','order_items')}})

SELECT
order_item_id,
order_item_order_id AS order_id,
order_item_product_id AS product_id,
order_item_quantity AS quantity,
order_item_subtotal::NUMERIC AS subtotal,
order_item_product_price::NUMERIC AS product_price 
FROM order_items