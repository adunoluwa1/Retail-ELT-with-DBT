{{ config(materialized='table') }}

WITH order_totals AS (
    SELECT *
    FROM {{ref('int_retail__order_items')}}
)

SELECT 
	order_id,
	SUM(subtotal) AS total_order_value
FROM order_totals
GROUP BY 1