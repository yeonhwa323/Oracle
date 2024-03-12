-- SCOTT-2
-- scott 과 다른 사용자환경을 가짐
SELECT USERENV('SESSIONID')
FROM dual;
--
SELECT *
FROM emp
WHERE ename = 'MILLER' ;
-- sal 1300 -> 13000
UPDATE emp
SET sal = 13000
WHERE ename = 'MILLER' ;
--
ROLLBACK;



