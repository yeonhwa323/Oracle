-- SCOTT
SELECT *
FROM tabs;

-- ���� ���� !
-- [����] insa ���̺��� �� ������� �����̸� ����ؼ� ���...
-- 1) ������ = ���س⵵-���ϳ⵵     (������������ ���� X -1)
--     ��. ���� �������� ����
--     ��. 981223-1XXXXXX
--               12 1900 / 34 2000 / 89  1800
-- ����Ŭ ���̸� ��ȯ�ϴ� �Լ��� ���� �� �� �Ʒ� �ڵ� ���...(�ϱ�!!!)
-- 10�� Ǯ���
SELECT name
    , SUBSTR(ssn,1,8)
    , TO_DATE(SYSDATE)
    , TO_DATE ( substr(ssn,1,6), 'YYMMDD')
    , TO_DATE(SYSDATE) - TO_DATE ( substr(ssn,1,6), 'YYMMDD')
FROM insa;
--
-- [���� ����]
SELECT t.name, t.ssn
    , ���س⵵-���ϳ⵵ + CASE S
                            WHEN 1 THEN -1
                            ELSE 0
                        END ������
FROM(
        SELECT name, ssn
            , TO_CHAR(SYSDATE, 'YYYY') ���س⵵
         --   , SUBSTR(ssn, 8, 1) ����
         --   , SUBSTR(ssn, 1, 2) ���ϳ⵵
            , CASE
                WHEN SUBSTR(ssn, 8, 1) IN (1,2,5,6) THEN 1900
                WHEN SUBSTR(ssn, 8, 1) IN (3,4,7,8) THEN 2000
                ELSE 1800
              END + SUBSTR(ssn, 1, 2) ���ϳ⵵
              , SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE)) S -- ������,���û���,������     1,0,-1 SIGN()
        FROM insa
    ) t;
-- �ڹ�       ������ ����    0.0 <= double  Math.random() < 1.0 , Random��
-- ����Ŭ     dbms_random ��Ű��     !=     �ڹ� ��Ű�� java.io
--           ���� ���� PL/SQL(���ν���,�Լ�) �� ����     ���� ���õ� Ŭ�������� ����

SELECT 
    --SYS.dbms_random.value -- 0.0 <=  < 1.0
    --SYS.dbms_random.value(0,100) -- 0.0<=  < 100.0    
    --SYS.dbms_random.string('U', 5) -- Upper(�빮��)
    --SYS.dbms_random.string('X', 5) -- Upper(�빮��) + ���� 
    SYS.dbms_random.string('P', 5)   -- Upper(�빮��)+Ư������+����

    --SYS.dbms_random.string('L', 5) -- Lower(�ҹ���)   
    --SYS.dbms_random.string('A', 5) -- ���ĺ�  
FROM dual;

--[����] ������ �������� 1���� �߻����Ѽ� ����ϼ���.(0~100 ����)
SELECT SYS.dbms_random.value(0,100) �������� -- 0.0<= �Ǽ� < 100
    , CEIL(SYS.dbms_random.value(0,100))
    , ROUND(SYS.dbms_random.value(0,100))
    , TRUNC(SYS.dbms_random.value(0,101))  -- 0.0<= �Ǽ� < 101.0
    
    , ROUND(SYS.dbms_random.value(0,44)) +1
    , ROUND(SYS.dbms_random.value(1,45)) 
FROM dual;
--[����] ������ �ζǹ�ȣ 1���� �߻����Ѽ� ����ϼ���.(0~45 ����)
SELECT 
    TRUNC(SYS.dbms_random.value(0,45)) �ζǹ�ȣ
FROM dual;

-- [ �Ǻ�(pivot) ���� ] (�ϱ�)
-- https://blog.naver.com/gurrms95/222697767118
-- pivot ������ �ǹ� : ���� �߽����� ȸ����Ű��.
--      �� ����� ����/���� - �ǹ� ���
-- ����->����:�Ǻ� / ����->����:���Ǻ�
-- ����
--SELECT * 
--FROM (�ǹ� ��� ������ 1)
--PIVOT (�׷��Լ�(�����÷�) FOR �ǹ��÷� IN(�ǹ��÷� �� AS ��Ī...))
--[��ó] [Oracle] ����Ŭ PIVOT(�ǹ�)�Լ�|�ۼ��� ����
-- �ǽ� 1)
SELECT empno, ename
    , job
