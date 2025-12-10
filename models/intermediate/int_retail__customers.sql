WITH customers AS (
    SELECT * FROM {{ref('stg_retail__customers')}}
)

SELECT

FROM customers