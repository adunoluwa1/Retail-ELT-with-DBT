WITH categories AS 
(SELECT * 
FROM {{source('public','categories')}})

SELECT 
category_id,
category_department_id AS department_id,
category_name
FROM categories