FROM emp;
-- �� job���� ������� �� ������ ��ȸ.
SELECT job, COUNT(*) CNT
FROM emp
GROUP BY ROLLUP(job);
-- 1) �Ǻ� ��� ������
SELECT DISTINCT job
FROM emp;
-- �Ǻ� �Լ�����ؼ� ó��.
SELECT *
FROM (
    SELECT job
    FROM emp
    )
PIVOT( COUNT(job) FOR job IN ('CLERK', 'SALESMAN','PRESIDENT','MANAGER','ANALYST') );

SELECT
     COUNT(DECODE( job, 'CLERK', 'O')) CLERK
    , COUNT(DECODE( job, 'SALESMAN', 'O')) SALESMAN
    , COUNT(DECODE( job, 'PRESIDENT', 'O')) PRESIDENT
    , COUNT(DECODE( job, 'MANAGER', 'O')) MANAGER
    , COUNT(DECODE( job, 'ANALYST', 'O')) ANALYST
FROM emp;
-- �ǽ� 2) ���� �Ի��� ����� ���� �ľ�
SELECT hiredate
    , TO_CHAR(hiredate, 'MM')
FROM emp;
--1�� 2�� 3�� ... 12��
--2   0   4       3
SELECT *
FROM (
    SELECT 
        TO_CHAR(hiredate, 'YYYY') year
        , TO_CHAR(hiredate, 'MM') month
    FROM emp
    )
PIVOT( COUNT(month) FOR month IN ('01' AS "1��", '02' AS "2��",'03','04','05','06', '07','08','09','10','11','12') );
    
SELECT  TO_CHAR(hiredate, 'MM') month
         , TO_CHAR(hiredate, 'FFMM')||'��' month
         , EXTRACT(MONTH FROM hiredate ) month
FROM emp;
-- �ǽ� 3) �⵵�� ���� �Ի��� ����� ���� �ľ�

-- ����) emp ���̺��� �� �μ���, job�� ������� ��ȸ
SELECT *
FROM (
    SELECT d.deptno
        , dname
        , job
    FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
    )
PIVOT( COUNT(job) FOR job IN ('CLERK', 'SALESMAN','PRESIDENT','MANAGER','ANALYST') )
ORDER BY deptno ASC;
-- �ǽ�)
SELECT job, deptno, sal
FROM emp;
--
SELECT *
FROM(
    SELECT job, deptno, sal
    FROM emp
    )
PIVOT ( SUM(sal) FOR deptno IN ('10', '20', '30') );
--
SELECT *
FROM(
    SELECT job, deptno, sal, ename
    FROM emp
    )
PIVOT ( SUM(sal) AS �հ�, MAX(sal) AS �ְ��, MAX(ename) AS �ְ��� FOR deptno IN ('10', '20', '30') );

-- RIGHT OUTER JOIN
SELECT d.deptno
        , dname
        , job
FROM emp e, dept d
WHERE e.deptno(+)= d.deptno; -- RIGHT OUTER
WHERE e.deptno= d.deptno(+); -- LEFT OUTER
--FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno;
--FROM emp e LEFT OUTER JOIN dept d ON e.deptno = d.deptno;

-- [����] emp ���̺��� sal�� ���� 20%�� �ش�Ǵ� ����� ������ ��ȸ...
SELECT *
FROM(
    SELECT 
    RANK() OVER(ORDER BY sal DESC) sal_rank
    , deptno,ename, sal 
    FROM emp
    )
WHERE sal_rank <= (SELECT COUNT(*) FROM emp)*0.2 ;

-- [����] emp ���� �� ����� �޿��� ��ü�޿��� �� %�� �Ǵ� �� ��ȸ.
       ( %   �Ҽ��� 3�ڸ����� �ݿø��ϼ��� )
            ������ �Ҽ��� 2�ڸ������� ���.. 7.00%,  3.50%  
SELECT t.ename, t.pay, t.totalpay
    , TO_CHAR(ROUND(t.pay/t.totalpay*100, 2), '999.00') ����
FROM(
        SELECT  ename
            , sal+NVL(comm,0) pay
            , ( SELECT SUM(sal+NVL(comm,0)) FROM emp)  TOTALPAY
         FROM emp 
    ) t ;
