{{config(materialized='table')}}


WITH sales AS (
    SELECT * FROM {{ref('int_fact_sales')}}
    WHERE order_status = 'COMPLETED'
    ),
customers AS (
    SELECT * FROM {{ref('dim_customers')}}
    ),
base AS (
    SELECT 
        s.customer_id,
        DATE_TRUNC('MONTH', c.first_order_date) cohort_month,
        DATE_TRUNC('MONTH', s.order_timestamp) activity_month,
        (
            (DATE_PART('YEAR',s.order_timestamp) * 12 + DATE_PART('MONTH',s.order_timestamp)) -
            (DATE_PART('YEAR',c.first_order_date) * 12 + DATE_PART('MONTH',c.first_order_date))
        ) AS month_number
    FROM sales s
    LEFT JOIN customers c 
    USING(customer_id)
    ), 
cohorts AS (
    SELECT 
        cohort_month,
        activity_month,
        month_number,
        COUNT(DISTINCT customer_id) active_customers
    FROM base
    WHERE month_number >= 0
    GROUP BY 1,2,3
    ORDER BY 1,2,3
),
cohort_size AS (
    SELECT 
    cohort_month,
    active_customers AS cohort_customers
    FROM cohorts
    WHERE month_number = 0
)

SELECT 
    c.cohort_month,
    c.activity_month,
    c.month_number,
    c.active_customers,
    ROUND(c.active_customers::NUMERIC/s.cohort_customers,4) retenton_rate,
    {{dbt.current_timestamp()}} etl_load_timestamp
FROM cohorts c
LEFT JOIN cohort_size s
USING(cohort_month)
ORDER BY 1,2,3







-- CREATE EXTENSION IF NOT EXISTS tablefunc;
-- WITH analysis AS (
--     SELECT * FROM CROSSTAB($$
--         WITH sales AS (
--             SELECT * FROM {{ref('int_fact_sales')}}),
--         customers AS (
--             SELECT * FROM {{ref('dim_customers')}}),
--         cohorts AS (
--             SELECT 
--                 s.customer_id,
--                 c.first_order_date,
--                 TO_CHAR(c.first_order_date,'YYYY-MM|Mon YYYY') first_transaction,
--                 s.order_timestamp::DATE AS order_date   
--             FROM sales s
--             LEFT JOIN customers c USING(customer_id)
--             WHERE order_status = 'COMPLETED'
--         ),
--         customers_cohorts AS (
--             SELECT 
--             first_transaction,
--             (
--                 (EXTRACT(YEAR FROM order_date) * 12 + EXTRACT(MONTH FROM order_date)) -
--                 (EXTRACT(YEAR FROM first_order_date) * 12 + EXTRACT(MONTH FROM first_order_date))
--             ) month_diff,
--             COUNT(DISTINCT customer_id) customers
--             FROM cohorts
--             GROUP BY 1,2
--         )

--         SELECT
--             first_transaction :: TEXT,
--             month_diff :: INT,
--             customers :: INT
--         FROM customers_cohorts
--         WHERE month_diff >= 0
--     $$) as ct(
--         first_transaction TEXT,
--         "1" INTEGER,
--         "2" INTEGER,
--         "3" INTEGER,
--         "4" INTEGER,
--         "5" INTEGER,
--         "6" INTEGER,
--         "7" INTEGER,
--         "8" INTEGER,
--         "9" INTEGER,
--         "10" INTEGER,
--         "11" INTEGER,
--         "12" INTEGER

--     ))

-- SELECT 
-- -- split_part(first_transaction,'|',1) first_transaction_idx,
-- split_part(first_transaction,'|',2) first_transaction,
-- "1","2","3","4","5","6","7","8","9","10","11","12"
-- FROM analysis
