-- SCOTT-2
-- scott �� �ٸ� �����ȯ���� ����
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



