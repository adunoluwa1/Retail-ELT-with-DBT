{{config(materialized='table')}}
{%- set order_statuses = ['COMPLETED','PENDING','CLOSED','SUSPECTED_FRAUD'] -%}

WITH orders AS (
    SELECT *
    FROM {{ref('int_retail__orders')}}
),
customer_orders AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) AS num_orders,
        {%- for order_status in order_statuses %}
        SUM(CASE WHEN order_status = '{{order_status}}' THEN 1 ELSE 0 END) AS num_{{order_status}}_orders
        {%- if not loop.last -%}
        ,
        {%- endif -%}
        {%- endfor %}
    FROM orders
    GROUP BY 1)

SELECT 
        customer_id,
        num_orders,
        num_completed_orders,
        num_pending_orders,
        num_closed_orders,
        num_suspected_fraud_orders,
        {{dbt.current_timestamp()}} AS etl_load_timestamp
FROM customer_orders
