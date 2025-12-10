WITH products AS 
    (SELECT *
    FROM {{source('public','products')}})

SELECT 
product_id,
product_category_id AS category_id,
product_name,
product_description,
product_price
-- product_image
FROM products