ENAME             PAY   TOTALPAY ����     
---------- ---------- ---------- -------
SMITH             800      27125   2.95%
ALLEN            1900      27125   7.00%
WARD             1750      27125   6.45%
JONES            2975      27125  10.97%
MARTIN           2650      27125   9.77%
BLAKE            2850      27125  10.51%
CLARK            2450      27125   9.03%
KING             5000      27125  18.43%
TURNER           1500      27125   5.53%
JAMES             950      27125   3.50%
FORD             3000      27125  11.06%
MILLER           1300      27125   4.79%
12�� ���� ���õǾ����ϴ�.    

--[����] insa ���̺�
-- [��]
SELECT 
    COUNT(*) �ѻ����
    , COUNT(DECODE( MOD(SUBSTR(ssn,8,1),2), 1,'����' )) ���ڻ����
    , COUNT(DECODE( MOD(SUBSTR(ssn,8,1),2), 0,'����' )) ���ڻ����
    , SUM(DECODE( MOD(SUBSTR(ssn,8,1),2), 1, basicpay )) "��������� �ѱ޿���"
    , SUM(DECODE( MOD(SUBSTR(ssn,8,1),2), 0, basicpay )) "��������� �ѱ޿���"
    , MAX(DECODE( MOD(SUBSTR(ssn,8,1),2), 1, basicpay )) "����-max(�޿�)"
    , MAX(DECODE( MOD(SUBSTR(ssn,8,1),2), 0, basicpay )) "����-max(�޿�)"
FROM insa;
-- [��]
SELECT 
    DECODE( MOD(SUBSTR(ssn,8,1),2), 1,'����',0,'����', '��ü')|| '�����'
    , COUNT(*) �����
    , SUM (basicpay) �޿���
    , MAX (basicpay) �ְ�޿���
FROM  insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2));

-- [����] ����(RANK) �Լ� ����ؼ� Ǯ�� 
--   emp ���� �� �μ��� �ְ�޿��� �޴� ����� ���� ���
-- [��. rank �Լ� ����]
SELECT t.deptno, e.ename, t.max_pay, 1 DEPTNO_RANK
FROM (
        SELECT deptno, MAX( sal+NVL(comm,0)) max_pay
        FROM emp
        GROUP BY deptno
    ) t , emp e 
WHERE t.deptno = e.deptno AND t.max_pay = (e.sal+NVL(comm,0))
ORDER BY deptno;
-- [��. rank �Լ� ���]
SELECT deptno, ename, pay, deptno_pay_rank
FROM(
    SELECT deptno, ename
    , sal+NVL(comm,0) pay
    , RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) pay_rank
    , RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) deptno_pay_rank
    FROM emp
    ) t
WHERE deptno_pay_rank = 1
ORDER BY deptno;   

    DEPTNO ENAME             PAY DEPTNO_RANK
---------- ---------- ---------- -----------
        10 KING             5000           1
        20 FORD             3000           1
        30 BLAKE            2850           1

-- [����] emp ���̺���
-- �� �μ��� �����, �μ� �ѱ޿���, �μ� ��ձ޿�

SELECT d.deptno
    , COUNT(empno) �μ�����
    , NVL(SUM(sal+NVL(comm,0)),0) �ѱ޿���
    , NVL(ROUND(AVG(sal+NVL(comm,0)),2),0) ���
--FROM emp e , dept d
--WHERE e.deptno (+)= d.deptno
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
ORDER BY d.deptno ASC;

-- [����] insa ���̺��� �� �μ��� / ��������� / ����� �� ������ ���(��ȸ)
-- (����) ��������� ����� �������� �ʾƵ� ��� ��������� ������� ��� )
-- ( PARTITION OUTER JOIN ���� ��� )
WITH c AS (
    SELECT DISTINCT city
    FROM insa
)
SELECT buseo, c.city, COUNT(num)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN c ON i.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;

--
SELECT DISTINCT city
FROM insa
ORDER BY city ASC;
--����
--���
--�泲
--���
--�λ�
--����
--��õ
--����
--����
--����
--�泲

-- [����]
 insa ���̺��� 
[������]
                                           �μ������/��ü����� == ��/�� ����
                                           �μ��� �ش缺�������/��ü����� == �μ�/��%
                                           �μ��� �ش缺�������/�μ������ == ��/��%
                                           
