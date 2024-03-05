-- HR 
SELECT last_name, salary
FROM employees
WHERE last_name LIKE 'R%' -- last_name이 R로 시작하는 이름만 가져옴
ORDER BY salary;

SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R___'  -- ☜ underscore(_)가 3개임
                             --> R로 시작하는 4 글자이름
ORDER BY salary;


