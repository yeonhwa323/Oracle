-- SCOTT
SELECT *
FROM tabs;

-- [SET ���� ������]
-- 1) ������( UNION, UNION ALL)
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�' 
--UNION -- 17�� -- 6���� �ߺ��ȴ�. ����1���� ����
UNION ALL -- 23�� -- �ߺ� ����x ������ 
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'; -- 9��

-- 2) ������( MINUS)
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
MINUS
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'; -- 8��

-- 3) ������( INTERSECT)
-- ���ߺ��̸鼭 ��õ�� ������� �ľ�
-- [2] 
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'; 

-- [1]
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�' AND city = '��õ'; -- 6��

-- [SET ���� �����ڸ� ����� �� ������ ��]
-- : Ÿ���� �ڷ���,������ ���ƾ��Ѵ�.
-- ORA-01790: expression must have same datatype as corresponding expression
--            ����                  ������ ������Ÿ��       �ش��
-- ORA-01789: query block has incorrect number of result columns
SELECT name, city, buseo -- 42��, 20������ ���� �߻�
FROM insa
WHERE buseo = '���ߺ�' 
UNION ALL --23��
SELECT name, city --, jikwi --, basicpay
FROM insa
WHERE city = '��õ'; 
-- insa ���̺��� ��� ���� + emp ���̺��� ��� ���� ��� ���.
SELECT buseo, num, name, ibsadate, basicpay, sudang
FROM insa
UNION ALL
SELECT TO_CHAR(deptno), empno, ename, hiredate, sal, comm
FROM emp;
-- [MULTISET ������]
MULTISET EXCEPT
MULTISET INTERSECT
MULTISET UNION
-- [������ ���� ������]
-- PRIOR, CONNECT_BY_ROOT
-- {���� ������ ] ||

-- [��� ������] + - / *
--              ������ ���ϴ� ������ X
--              ������ ���ϴ� �Լ� MOD(5,3) ****    5-3*FLOOR(5/3)
--              ������ ���ϴ� �Լ� REMAINDER(5,3)   5-3*ROUND(5/3) X
SELECT 
    -- 10/0 -- ORA-01476: divisor is equal to zero
    -- 'A' / 2 -- ORA-01722: invalid number
    MOD(10, 0)
FROM dual;

IS [NOT] NAN    Not A Number
IS [NOT] INFINITE ���Ѵ�

-- ����Ŭ �Լ�(function)
-- 1. ������ �������� �����ϰ� ���ְ� �������� ���� �����ϴµ� ���Ǵ� ��.
-- 2. ���� : ������ �Լ�, ������ �Լ�
SELECT LOWER( ename )
FROM emp;

SELECT COUNT(*) --�������Լ�
FROM emp;

-- [���� �Լ�] --
-- 1) ROUND(number) ���ڰ��� Ư�� ��ġ���� �ݿø��Ͽ� �����Ѵ�. 
-- ���� ROUND(number, n)  n = 0, ����, ���
SELECT 3.141592
    , ROUND( 3.141592 ) a -- �Ҽ��� ù ��° �ڸ����� �ݿø�.
    , ROUND( 3.141592, 0 ) b -- n�� ������ ���� ����.
    , ROUND( 3.141592, 2 ) c -- �Ҽ��� �� ��° �ڸ����� �ݿø�...
    , ROUND( 1234.5678, 2 ) d
    , ROUND( 1234.5678, -1 ) e
    , ROUND( 1234.5678, -2 ) f   
    , ROUND( 1234.5678, -3 ) g
FROM dual;

-- [����] emp ���̺��� pay, ��ձ޿�, �ѱ޿���, ����� ���
-- ORA-00937: not a single-group group function
-- �����Լ��� �Ϲ��Լ���� �Բ� ����� �� ����
-- ( ? )GROUP BY �����Լ�, SELECT ���� ����� �������� �Ϲ����� GROUP BY���� �����Լ��� ���� ���� ����.
SELECT emp.*
    , sal + NVL(comm, 0) pay
    --, COUNT(*) -- �����
    , ( SELECT COUNT(*) FROM emp) t_cnt
    -- SUM ( sal+NVL(comm,0) )
    , (SELECT SUM ( sal+NVL(comm,0) FROM emp) total_pay
    --��ձ޿� ����ؼ� �Ҽ��� 2�ڸ����� �������...
    , (SELECT SUM( sal+NVL(comm,0) )/COUNT(*) FROM emp ) avg_pay
    , ROUND(SELECT AVG( sal+NVL(comm,0) FROM emp ),2) avg_pay    
FROM emp;
-- [�����Լ�]
SELECT COUNT(*) -- null ���� ������ ������ ��ȯ
    , COUNT(empno)
    , COUNT(deptno)
    , COUNT(sal)
    , COUNT(hiredate)    
    , COUNT(comm) --4
FROM emp;

-- ��� Ŀ�̼� ?
SELECT AVG(comm) -- 550 -- NULL�������� ��հ�

SELECT SUM(comm)/COUNT(*) -- 183.333333333333333333333333333333333333 -- NULL�� ������ ��հ�
    , SUM(comm)/COUNT(comm) -- 550ll
FROM emp;

-- TRUNC(��¥, ����), FLOOR(����) �����ϴ� 2���� �Լ�.
-- 2���� ������? �� ��° ��������
--             TRUNC() �� Ư�� ��ġ���� ���� ����
--             FLOOR() �� �Ҽ��� ù ��° �ڸ����� ���踸 ����.
SELECT 3.141592
    , TRUNC( 3.141592 ) -- �Ҽ��� ù ��° �ڸ����� ���� ����.
    , TRUNC( 3.141592, 0 ) -- �Ҽ��� ù ��° �ڸ����� ���� ����.
    , FLOOR( 3.141592 )
    
    , TRUNC( 3.141592 , 3) -- Ư�� ��ġ���� ���� ����.
    , FLOOR( 3.141592 ) * 1000 / 1000
    
    , TRUNC( 3.141592 , -1)    
FROM dual; 
-- CEIL() : �Ҽ��� ù°�ڸ����� �ø�(����)�ϴ� �Լ�
SELECT CEIL( 3.14 ), CEIL( 3.54 )
FROM dual;
-- 3.141595 �� �Ҽ��� �� ��° �ڸ����� �ø�����.
SELECT CEIL( 3.141592 *100) /100   -- 3.15
FROM dual;
-- ������������ ����� �� CEIL() �ø�(����)�Լ��� ����Ѵ�.
-- �� �Խñ�(���) �� : 
-- �� �������� ����� �Խñ�(���) �� : 5
SELECT COUNT(*) FROM emp;
SELECT CEIL( ( SELECT COUNT(*) FROM emp ) /5 ) --����������
FROM dual;
--
SELECT *
FROM emp
ORDER BY sal+NVL(comm,0) DESC;
-- [1] 2 3
7839	KING	PRESIDENT		81/11/17	5000		10
7902	FORD	ANALYST	7566	81/12/03	3000		20
7566	JONES	MANAGER	7839	81/04/02	2975		20
7698	BLAKE	MANAGER	7839	81/05/01	2850		30
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
-- 1 [2] 3
7782	CLARK	MANAGER	7839	81/06/09	2450		10
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	30
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	30
7934	MILLER	CLERK	7782	82/01/23	1300		10
-- 1 2 [3]
7900	JAMES	CLERK	7698	81/12/03	950		30
7369	SMITH	CLERK	7902	80/12/17	800		20
-- ABS() : ���� ���ϴ� �Լ�
SELECT ABS(100), ABS(-100)
FROM dual;
-- SIGN() :  ���ڰ��� ��ȣ�� ���� 1, 0, -1�� ������ �����Ѵ�. 
SELECT SIGN(100), SIGN(0), SIGN(-100)
FROM dual;

-- [����] emp ���̺��� ��ձ޿��� ���ؼ�
-- �� ����� �޿�(pay)�� ��ձ޿����� ������ "��ձ޿����� ����"��� ����ϰ�
--                                ������ "��ձ޿����� ����"��� ���.
-- 2260.416666666666666666666666666666666667
-- [��� �޿�]
SELECT AVG ( sal+NVL(comm,0) )
FROM emp;
-- [1]
SELECT p.*--, '����'     
FROM emp p 
WHERE sal+NVL(comm,0) > (SELECT AVG ( sal+NVL(comm,0) )avg_pay FROM emp) 
UNION ALL
SELECT p.*, '����'     
FROM emp p 
WHERE sal+NVL(comm,0) < (SELECT AVG ( sal+NVL(comm,0) )avg_pay FROM emp) ;
-- [2]
SELECT ename, sal+NVL(comm,0) pay 
    , (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) avg_pay
    , SIGN( sal+NVL(comm,0) - (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) ) s 
    , REPLACE(   REPLACE( SIGN( sal+NVL(comm,0) - (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) ), -1, '����'), 1, '����')  ��
FROM emp
ORDER BY s;
-- [3]
SELECT ename, pay, avg_pay
    , NVL2( NULLIF( SIGN( pay - avg_pay ), 1 ), '����', '����')
FROM (
        SELECT  ename, sal+NVL(comm,0) pay 
            , (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) avg_pay
        FROM emp
     );

     
-- POWER(), SQRT()
SELECT power(2,3), power(2,-3)
    , SQRT(2)
FROM dual;
 
-- [���� �Լ�] --
-- INSTR() == JAVA indexOf(), lastIndexOf() ���
SELECT instr('Corea','e') -- 4
From dual;

SELECT 
    instr('corporate floor','or') -- 2 ��° �ڸ� ��ġ(2)
    , instr('corporate floor','or',3,2) -- 3��°�ڸ����ͽ����ؼ� 14��°�ڸ� ��ġ(14)
    , instr('corporate floor','or',-3,2) -- �ڿ���3��°�ڸ����� 2��°(2)
FROM dual;

SELECT '010-1234-5678' hp
    , SUBSTR('02-1234-5678', 1,3) a --010
    , SUBSTR('02-1234-5678', 5,4) b --1234
    , SUBSTR('02-1234-5678', 10,4) c --5678
FROM dual;

SELECT '02-1234-5678' tel
    , INSTR('02-1234-5678', '-') "ù��° - ��ġ" -- 3
    , INSTR('02-1234-5678', '-', -1) "�ι�° - ��ġ" -- 8
    , SUBSTR('02-1234-5678', 1, INSTR('02-1234-5678', '-')-1) a --02
    , SUBSTR('02-1234-5678', INSTR('02-1234-5678', '-')+1) -- 1234-5678
        , INSTR('02-1234-5678', '-',-1)-1-(INSTR('02-1234-5678', '-')+1) --3
    , SUBSTR('02-1234-5678', INSTR('02-1234-5678', '-',-1)+1,4) --5678
FROM dual;
--
DESC tbl_tel;
--
SELECT *
FROM tbl_tel;
--
INSERT INTO tbl_tel (tel,name) VALUES ('063)456-4567', 'ū����');
INSERT INTO tbl_tel (tel,name) VALUES ('052)1456-2367', '��°����');
COMMIT;
-- ������ȣ / ���ڸ� ��ȭ��ȣ / ���ڸ� ��ȭ��ȣ
SELECT name, tel
    , INSTR( tel, ')' ) ") ��ġ" -- 4
    , INSTR( tel, '-' ) "- ��ġ" -- 8
    , SUBSTR( tel, 1, INSTR( tel, ')' )-1 ) "������ȣ )-1"
    , SUBSTR( tel, INSTR( tel, ')' )+1, INSTR( tel, '-' )-INSTR( tel, ')' )-1 ) "�� ��ȭ��ȣ"
    , SUBSTR( tel, INSTR( tel, '-' )+1) "�� ��ȭ��ȣ"
FROM tbl_tel;

-- RPAD / LPAD
    -- PAD == �� ��� ��, �޿� ���� ��, �е�
    -- ����) RPAD(expr1, n [,expr2])
    SELECT ename, pay
        , RPAD(pay, 10, '*' )
        , LPAD(pay, 10, '*' )
    FROM(
        SELECT ename, sal+NVL(comm,0) pay
        FROM emp
        ) t;

