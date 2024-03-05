-- SCOTT 
SELECT *
FROM tabs;

SELECT SYSDATE, CURRENT_TIMESTAMP
FROM dual;
--[ dual ���� ]
SELECT SYSDATE
FROM dual;

DESC dual; -- DUMMY    VARCHAR2(1) 
-- ���������
SELECT 5+3, 5-3, 5*3, 5/3, MOD(5,3)
-- ORA-01476: divisor is equal to zero [0���� ����������]
SELECT 5/0
SELECT MOD(5,0) -- 5/0
FROM dual;

-- 
SELECT *
FROM emp;
FROM scott.emp;

-- PUBLIC SYNONYM ����
-- ORA-01031: insufficient privileges [ scott�� �������Ѿ��� ]
CREATE PUBLIC SYNONYM arirang
FOR  scott.emp;

--[ YY�� RR�� ������: ]
--  �� RR�� YY�� �Ѵ� �⵵�� ������ ���ڸ��� ����� ������, 
--  �� ���� system���� ����� ��Ÿ������ �ϴ� �⵵�� ���⸦ ���� ���� �� ��µǴ� ���� �ٸ���.
--  �� [RR]��
--      �� �ý��ۻ�(1900���)�� �⵵�� �������� �Ͽ� ���� 50�⵵���� ���� 49������� ���س⵵�� ����� 1850�⵵���� 1949�⵵������ ������ ǥ���ϰ�, 
--  �� �� ������ ���Ƴ� ��� �ٽ� 2100���� �������� ���� 50�⵵���� ���� 49������� ���� ����Ѵ�.
--
--  �� [YY] �� ������ system���� �⵵(2000)�� ������.

SELECT TO_CHAR( SYSDATE, 'CC' ) -- 21����(2024�⵵)
FROM dual;

SELECT
    '05/01/10' -- ��¥,[���ڿ�]
    , TO_CHAR( TO_DATE('05/01/10', 'YY/MM/DD'), 'YYYY' ) a_YY -- 2005
    , TO_CHAR( TO_DATE('05/01/10', 'RR/MM/DD'), 'YYYY' ) b_RR -- 2005
FROM dual;

SELECT
    '97/01/10' -- ��¥,[���ڿ�]
    , TO_CHAR( TO_DATE('97/01/10', 'YY/MM/DD'), 'YYYY' ) a_YY -- 2097
    , TO_CHAR( TO_DATE('97/01/10', 'RR/MM/DD'), 'YYYY' ) b_RR -- 1997
FROM dual;
--
SELECT name, ibsadate
FROM insa;
-- ORDER BY ��
-- 1�������� �μ����� �������� ���Ľ�Ų ��
-- 2�� ���� pay ���� �޴� ��� ������
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
ORDER BY 1 ASC, 3 DESC ;
ORDER BY deptno ASC, pay DESC;

-- 
-- [ ����Ŭ ������(operator) ���� ]
-- 1) �� ������ : WHERE ������ ����,��¥,���� ����, ũ�⸦ ���ϴ� ������(����Ŭ boolean������)
--  = != ^= <> < >= <=
--      �� SQL ������ ANY, SOME, ALL
--       true, false, null
SELECT ename, sal
FROM emp
WHERE sal>=NULL;
WHERE sal<=1250;
WHERE sal<1250;
WHERE sal>=1250;
WHERE sal!=1250;
WHERE sal=1250;

ANY
SOME
ALL
--p226 ���� 4-12
--emp ���̺��� ��ձ޿����� ���� �޴� ������� ������ ��ȸ.
--1. emp ���̺��� ��ձ޿� ? avg() �����Լ�, �׷��Լ�
SELECT AVG( sal+NVL(comm,0)) avg_pay
FROM emp;
-- 2260.416666666666666666666666666666666667
SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= (SELECT AVG( sal+NVL(comm,0)) avg_pay
                          FROM emp);                          
WHERE sal+NVL(comm,0) >= 2260.416666666666666666666666666666666667;

