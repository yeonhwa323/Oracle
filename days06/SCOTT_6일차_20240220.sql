-- SCOTT
SELECT *
FROM tabs;

-- [����( JOIN )]
--                  ����
-- dept(�μ�) 1    �ҼӰ���    0�� emp(���)
-- deptno 10~40                 deptno ����
-- �θ�table                     �ڽ�table

-- [����] ��� ������ ���( �μ���ȣ, �μ���, �����, �Ի����� )
-- dept : deptno, dname, loc
-- emp : deptno, empno, ename, sal, comm, job, hiredate
-- [1]
-- ORA-00918: column ambiguously defined
SELECT dept.deptno, dname, ename, hiredate --, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno; -- ���� ������
-- [2] 100% ���� ���� ������
SELECT dept.deptno, dname, ename, hiredate --, emp.deptno
FROM emp JOIN dept ON emp.deptno = dept.deptno; -- ���� ������
--------------------------------------------------------------
-- ���� ���� --
--------------------------------------------------------------
-- TO_CHAR(NUMBER): ���� -> ���� ��ȯ
-- [TO_CHAR(DATE)  : ��¥ -> ���� ��ȯ]
SELECT SYSDATE
--    , TO_CHAR(SYSDATE, 'CC')  -- 21����, ��, ��, �� D DD DDD, ����, ����
--    , TO_CHAR(SYSDATE, 'DDD') -- 51��
    
    , TO_CHAR(SYSDATE, 'WW') -- 08  ���� ���° �� 
    , TO_CHAR(SYSDATE, 'W')  -- 3   ���� ���° ��
    , TO_CHAR(SYSDATE, 'IW') -- 08  1���� ��°��
FROM dual;

SELECT 
    TO_CHAR(TO_DATE('2024.01.01'), 'WW')    
    ,TO_CHAR(TO_DATE('2024.01.02'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.03'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.04'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.05'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.06'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.07'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.08'), 'WW') -- 02 ��°�� ������  
    ,TO_CHAR(TO_DATE('2024.01.14'), 'WW') -- 02 ��°�� �Ͽ���  
    ,TO_CHAR(TO_DATE('2024.01.15'), 'WW') -- 03 ��°�� ������  
    -- 1~7 ���ַ� ������
FROM dual;

SELECT 
    TO_CHAR(TO_DATE('2022.01.01'), 'IW')  -- ISO ǥ�� �� ��~�ϱ��� 1��. 
    ,TO_CHAR(TO_DATE('2022.01.02'), 'IW') 
    ,TO_CHAR(TO_DATE('2022.01.03'), 'IW')  
    ,TO_CHAR(TO_DATE('2022.01.04'), 'IW')   
    ,TO_CHAR(TO_DATE('2022.01.05'), 'IW')   
    ,TO_CHAR(TO_DATE('2022.01.06'), 'IW')   
    ,TO_CHAR(TO_DATE('2022.01.07'), 'IW')   
    ,TO_CHAR(TO_DATE('2022.01.08'), 'IW')  
    ,TO_CHAR(TO_DATE('2022.01.14'), 'IW')  
    ,TO_CHAR(TO_DATE('2022.01.15'), 'IW')   
FROM dual;
   
SELECT
    TO_CHAR( SYSDATE, 'BC')
    ,TO_CHAR( SYSDATE, 'Q') -- 1�б�(1~3��) 2�б�(4~6��) 3�б�(7~9��) 4�б�(10~12��)
FROM dual;

SELECT
    TO_CHAR( SYSDATE, 'HH')
    , TO_CHAR( SYSDATE, 'HH24')
    
    , TO_CHAR( SYSDATE, 'MI')    
    , TO_CHAR( SYSDATE, 'SS')  
    
    , TO_CHAR( SYSDATE, 'DY')    
    , TO_CHAR( SYSDATE, 'DAY')

    , TO_CHAR( SYSDATE, 'DL')    --LONG 2024�� 2�� 20�� ȭ����
    , TO_CHAR( SYSDATE, 'DS')    --SHORT 2024/02/20
FROM dual;

SELECT ename, hiredate
    , TO_CHAR(hiredate, 'DL')
    , TO_CHAR( SYSDATE, 'TS') -- ���� 3:50:12
    
    , TO_CHAR( CURRENT_TIMESTAMP, 'HH24:MI:SS.FF3' )