-- ASCII()
SELECT ename
    , SUBSTR( ename, 1,1)
    , ASCII( SUBSTR( ename, 1,1) )
    , CHR( ASCII( SUBSTR( ename, 1,1) ) )
FROM emp;
-- 
SELECT ASCII('A'), ASCII('a'), ASCII('0') -- 65	97	48
FROM dual;

-- GREATEST(), LEAST()  ������ ����, ���� �߿� ���� ū, ���� ���� �����ϴ� �Լ�
SELECT GREATEST(3,5,2,4,1)
    , GREATEST('R', 'A', 'Z', 'X')
    , LEAST(3,5,2,4,1)
    , LEAST('R', 'A', 'Z', 'X')
FROM dual;

-- VSIZE()
SELECT ename
    , VSIZE(ename) -- 5
    , VSIZE('ȫ�浿') -- 9 byte
    , VSIZE('a')
    , VSIZE('��')
FROM emp;
-- ���� �Լ�
-- ���� �Լ�
-- [��¥ �Լ�] 
SELECT SYSDATE -- '24/02/19'   ��
    , ROUND( SYSDATE ) a -- �� �ݿø�/ '24/02/20' ������ �������� ��¥ �ݿø�.  
    , ROUND( SYSDATE, 'DD' ) b -- �� �ݿø�/ '24/02/20' ������ �������� ��¥ �ݿø�.  
    , ROUND( SYSDATE, 'MONTH' ) c -- �� �ݿø�/ �� ���� 15�� �������� �̿�
    , ROUND( SYSDATE, 'YEAR' ) d -- �� �ݿø�
