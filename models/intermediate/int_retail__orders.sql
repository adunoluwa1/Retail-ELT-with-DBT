WITH orders AS (
    SELECT * 
    FROM {{ref('stg_retail__orders')}}
)

SELECT
    order_id,
    customer_id,
    CASE 
        WHEN order_status = 'COMPLETE' THEN 'COMPLETED'
        WHEN order_status = 'SUSPECTED_FRAUD' THEN 'SUSPECTED_FRAUD'
        WHEN order_status IN ('CLOSED','CANCELED') THEN 'CLOSED' ELSE 'PENDING'
        END AS order_status,
    order_date AS order_timestamp,
    order_date::date AS order_date,
    DATE_PART('YEAR',order_date) AS order_year,
    INITCAP(TO_CHAR(order_date, 'Month')) AS order_month_name,
    EXTRACT('MONTH' FROM order_date) AS order_month_num,
    EXTRACT('WEEK' FROM order_date) AS order_week_of_year,
    EXTRACT('DAY' FROM order_date) AS order_day_of_month,
    INITCAP(TO_CHAR(order_date, 'day')) AS order_day_name,
    EXTRACT('DOW' FROM order_date) AS order_day_of_week_num,
    {{ dbt.current_timestamp() }} etl_load_timestamp
FROM orders