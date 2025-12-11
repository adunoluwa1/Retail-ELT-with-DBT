WITH departments AS (
    SELECT * FROM {{ref('stg_retail__departments')}}
)

SELECT
    department_id,
    department_name,
    {{dbt.current_timestamp()}} etl_load_timestamp
FROM departments