FROM dual;
-- ��¥�� �����Լ� : TRUNC()
SELECT SYSDATE
    , TO_CHAR( SYSDATE, 'YYYY.MM.DD HH24.MI.SS' ) a -- 2024.02.19 03.38.25
    , TRUNC( SYSDATE )         -- �ð� �� �� 00:00:00 ����
    , TRUNC( SYSDATE, 'DD' )   -- �ð� �� �� 00:00:00 ����    
    , TO_CHAR( TRUNC( SYSDATE ), 'YYYY.MM.DD HH24.MI.SS' ) b -- 2024.02.19 12.00.00
    , TRUNC ( SYSDATE, 'MONTH' ) -- 24/02/[01] �� ������ ����
    , TRUNC ( SYSDATE, 'YEAR' ) -- 24/[01]/[01] �� ������ ����
FROM dual;

-- ��¥ + ���� ��¥ ��¥�� �ϼ��� ���Ͽ� ��¥ ���
SELECT SYSDATE + 100 -- 24/05/29
FROM dual;
-- ��¥ - ���� ��¥ ��¥�� �ϼ��� ���Ͽ� ��¥ ���
SELECT SYSDATE -30
FROM dual;
-- ��¥ + ����/24 ��¥ ��¥�� �ð��� ���Ͽ� ��¥ ��� 
-- 2�ð� �Ŀ� ������ ( ��� )
SELECT SYSDATE
    -- 2024/02/19 16:03:49
    , TO_CHAR( SYSDATE, 'YYYY/MM/DD HH24:MI:SS' )
    , SYSDATE + 2/24
    -- 2024/02/19 18:05:08
    , TO_CHAR( SYSDATE +  2/24, 'YYYY/MM/DD HH24:MI:SS' ) 
FROM dual;
-- ��¥ - ��¥ = �ϼ�  ��¥�� ��¥�� ���Ͽ� �ϼ� ���
-- [����] �Ի��� ��¥ ���Ϳ��� ��¥���� �ٹ��� �ϼ� ���� ?
SELECT ename
    , hiredate
    , SYSDATE
    , CEIL( SYSDATE - hiredate ) -- �ݿø��� ��
    , TRUNC(SYSDATE+1) - TRUNC(hiredate) -- ��¥-��¥=�ٹ��ϼ�
from emp;

-- [����] 24�� 2�� ������ ��¥ �� �ϱ���?
-- [2]
SELECT SYSDATE
    -- �Ű����� ��¥�� ������ ��¥�� ��ȯ�ϴ� �Լ� LAST_DAY()
    , LAST_DAY(SYSDATE) -- 24/02/29
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD') -- 29
FROM dual;

-- [1]
SELECT SYSDATE a --24/02/19
    -- , TRUNC( SYSDATE, 'DD' ) �ð�,��,�� ����
    , TRUNC( SYSDATE, 'MONTH' ) b -- 24/02/01
    -- 1�� ���ϱ�
 --   , ADD_MONTHS( TRUNC( SYSDATE, 'MONTH' ), -1 ) -- 24/01/01
 --   , ADD_MONTHS( TRUNC( SYSDATE, 'MONTH' ), 1 ) -- 24/03/01
 --   , ADD_MONTHS( TRUNC( SYSDATE, 'MONTH' ), 1 )-1 -- 24/02/29
    , TO_CHAR( ADD_MONTHS( TRUNC( SYSDATE, 'MONTH' ), 1 ) -1, 'DD') -- 29
FROM dual;

-- [����] �����Ϸκ��� ���ó�¥���� �ϼ� ?
-- 2023.12.29 ����
-- [����] ���� ��¥���� �����ϱ��� ���� �ϼ� ?
-- 2024.06.14 ����
-- ��¥ - ��¥ = �ϼ�
SELECT SYSDATE
    , '2023.12.29'
    , TO_DATE('2023.12.29', 'YYYY.MM.DD') 
    , CEIL ( SYSDATE  - TO_DATE('2023.12.29', 'YYYY.MM.DD') )
    , ABS( CEIL( SYSDATE - TO_DATE('2024.06.14', 'YYYY.MM.DD'))) -- ABS(���밪)�Լ����
FROM dual;

-- NEXT_DAY() �Լ� : ��õ� ������ ���ƿ��� ���� �ֱ� ��¥�� �����ϴ� �Լ�
SELECT SYSDATE
    ,TO_CHAR( SYSDATE, 'YYYY/MM/DD (DY)')   a
    ,TO_CHAR( SYSDATE, 'YYYY/MM/DD (DAY)')  b
    -- ���� ����� �ݿ��ϳ� �������...
    , NEXT_DAY( SYSDATE, '��') -- 24/02/23
    , NEXT_DAY( SYSDATE, '��') -- 24/02/26
FROM dual;
-- [����] 4�� ù ��° ȭ���Ͽ� ������( ��� )
--           ù ��° �����Ͽ� ������( ��� )
SELECT TO_DATE('2024.04.01')-1 ��
--    , NEXT_DAY( TO_DATE('2024.04.01'), 'ȭ' ) -- 24/04/02
    , NEXT_DAY( TO_DATE('2024.04.01') -1, '��') �� -- 24/04/01
FROM dual;

-- MONTHS_BETWEEN() : �� ��¥ ������ ������ ��ȯ�ϴ� �Լ�
SELECT ename, hiredate
    , SYSDATE
    , CEIL(ABS( hiredate - SYSDATE)) �ٹ��ϼ�
    , MONTHS_BETWEEN( SYSDATE, hiredate ) �ٹ�������
    , ROUND( MONTHS_BETWEEN( SYSDATE, hiredate )/12 ) �ٹ����
    , ROUND( MONTHS_BETWEEN( SYSDATE, hiredate )/12, 2) �ٹ���� -- �Ҽ��� �ι�°�ڸ�����
FROM emp;

SELECT SYSDATE
    , CURRENT_DATE  
    , CURRENT_TIMESTAMP
FROM dual;

-- 2) TO_CHAR(��¥, ����)
-- [����] emp ���̺��� pay�� ���ڸ� ���� �޸��� ����ϰ� �տ� ��ȭ��ȣ�� ������.
SELECT num, name
    , basicpay, sudang
    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang, 'L9,999,999')
FROM insa;
--
SELECT 12345
    , TO_CHAR( 12345 ) -- ���ڿ�'12345'
    , TO_CHAR( 12345, '9,999') -- ######(�ڸ��������Ҷ�)
    
    , TO_CHAR( 12345, '99,999' ) --  12,345
    , TO_CHAR( 12345, '99,999.00' ) --  12,345.00
    , TO_CHAR( 12345, '99,999.99' ) --  12,345.00  
    , TO_CHAR( 12345.123, '99,999.00' ) --  12,345.12
    , TO_CHAR( 12345.123, 'L99,999.00' ) -- ��12,345.12
FROM dual;

SELECT TO_CHAR( -100, '9999PR') -- <100>
    , TO_CHAR( -100, '9999MI') --  100-
    , TO_CHAR(-100, 'S9999') -- -100
    , TO_CHAR(100, 'S9999') --  +100
FROM dual;

-- ��ȯ �Լ�
-- 1) TO_NUMBER() X
-- 2) TO_CHAR(NUMBER) O,    TO_CHAR(��¥,����)