FROM emp;
--
-- TO_CHAR() ��¥, ����->���� ���� ��ȯ
-- [����] ���� ��¥�� TO_CHAR() �Լ��� ����ؼ�
--      2024�� 02�� 20�� ���� 16:05:29 (ȭ)
--      ���ڿ��� ���.

-- ORA-01821: date format not recognized
SELECT SYSDATE
--    , TO_CHAR( SYSDATE, 'DL' )
--    , LENGTH(TO_CHAR( SYSDATE, 'DL' )) ����
--   , SUBSTR(TO_CHAR( SYSDATE, 'DL'), 0,13) || TO_CHAR( SYSDATE, 'TS (DY)' )  ���ó�¥�ð�
--  , TO_CHAR( SYSDATE, 'YYYY') || '�� ' || TO_CHAR( SYSDATE, 'MM') || '�� '
    , TO_CHAR( SYSDATE, 'YYYY"��" MM"��" DD"��" AM HH24:MI:SS (DY)')
FROM dual;
--
SELECT name,ssn
    , SUBSTR(ssn, 1, 6)
    , TO_DATE( SUBSTR(ssn, 1, 6) )
    , TO_CHAR( TO_DATE( SUBSTR(ssn, 1, 6) ), 'DL' )
FROM insa;

-- ORA-01861: literal does not match format string
SELECT
    TO_DATE( '0821', 'MMDD' )   -- [24]/08/21   -- ����⵵�� �ڵ�ó����.
    , TO_DATE( '2023', 'YYYY' ) -- 23/[02]/[01] -- ������� �ڵ�ó����.
    , TO_DATE( '202312', 'YYYYMM' ) -- 23/12/[01]
    , TO_DATE('23�� 01�� 12��', 'YY"��" MM"��" DD"��"') -- 23/01/12
FROM dual;  

-- [����] ������ '6/14' ���ú��� ���� �ϼ� ?
-- ORA-01821: date format not recognized
SELECT SYSDATE
    , TO_DATE('6/14', 'MM/DD') -- 24/06/14
    , CEIL (ABS( SYSDATE - TO_DATE('6/14', 'MM/DD') )) -- 115
FROM dual;

-- [����] 4�ڸ� �μ���ȣ�� ���...     String.format("%04d", 10) "0010"
SELECT deptno
    , LPAD( deptno, 4, '0')
    , CONCAT('00', deptno)
    , TO_CHAR( deptno, '0999')
FROM emp;

-- java
if( a==b ) {
    c
    }
-- oracle DECODE(a,b,c)
if( a==b)
{
    c
}else{
    d
}

-- oracle DECODE(a,b,c,d)
if( a==b)
{
    c
}else if(a = d) {
    e
}else if(a = f) {
    g
}else {
    h
}
-- oracle DECODE(a,b,c,d,e,f,g,h)
-- [����] insa���̺��� ����/����...
SELECT name, ssn
      , REPLACE( REPLACE( MOD(SUBSTR(ssn, 8, 1), 2), 0, '����'), 1, '����') gender
      , DECODE( MOD(SUBSTR(ssn, 8, 1), 2), 0,'����','����'  ) gender
FROM insa;
-- [����] insa ���̺��� ������ �������� ������ ���� ���θ� ����ϴ� ������ �ۼ��ϼ��� . 
--   ( '������', '��������', '���� ' ó�� )
SELECT t.name, t.ssn
    , DECODE( s, 0, '����', 1, '���� ��', '���� ��')
FROM(
SELECT name, ssn
    , SIGN(TO_DATE(SUBSTR( ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)) s
FROM insa
) t;

-- [����] emp ���̺��� �� ����� ��ȣ,�̸�, �޿� ���
--    ����)  10�� �μ������� �޿��� 15% �λ��ؼ� �޿�
--    ����)  20�� �μ������� �޿��� 10% �λ��ؼ� �޿�
--    ����)  30�� �μ������� �޿���  5% �λ��ؼ� �޿�
SELECT empno, ename, sal+NVL(comm,0) pay, deptno
     , DECODE( deptno, 10, '15%', 20, '10%', 30, '5%' ) �λ��
     --, sal  + sal * DECODE( deptno, 10, 0.15 , 20, 0.1, 30, 0.05 ) "�λ�� pay"
     , (sal+NVL(comm,0))*(1+DECODE( deptno, 10, 0.15 , 20, 0.1, 30, 0.05 )) "�λ�� pay"
FROM emp;

-- ���� : �ڷ���/���̺� ����




