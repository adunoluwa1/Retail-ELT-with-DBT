WITH products AS (
    SELECT * FROM {{ref('stg_retail__products')}}
)

SELECT
    product_id,
    category_id,
    product_name,
    product_price::NUMERIC AS product_price,
    {{ dbt.current_timestamp() }} etl_load_timestamp
FROM products