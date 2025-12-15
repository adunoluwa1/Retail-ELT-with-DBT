{{ config(materialized='table') }}

WITH sales AS(
    SELECT * FROM {{ref('int_fact_sales')}}
),
daily_sales AS (
    SELECT
    order_timestamp :: DATE order_date,
    SUM(total_revenue) daily_revenue,
    COUNT(DISTINCT order_id) daily_total_orders,
    SUM(quantity) daily_units_sold
    FROM sales
    WHERE order_status = 'COMPLETED'
    GROUP BY 1
),
daily_sales_aov AS (
    SELECT *,
    ROUND(daily_revenue/daily_total_orders::NUMERIC, 2) daily_avg_order_value
    FROM daily_sales
),
rolling_aov AS (
    SELECT *,
    AVG(daily_avg_order_value) OVER(
        ORDER BY order_date
        RANGE BETWEEN INTERVAL '6 DAYS' PRECEDING AND CURRENT ROW) AS rolling_7_days,
    AVG(daily_avg_order_value) OVER(
        ORDER BY order_date
        RANGE BETWEEN INTERVAL '29 DAYS' PRECEDING AND CURRENT ROW) AS rolling_30_days
    FROM daily_sales_aov
),
daily_metrics AS (
    SELECT
    order_date,
    daily_revenue,
    daily_total_orders,
    daily_units_sold,
    daily_avg_order_value,
    ROUND(rolling_7_days,2) AS rolling_7_days,
    ROUND(rolling_30_days,2) AS rolling_30_days,
    {{dbt.current_timestamp()}} AS etl_load_timestamp
    FROM rolling_aov
)

SELECT *
FROM daily_metrics