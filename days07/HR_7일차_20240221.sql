-- HR 
SELECT *
FROM tabs;

-- [24.02.21 과제]
-- [1. 데이터검색: SELECT ]
-- [문제1]
SELECT first_name || last_name "name"
    , job_id "job"
    , (salary *12 ) +100 "Increased Ann_Salary"
    , (salary + 100) * 12 " Increased Salary"    
FROM employees;
-- [문제2]
SELECT
    last_name||':'|| '1 Year Salary = $' || salary*12 "1 Year Salary = $"
FROM employees;
-- [문제3]
SELECT DISTINCT department_id, job_id
FROM employees;
-- [2. WHERE, ORDER BY ]
-- [문제1]
SELECT last_name "e or o Name"
FROM Employees
WHERE last_name LIKE '%e%' AND last_name LIKE '%o%' ;
-- [문제2]
SELECT DISTINCT SYSDATE
FROM employees;

SELECT first_name||last_name name
    , job_id
    , hire_date
FROM employees
WHERE hire_date BETWEEN '06/05/20' AND '07/05/20'
ORDER BY hire_date;
-- [문제3]
SELECT first_name||last_name name
    , salary
    , job_id
    , commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC;
-- [3. 단일행/변환함수 ]
-- [문제1]
SELECT first_name ||' '|| last_name || 'is a ' || UPPER(job_id) "Employee JOBs."
FROM employees;
-- [문제2]
SELECT first_name||' '||last_name name
    , salary
    , (salary + NVL(commission_pct,0))*12 "Annual Salary"
    , NVL2(commission_pct, TO_CHAR(commission_pct), 'Salary only') "Commission ?"
FROM employees;
-- [문제3]
SELECT first_name||' '||last_name name
    , hire_date
    , TO_CHAR(hire_date, 'day') "Day of the week"
FROM employees
ORDER BY  TO_CHAR(hire_date, 'day');
-- [4. 집계 함수 ]
-- [문제1]
SELECT department_id
    , TO_CHAR(SUM( salary ), '$999,999.00') "Sum Salary"
    , TO_CHAR(AVG( salary ), '$999,999.00') "Avg Salary"
    , TO_CHAR(MAX( salary ), '$999,999.00') "Max Salary"
    , TO_CHAR(MIN( salary ), '$999,999.00') "Min Salary"
FROM employees
GROUP BY department_id
ORDER BY department_id;
-- [문제2]
SELECT *
FROM (
    SELECT job_id, AVG( salary ) "Avg Salary"
    FROM employees
    WHERE job_id NOT LIKE '%CLERK'
    GROUP BY  job_id
)
WHERE "Avg Salary" > 10000
ORDER BY "Avg Salary" DESC;
-- [5. JOIN ]
SELECT count(*)
FROM departments
GROUP BY department_id;

SELECT department_id , count(*)
FROM empemployees
GROUP BY department_id;


DESC departments; -- department_name , department_id
DESC employees; -- department_id

