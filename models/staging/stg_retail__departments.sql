WITH departments AS
    (SELECT * 
    FROM {{source('public','departments')}})

SELECT * 
FROM departments