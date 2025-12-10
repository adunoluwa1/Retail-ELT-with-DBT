WITH customers AS
(SELECT * 
FROM {{source('public','customers')}})

SELECT 
customer_id,
customer_fname AS first_name,
customer_lname AS last_name,
customer_email AS email,
-- customer_password AS password,
customer_street AS street,
customer_city AS city,
customer_state AS state,
customer_zipcode AS zipcode
FROM customers