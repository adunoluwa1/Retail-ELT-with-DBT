{{ config(materialized='table')}}

WITH sales AS (
	SELECT product_id,
	SUM(total_revenue) AS total_revenue,
	COUNT(DISTINCT quantity) AS total_units_sold
	FROM {{ref('int_fact_sales')}}
    WHERE order_status = 'COMPLETED'
	GROUP BY 1
),
products AS (
    SELECT * 
    FROM {{ref('int_dim_product')}}
)

SELECT 
    p.product_id,
    p.product_name,
    p.category_id,
    p.category_name,
    p.department_id,
    p.department_name,
    COALESCE(s.total_revenue,0) total_revenue,
    COALESCE(s.total_units_sold,0) total_units_sold,
    {{dbt.current_timestamp()}} etl_load_timestamp
FROM sales s
LEFT JOIN products p 
USING(product_id)
ORDER BY total_revenue DESC