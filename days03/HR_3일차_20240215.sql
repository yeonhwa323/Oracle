-- HR 
SELECT last_name, salary
FROM employees
WHERE last_name LIKE 'R%' -- last_name�� R�� �����ϴ� �̸��� ������
ORDER BY salary;

SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R___'  -- �� underscore(_)�� 3����
                             --> R�� �����ϴ� 4 �����̸�
ORDER BY salary;


