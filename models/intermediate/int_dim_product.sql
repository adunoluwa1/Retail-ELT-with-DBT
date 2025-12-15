{{ config(materialized='table') }}

WITH product_dim AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        c.category_name,
        c.department_id,
        d.department_name,
        p.product_price,
        {{ dbt.current_timestamp() }} etl_load_timestamp
    FROM dev.int_retail__products p
    LEFT JOIN {{ref('int_retail__categories')}} c
        USING(category_id)
    LEFT JOIN {{ref('int_retail__departments')}} d
        USING(department_id))

SELECT *
FROM product_dim