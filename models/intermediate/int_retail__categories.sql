WITH categories AS (
    SELECT * FROM {{ref('stg_retail__categories')}}
)

SELECT
    category_id,
    department_id,
    category_name,
    {{dbt.current_timestamp()}} etl_load_timestamp
FROM categories