�μ���     �ѻ���� �μ������ ����  ���������  ��/��%   �μ�/��%   ��/��%
���ߺ�       60       14         F       8       23.3%     13.3%       57.1%
���ߺ�       60       14         M       6       23.3%     10%       42.9%
��ȹ��       60       7         F       3       11.7%       5%       42.9%
��ȹ��       60       7         M       4       11.7%   6.7%       57.1%
������       60       16         F       8       26.7%   13.3%       50%
������       60       16         M       8       26.7%   13.3%       50%
�λ��       60       4         M       4       6.7%   6.7%       100%
�����       60       6         F       4       10%       6.7%       66.7%
�����       60       6         M       2       10%       3.3%       33.3%
�ѹ���       60       7         F       3       11.7%   5%           42.9%
�ѹ���       60       7         M    4       11.7%   6.7%       57.1%
ȫ����       60       6         F       3       10%       5%           50%
ȫ����       60       6         M       3       10%       5%           50%    
--
SELECT
    s.*
    , ROUND(�μ������/�ѻ����*100,2) || '%' "��/��%"
    , ROUND(���������/�ѻ����*100,2) || '%' "�μ�/��%"
    , ROUND(���������/�μ������*100,2) || '%' "��/��%"

FROM (
        SELECT buseo
            , ( SELECT COUNT(*) FROM insa ) �ѻ����
            , ( SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) �μ������
            , gender  ����
            , COUNT(*) ���������
        FROM (
                SELECT buseo, name, ssn
                    , DECODE( MOD(SUBSTR(ssn, 8, 1),2), 1, 'M', 'F' ) gender
                FROM insa
            ) t
        GROUP BY buseo, gender
        ORDER BY buseo, gender
    ) s ;

-- [����] SMS ������ȣ ������ 6�ڸ� ���� �߻�
SELECT SYS.dbms_random.value
    , TRUNC(SYS.dbms_random.value(100000, 1000000)) SMS6�ڸ�
    , TO_CHAR(TRUNC(SYS.dbms_random.value(10000, 1000000)), '099999') SMS6�ڸ�
FROM dual;

SELECT deptno
    , TO_CHAR( deptno, '0999')
FROM dept;

-- [����] LISTAGG �Լ� ( �ϱ� )
-- https://blog.naver.com/doittall/223307658631
SELECT deptno, job
    , NVL(LISTAGG( ename, '/' ) WITHIN GROUP( ORDER BY ename), '�������' ) ��� ���
FROM emp
ORDER BY deptno, job;

--  LISTAGG �Լ� ����
SELECT LISTAGG(ename, '/') WITHIN GROUP (ORDER BY ename ASC) 
FROM emp ;
-- 
SELECT
    d.deptno
    , NVL(LISTAGG(ename, '/') WITHIN GROUP (ORDER BY ename ASC), '�������') enames
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno=d.deptno
GROUP BY d.deptno;

-- [����] emp ���̺��� 30�� �μ��� �ְ�, ���� sal�� �޴� ����� ���� ��ȸ
SELECT MAX(sal), MIN(sal) -- 2850	950
FROM emp
WHERE deptno = 30;
 ����� �÷� : deptno, ename, hiredate, sal
--   ��. 
SELECT deptno
    , ename
    , hiredate
    , sal
    , 'MAX'
FROM emp
WHERE sal = (SELECT MAX(sal)
             FROM emp
             WHERE deptno = 30) and deptno = 30
UNION
SELECT deptno
    , ename
    , hiredate
    , sal    
    , 'MIN'
FROM emp
WHERE sal = (SELECT MIN(sal)
             FROM emp
             WHERE deptno = 30) and deptno = 30;
-- ��.
  select deptno, ename, hiredate , sal
  from  emp s 
  where   s.sal = ( select max(sal)    from emp     where deptno = 30)
         or s.sal = ( select min(sal)    from emp     where deptno = 30)
         and deptno = 30; 
-- ��.  
SELECT deptno,ename,hiredate,sal
FROM emp e
WHERE sal IN (
             (SELECT  MAX(sal)    FROM emp    WHERE deptno = 30)
            ,(SELECT  MIN(sal)    FROM emp    WHERE deptno = 30 )
            )  
     AND deptno = 30;
