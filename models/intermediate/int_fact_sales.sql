{{ config(materialized='table') }}

WITH sales_fact AS (
    SELECT 
        oi.order_item_id,
        oi.product_id,
        oi.order_id,
        o.customer_id,
        oi.quantity,
        oi.subtotal AS total_revenue,
        oi.product_price,
        o.order_status,
        o.order_timestamp,
        {{ dbt.current_timestamp() }} etl_load_timestamp
    FROM {{ref('int_retail__order_items')}} oi
    LEFT JOIN {{ref('int_retail__orders')}} o
    USING(order_id))

SELECT *
FROM sales_fact