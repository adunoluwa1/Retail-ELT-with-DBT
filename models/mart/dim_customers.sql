{{ config(materialized='table') }}

WITH customers AS (
    SELECT * FROM {{ref('int_retail__customers')}}
),
sales AS (
    SELECT * FROM {{ref('int_fact_sales')}}
),
sales_tlv AS (
    SELECT 
        customer_id,
        SUM(total_revenue) AS total_lifetime_value
    FROM sales
    GROUP BY 1
),
order_totals AS (
    SELECT 
	    order_id,
	    ROUND(SUM(total_revenue)) AS total_order_value
    FROM sales
    GROUP BY 1
),
customer_aov AS (
    SELECT
        s.customer_id,
        ROUND(AVG(t.total_order_value),2) avg_order_value
    FROM sales s
    LEFT JOIN order_totals t
    USING(order_id)
    GROUP BY 1
)

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.full_name,
    c.street,
    c.city,
    c.state,
    c.zipcode,
    s.total_lifetime_value,
    o.avg_order_value,
    {{dbt.current_timestamp()}} etl_load_timestamp
FROM customers c
LEFT JOIN sales_tlv s
USING(customer_id)
LEFT JOIN customer_aov o
USING(customer_id)