-- ��.  
SELECT deptno, ename, hiredate, sal
FROM (
    SELECT deptno, ename, hiredate, sal,
           RANK() OVER (PARTITION BY deptno ORDER BY sal ASC) AS srtop,
           RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS srlow
    FROM emp
    WHERE deptno = 30
) r
WHERE srtop = 1 OR srlow = 1;  
-- ��.
SELECT b.*

-- [����������] emp ���̺���
--             ������� ���� ���� �μ���� �����
--             ������� ���� ���� �μ���� �����
--             ���
-- 1) UNION X
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;
-- 2) 
SELECT t.deptno, cnt
FROM (
        SELECT d.deptno, COUNT(empno) cnt
            , RANK() OVER(ORDER BY COUNT(empno) ASC) cnt_rank
        FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
        GROUP BY d.deptno
) t
WHERE t.cnt_rank IN (1, (SELECT COUNT(*) FROM dept) );
-- RANK �����Լ� ��� x 
-- MAX(cnt) , MIN(cnt) o
-- ��.
WITH t AS(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
)
SELECT dname, cnt
FROM t
WHERE cnt IN ((SELECT MAX(cnt) FROM t), (SELECT MIN(cnt) FROM t));
-- ��. WITH �� �����ϰ� �ϱ�
WITH a AS (
        SELECT d.deptno, dname , COUNT(empno) cnt
        FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
        GROUP BY d.deptno, dname
    )
    , b AS (
        SELECT MIN(cnt) mincnt, MAX(cnt) maxcnt
        FROM a
    )
SELECT a.dname, a.cnt
FROM a, b 
WHERE a.cnt IN (b.mincnt, b.maxcnt);

-- ��. �м��Լ� : FIRST, LAST
--              ? �����Լ�( COUNT, SUM, AVG, MAX, MIN )�� ���� ����Ͽ�
--                �־��� �׷쿡 ���� ���������� ������ �Ű� ����� �����ϴ� �Լ�.
WITH a AS (
        SELECT d.deptno, dname , COUNT(empno) cnt
        FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
        GROUP BY d.deptno, dname
    )
SELECT MAX(cnt)
    , MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt ASC) max_dname --MAX(deptno)�� ����
    , MIN(cnt)
    , MIN(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt ASC) min_dname    
FROM a;

-- �м��Լ� �߿� CUME_DIST() : �־��� �׷쿡 ���� ������� ���� ������ ���� ��ȯ
                    -- ��������(����)  0 <   <= 1
SELECT deptno, ename, sal
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal ASC) �μ�������������dept_dist
    , CUME_DIST() OVER( ORDER BY sal ASC) ��ü����������dept_dist
FROM emp;

-- �м��Լ� �߿� PERCENT_RANK() : �ش� �׷� ���� ����� ����
--                  0 < ������ �� <= 1
--  ����� ���� ? �׷� �ȿ��� �ش� ���� ������ ���� ���� ����
SELECT deptno, ename, sal
--    , PERCENT_RANK() OVER(ORDER BY sal ) PERCENT
    , PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal ) PERCENT
FROM emp;

-- NTILE() NŸ�� : ��Ƽ�� ���� expr�� ��õ� ��ŭ ������ ����� ��ȯ�ϴ� �Լ� 
-- �����ϴ� ���� ��Ŷ(bucket)�̶�� �Ѵ�.
-- ex) NTILE(4) = 4 ��Ŷ���� ������ ��´�.
SELECT deptno, ename, sal
    ,NTILE(4) OVER(ORDER BY sal) ntiles
FROM emp;

SELECT buseo, name, basicpay
    , NTILE(2) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;

-- WIDTH_BUCKET(exr, minvalue, maxvalue, numbucket) == NTILE() �Լ��� ������ �м��Լ�, ������( �ּҰ�, �ִ밪 ���� ���� )
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal ) ntiles
    , WIDTH_BUCKET(sal, 0, 5000, 4) widthbuckets
FROM emp;
--   �ʼ�(�÷���)    ������ ���� ��ġ    ���� ���� �� �⺻��
--  LAG( expr,      offset,           default_value )
-- ? �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�, ��(���� ��)
-- LEAD( expr, offset, default_value )
-- ? �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�, ��(���� ��)
SELECT ename, hiredate, sal
    , LAG( sal, 1, 0 ) OVER(ORDER BY hiredate) pre_sal
  --  , LAG( sal, 2, -1 ) OVER(ORDER BY hiredate) pre_sal
    , LEAD( sal, 1, -1 ) OVER( ORDER BY hiredate) next_sal --PARTITION BY ��밡��
