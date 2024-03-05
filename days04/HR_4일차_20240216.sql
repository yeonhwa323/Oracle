-- HR 
SELECT *
FROM tabs;

-- ORA-00942: table or view does not exist [HR은 emp테이블 소유X]
SELECT *
FROM scott.emp;
-- ORA-00942: table or view does not exist
SELECT *
FROM arirang;

SELECT * 
FROM employees
WHERE salary = ANY
                (SELECT salary 
                FROM employees
                WHERE department_id = 30);
