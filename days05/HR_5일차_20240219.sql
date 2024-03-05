-- HR 
SELECT *
FROM tabs;
--
SELECT commission_pct 
FROM employees;
--
SELECT COUNT(*) 
FROM employees 
WHERE commission_pct IS NOT NAN; -- NULL�� ����
--
SELECT count(*) 
FROM employees 
WHERE commission_pct IS NOT NULL;
--
SELECT last_name
FROM employees
WHERE salary IS NOT INFINITE;
-- [����] employee ���̺��� salary�� 1000�������� �� 1���� ����ϴ� ���� �ۼ�.
SELECT last_name
    , salary
    , ROUND(salary/1000)
    , RPAD(' ',ROUND(salary/1000)+1, '*') "Salary"
FROM employees
WHERE department_id = 80
Order By last_name, "Salary";

-- RTRIM() / LTRIM() -����,Ư���������� / TRIM() -��������
-- ����) RTRIM(char[, set])
SELECT '    admin   '
    , '[' || '    admin   ' || ']'
    , '[' || RTRIM('    admin   ') || ']'    
    , '[' || LTRIM('    admin   ') || ']'
    , '[' || TRIM('    admin   ') || ']'
FROM dual;

SELECT RTRIM('BROWINGyxXxy', 'xy') a
    , RTRIM('BROWINGyxXxyxyxy', 'xy') b -- 'xy' �������
    , LTRIM('xyBROWINGyxXxyxyxyxyxy', 'xy') c -- ORA-00907: missing right parenthesis
--   x , TRIM('BROWINGyxXxyxyxyxyxy', 'xy') d
    , RTRIM( LTRIM('xyBROWINGyxXxyxyxyxyxy', 'xy'), 'xy' ) e
FROM dual;
--
SELECT *
FROM employees;
--
--ORA-01843: not a valid month
SELECT last_name, employee_id, hire_date
    , EXTRACT(year FROM hire_date) -- 3. �Ի�⵵
FROM employees --  1. ��� ���̺�κ���
WHERE EXTRACT(year FROM hire_date ) >1998 -- 2. 1998 ���� �⵵���� 
ORDER BY hire_date; -- 4. ���� �Ի��� ������� ������������ ����

DESC employees;
-- HIRE_DATE      NOT NULL DATE

-- [��ȯ �Լ�] 
-- 1) TO_NUMBER() : ���� -> ���ڷ� ��ȯ(���� �ڵ���ȯ�̶� ���ǻ��x)
SELECT '12'
    , TO_NUMBER( '12' )
    , 100 - '12'
    ,'100'- '12'
FROM dual;
-- scott 2)~















