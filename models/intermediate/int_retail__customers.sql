WITH customers AS (
    SELECT * FROM {{ref('stg_retail__customers')}}
)

SELECT
    customer_id,
    {{- initcap_and_coalesce("first_name",'') -}} AS first_name,
    {{- initcap_and_coalesce("last_name",'') -}} AS last_name,
    CONCAT(
        {{- initcap_and_coalesce("first_name",'') -}},' ',
        {{- initcap_and_coalesce("last_name",'') -}}) AS full_name,
    COALESCE("street",'UNKNOWN') AS street,
    {{- initcap_and_coalesce("city",'UNKNOWN') -}} AS city,
    COALESCE(UPPER("state"),'') AS state,
    zipcode,
    {{ dbt.current_timestamp() }} etl_load_timestamp
FROM customers