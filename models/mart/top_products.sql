{{ congif(materialized='table')}}

WITH sales AS (
	SELECT product_id,
	SUM(total_revenue) AS total_revenue
	FROM {{ref('int_fact_sales')}}
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
    COALESCE(s.total_revenue,0) total_revenue
FROM products p 
LEFT JOIN sales s
USING(product_id)
ORDER BY total_revenue DESC;