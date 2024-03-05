-- HR 
SELECT *
FROM tabs;
--
SELECT commission_pct 
FROM employees;
--
SELECT COUNT(*) 
FROM employees 
WHERE commission_pct IS NOT NAN; -- NULL값 제외
--
SELECT count(*) 
FROM employees 
WHERE commission_pct IS NOT NULL;
--
SELECT last_name
FROM employees
WHERE salary IS NOT INFINITE;
-- [문제] employee 테이블에서 salary의 1000단위마다 별 1개씩 출력하는 쿼리 작성.
SELECT last_name
    , salary
    , ROUND(salary/1000)
    , RPAD(' ',ROUND(salary/1000)+1, '*') "Salary"
FROM employees
WHERE department_id = 80
Order By last_name, "Salary";

-- RTRIM() / LTRIM() -공백,특정문자제거 / TRIM() -공백제거
-- 형식) RTRIM(char[, set])
SELECT '    admin   '
    , '[' || '    admin   ' || ']'
    , '[' || RTRIM('    admin   ') || ']'    
    , '[' || LTRIM('    admin   ') || ']'
    , '[' || TRIM('    admin   ') || ']'
FROM dual;

SELECT RTRIM('BROWINGyxXxy', 'xy') a
    , RTRIM('BROWINGyxXxyxyxy', 'xy') b -- 'xy' 모두제거
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
    , EXTRACT(year FROM hire_date) -- 3. 입사년도
FROM employees --  1. 사원 테이블로부터
WHERE EXTRACT(year FROM hire_date ) >1998 -- 2. 1998 이후 년도부터 
ORDER BY hire_date; -- 4. 먼저 입사한 사원부터 오름차순으로 정렬

DESC employees;
-- HIRE_DATE      NOT NULL DATE

-- [변환 함수] 
-- 1) TO_NUMBER() : 문자 -> 숫자로 변환(보통 자동전환이라 거의사용x)
SELECT '12'
    , TO_NUMBER( '12' )
    , 100 - '12'
    ,'100'- '12'
FROM dual;
-- scott 2)~