-- [����]�� �μ��� ��� �޿����� ���� �޴� ������� ������ ��ȸ.
SELECT AVG( sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 10; -- 10�� ������� ���:2916.666666666666666666666666666666666667

SELECT AVG( sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 20; -- 20�� ������� ���:2258.333333333333333333333333333333333333

SELECT AVG( sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 30; -- 30�� ������� ���:1933.333333333333333333333333333333333333

SELECT *
FROM emp
WHERE deptno =10 AND sal+NVL(comm,0) >= 2916.666666666666666666666666666666666667 
UNION
SELECT *
FROM emp
WHERE deptno =20 AND sal+NVL(comm,0) >= 2258.333333333333333333333333333333333333 
UNION
SELECT *
FROM emp
WHERE deptno =30 AND sal+NVL(comm,0) >= 1933.333333333333333333333333333333333333 ;
--
����Ŭ �Լ�(function) ����
-- 
����Ŭ �ڷ���(data type) ����

-- 30�� �μ��� �ְ� �޿����� ���� �޴� ������� ������ ��ȸ.
SELECT MAX(sal + NVL(comm,0)) max_pay_30
FROM emp
WHERE deptno = 30;

SELECT *
FROM emp
WHERE sal + NVL(comm,0) > ALL (SELECT sal + NVL(comm,0) max_pay_30
                        FROM emp
                        WHERE deptno = 30);
                        
WHERE sal + NVL(comm,0) > (SELECT MAX(sal + NVL(comm,0)) max_pay_30
                        FROM emp
                        WHERE deptno = 30);

SELECT deptno, ename,empno,job
from emp
WHERE deptno=10 AND job='CLERK';
--
SELECT deptno, ename,empno,job
FROM emp
WHERE deptno=10 OR job='CLERK';
--
SELECT deptno, ename,empno,job
FROM emp
WHERE deptno NOT IN(10,30);

-- P229
WITH temp AS (SELECT sal+NVL(comm,0) pay FROM emp)
SELECT MAX(pay),   MIN(pay),  AVG(pay),  SUM(pay)
FROM temp;
--
SELECT MAX(pay),   MIN(pay),  AVG(pay),  SUM(pay)
FROM (SELECT sal+NVL(comm,0) pay FROM emp);

-- ��� ���� ���� (correlated subquery)
-- [����1] ��� ��ü���� �ְ� �޿��� �޴� ����� ������ ��ȸ(���) �����, �����ȣ, �޿���, �μ���ȣ
SELECT deptno, ename, empno, sal + NVL(comm,0) pay
FROM emp
ORDER BY pay DESC;
--
select max( sal + NVL(comm,0)) max_pay
from emp
where sal + NVL(comm,0) = ( select max( sal + NVL(comm,0)) max_pay
                            from emp);
--
SELECT deptno, ename, empno, sal + NVL(comm,0) pay
FROM emp
WHERE sal + NVL(comm,0) = 5000;

-- [����2]�� �μ��� �ְ� �޿��� �޴� ����� ������ ��ȸ(���)
-- 
SELECT MAX( sal + NVL(comm,0)) max_pay
from emp
WHERE deptno = 30;
-- [��ȣ���� ��������]
SELECT deptno, ename, empno, sal + NVL(comm,0) pay
FROM emp p
WHERE sal + NVL(comm,0) = ( SELECT MAX( sal + NVL(comm,0)) max_pay
                            FROM emp c 
                            WHERE deptno = p.deptno);
-- �� �μ��� ��պ��� ū �μ����� ���� ��ȸ(���)
-- ******* ORA-00937: not a single-group group function [�����Լ��� �Ϲ��Լ��� �Բ� ���X]
SELECT deptno,ename,sal
    ,( SELECT  AVG( sal ) FROM emp WHERE deptno=t1.deptno )
FROM emp t1
WHERE sal > (SELECT avg(sal)
            FROM emp t2
            WHERE t2.deptno=t1.deptno)
ORDER BY deptno ASC;

SELECT deptno, ename, sal
   ,  ( SELECT AVG (sal) FROM emp WHERE deptno=t1.deptno )
FROM emp t1
WHERE sal > ( SELECT AVG(sal) FROM emp t2 WHERE t2.deptno=t1.deptno)
ORDER BY deptno ASC;


-- ����1 ����ǯ
WITH temp
    AS (SELECT ename, empno, sal + NVL(comm,0) pay, deptno
        FROM emp
        WHERE deptno = 10)
SELECT MAX(pay)
FROM temp t;