FROM emp
WHERE deptno = 30;

-------------------------------------------------------------------------------
-- [����Ŭ �ڷ���( Data Type ) ]--
-- 1) ����(��) �����ϴ� �ڷ��� CHAR[(size[BYTE ? CHAR])]
    ����)
    CHAR[(SIZE BYTE|CHAR)]
    ��)
    CHAR(3 CHAR) ? 3���ڸ� �����ϴ� �ڷ���, 'abc', '�ѱۼ�'
    CHAR(3 BYTE) ? 3����Ʈ�� ���ڸ� �����ϴ� �ڷ��� 'abc', '��'
    CHAR(3) == CHAR(3 BYTE) 
    CHAR == CHAR(1) == CHAR(1 BYTE)
    '���� ������ ���� �ڷ���' �϶� ���*****
    1����Ʈ~ 2000����Ʈ ���尡��
    
    CHAR(14)==CHAR(14 BYTE) ['A']['B']['C'][][][][][][][][][][][] 14����Ʈ
    ��) �ֹε�Ϲ�ȣ(14�ڸ�) �����ȣ(7�ڸ�) - ���ڿ��� ���̰� ������ �ִ� ���� ������ ��
    
    -- DDL
    CREATE TABLE tbl_char
    (
        aa char         --char(1) == char(1 byte)
        , bb char(3)    --char(3 byte)
        , cc char(3 char)
    );
    -- Table TBL_CHAR��(��) �����Ǿ����ϴ�.
 SELECT *
 FROM tabs
 WHERE table_name LIKE '%CHAR%';
 --
 DESC tbl_char;
 -- ���ο� ���ڵ�(��)�� �߰�..
 INSERT INTO tbl_char (aa,bb,cc) VALUES ('a','aaa','aaa');
 -- 1 �� ��(��) ���ԵǾ����ϴ�.
 INSERT INTO tbl_char (aa,bb,cc) VALUES ('a','��','�츮');
 -- 1 �� ��(��) ���ԵǾ����ϴ�.
 -- ORA-12899: value too large for column "SCOTT"."TBL_CHAR"."BB" (actual: 6, maximum: 3)
 INSERT INTO tbl_char (aa,bb,cc) VALUES ('a','�츮','�츮');
 COMMIT; -- Ŀ�� �Ϸ�.
 SELECT VSIZE('��'), VSIZE('a')
 FROM dual;
 --
SELECT *
FROM tbl_char;
-- Table TBL_CHAR��(��) �����Ǿ����ϴ�.
DROP TABLE tbl_char;
--
DESC emp;

-- N == �����ڵ�(unicode)
NCHAR[(size)] == N + CHAR[(SIZE)]

 NCHAR == NCHAR(1)

 CREATE TABLE tbl_nchar
    (
        aa char(3)         --char(1) == char(1 byte)
        , bb char(3 char)    --char(3 byte)
        , cc nchar(3)
    );
-- Table TBL_CHAR��(��) �����Ǿ����ϴ�.
INSERT INTO tbl_nchar (aa,bb,cc) VALUES ('ȫ','�浿','ȫ�浿');
--  ORA-12899: value too large for column "SCOTT"."TBL_NCHAR"."AA" (actual: 9, maximum: 3)
INSERT INTO tbl_nchar (aa,bb,cc) VALUES ('ȫ�浿','ȫ�浿','ȫ�浿');

COMMIT;
--
SELECT *
FROM tbl_nchar;

DROP TABLE tbl_nchar;
-- char / nchar - �������� 2000byte 
-- VARCHAR2(size[BYTE ? CHAR])
 VARCHAR2(SIZE BYTE|CHAR) ��������
 
 char(5 byte)     [a][b][c][][]
 varchar2(5 byte) [a][b][c]
 VALCHAR2 == varchar2(1) == varchar2(1 BYTE) 4000byte
 
 DESC emp;
 -- N+VAR+CHAR2(size)
 NVARCHAR2 == NVARCHAR2(1) == '��' 'a'
 4000 byte
 
-----------------------------------------------------------------






