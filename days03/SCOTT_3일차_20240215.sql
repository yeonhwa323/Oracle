-- SCOTT
-- [����] insa ���̺��� 70����(70~79���)�� �Ʒ��� ���� ���(��ȸ)
SELECT name
    --, ssn
    , CONCAT( SUBSTR( SSN, 1, 8), '*******') rrn -- ||
--    , EXTRACT( YEAR FROM ��¥ ) �ȵ�X
FROM insa 
-- '79' -> 79 ����ȯ
WHERE TO_NUMBER(SUBSTR(ssn, 0, 2)) BETWEEN 70 AND 79;

WHERE SUBSTR(ssn, 0, 2) BETWEEN 70 AND 79; -- �ڹٿ��� Ʋ������(���ڿ͹��ڿ��Ǻ񱳶�...)
WHERE SUBSTR(ssn, 1,1) = '7';

 SELECT name, substr(ssn,0,8) || '******' rrn
        , TO_DATE(SUBSTR(SSN, 0, 2), 'YY' ) --'YY'������� ������(YY������)
--        , substr(ssn,0,6) -- '771212'
--        , to_date(substr(ssn,0,6)) -- '77/12/12'
--        , extract (year from to_date(substr(ssn,0,6)) ) -- '77'
 FROM insa
-- WHERE extract (year from to_date(substr(ssn,0,6)) ) between 1970 and 1979 ; �����ؼ�X

-- [����] insa ���̺��� �����, �ֹε�Ϲ�ȣ, �⵵,��,�� ���� ��� ( STR �Լ� )
DESC insa;
SELECT name, ssn, ibsadate
    , substr(ssn, 1, 2) YEAR
    , substr(ssn, 3, 2) MONTH
    , substr(ssn, 5, 2) "DATE" --DATE �����
            -- ORA-00923: FROM keyword not found where expected (DATE������)
    , substr(ssn, 8, 1) GENDER
FROM insa;

-- ����Ŭ�� ����� : DATE
SELECT *
FROM dictionary
WHERE table_name LIKE '%WORD%';
--
SELECT *
FROM V$RESERVED_WORDS;

-- [����] emp ���̺��� �Ի�����(hiredate)�� 81�⵵�� ��� ���� ��ȸ(���)
--[3]
--String hiredate = "80/12/17";
--String year = hiredate.substring(0,2);
-- year = "80";

SELECT 'abcdefg'
    ,substr('abcdefg', 1, 2) -- ab 1 ù ����
    ,substr('abcdefg', 0, 2) -- ab 0 ù ����
    ,substr('abcdefg', 3) -- cdefg     
    ,substr('abcdefg', -5, 3) -- cde 
    ,substr('abcdefg', -1, 1) -- g 
From dual;

SELECT ename, hiredate -- '80/12/17'
    , SUBSTR( hiredate, 1, 2)
FROM emp
WHERE SUBSTR( hiredate, 1, 2) = '81' ;

--[2] DATE -> �Ի�⵵�� �����⸦ ����
-- ���� ��¥�� ��/��/�� ���: DATE(��), TIMESTAMP(���뼼����, �ð��������Ÿ��).
-- �ڹ� : Date d = new Date();    Calendar c = Calendar.getInstance();
--          d.getYear()                 c.get(Calendar.YEAR)
SELECT SYSDATE, CURRENT_TIMESTAMP 
    , EXTRACT( YEAR FROM SYSDATE ) --  2024 ���� 
    , TO_CHAR(SYSDATE, 'YYYY') -- '2024' ���ڿ�:���� ���� 
    , TO_CHAR(SYSDATE, 'YY') -- '24'
    , TO_CHAR(SYSDATE, 'YEAR') -- 'TWENTY TWENTY-FOUR' �������·�
FROM dual;
-- �Խ��� : �ۼ��� �÷� SYSDATE ����ؼ� �ʱ��� ����.

SELECT ename, hiredate    
FROM emp
WHERE EXTRACT( YEAR FROM hiredate ) = '1981';
WHERE TO_CHAR( hiredate, 'YYYY' ) = '1981';

--[1]
-- �� ������ : ����, ����, ��¥(80/12/17)
DESC emp;
-- HIREDATE            DATE
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN '81/01/01' AND '81/12/31';
-- WHERE hiredate>= '81/01/01' AND hiredate<= '81/12/31';

-- [NOT] LIKE     SQL������ ����
-- ������ ���� ��ġ ���� üũ�ϴ� ������
-- ���ϵ�ī��( % _ )
-- %   0~���� ���� ����
-- _   �� ���� ����
-- ���ϵ�ī��( % _ ) �� �Ϲݹ���ó�� ����Ϸ��� ESCAPE �ɼ��� ����϶�.. ****

-- [����] insa ���̺��� 70����(70~79���)�� �Ʒ��� ���� ���(��ȸ)
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7%';

-- [����] insa ���̺��� 12������ �Ʒ��� ���� ���(��ȸ)
SELECT name, ssn
FROM insa
WHERE SUBSTR( ssn, 3,2) = '12';
--
SELECT name, ssn
FROM insa
WHERE SSN LIKE '7_12%'
WHERE SSN LIKE '_12%';
WHERE REGEXP_LIKE( ssn, '^7[0-9]12' );
--
SELECT name, ssn
    , SUBSTR(ssn, 1,4)
    , TO_DATE ( SUBSTR(ssn, 0,4) , 'YYMM') -- 1�� ����
    , EXTRACT(MONTH FROM  TO_DATE ( SUBSTR(ssn, 0,4) , 'YYMM') ) MONTH
FROM insa  
WHERE EXTRACT(MONTH FROM  TO_DATE ( SUBSTR(ssn, 0,4) , 'YYMM') ) = '12';

-- [����] insa ���̺��� �达 ���� ���� ��� ��� ���
SELECT name, ssn
FROM insa
WHERE name LIKE '��%';

-- [����] insa ���̺��� �达 �� ������ ��� ��� ���
SELECT name, ssn
FROM insa
WHERE name LIKE '_��_'; -- �̸��� ��� ���ڰ� '��'�ϰ�� ���
WHERE name LIKE '%��_'; -- �̸��� ������ �� ��° ���ڰ� '��'�̸� ���
WHERE name LIKE '_��%'; -- �̸��� �� ��° ���ڰ� '��'�̸� ���
WHERE name LIKE '%��%'; -- �̸� �ӿ� '��' ���ڰ� ������ ���
WHERE name NOT LIKE '��%';

-- "������".length() : ���ڿ� ����

-- [����] ��ŵ��� ����, �λ�, �뱸 �̸鼭 
--  ��ȭ��ȣ�� 5 �Ǵ� 7�� ���Ե� �ڷ� ����ϵ� 
--  �μ����� ������ �δ� ��µ��� �ʵ�����. (�̸�, ��ŵ�, �μ���, ��ȭ��ȣ)
SELECT  name
    , city
    , buseo
    , tel
    , substr( buseo, 1, length(buseo)-1)
FROM insa
WHERE city IN ('����' ,'�λ�' , '�뱸') AND  tel LIKE '%5%' OR tel LIKE '%7%';

-- ���� ���� --
FROM ��Ʈ�����̺�
WHERE ���� AND ���� AND ���� AND
            :
            
-- [ LIKE �������� ESCAPE �ɼ� ���� ] : ���ϵ�ī�带 �Ϲݹ���ó�� ����� �� ���
-- dept ���̺� ���� Ȯ��
DESC dept;
SELECT deptno, dname, loc
FROM dept;
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON

-- SQL 5���� : DQL(SELECT), DDL, DML(INSERT, UPDATE, DELETE) + �Ϸ�COMMIT, ���ROLLBACK
--            DCL, TCL

-- DML[INSERT] ���ο� �μ��� �߰�...
DESC dept;

INSERT INTO ���̺�� [( �÷���, �÷���....)] VALUES (��,...);
COMMIT;

INSERT INTO dept ( deptno, dname, loc ) VALUES ( 50,'QC100%T','SEOUL');
-- 1 �� ��(��) ���ԵǾ����ϴ�.
-- Ŀ�� �Ϸ�.
SELECT *
FROM dept;
-- 50	QC100%T	SEOUL -- �߰���
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
--                      ���ϼ� ��������  PK_DEPT
INSERT INTO dept VALUES ( 50,'�ѱ�_����','COREA'); -- �̹� �ִ� ���� �߰��Ұ�
INSERT INTO dept VALUES ( 60,'�ѱ�_����','COREA');
-- 1 �� ��(��) ���ԵǾ����ϴ�.

-- [����] dept ���̺��� �μ��� �˻��� �ϴ� ��
--                    �μ��� % �� �ִ� �μ� ������ ��ȸ
--                    �μ��� _ �� �ִ� �μ� ������ ��ȸ
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\'; -- ����(%)�� �ν���
WHERE dname LIKE '%\_%' ESCAPE '\'; -- ����(_)�� �ν���.
--WHERE dname LIKE '%_%'; -- ���ϵ�ī��(_)�� �ν��� 1�����̻� ��繮�� ���

-- DML(INSERT, [UPDATE], DELETE) + �Ϸ�COMMIT, ���ROLLBACK
UPDATE [��Ű��].���̺��
SET �÷�=��, �÷�=��...
[WHERE ������]; -- ������������, ��� ���ڵ带 �����ϰڴٴ� �ǹ�.
UPDATE scott.dept
SET LOC='XXX';
--6�� �� ��(��) ������Ʈ�Ǿ����ϴ�.
ROLLBACK;
--
UPDATE scott.dept
SET LOC='KOREA'
WHERE deptno=60;
-- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.
COMMIT;

UPDATE scott.dept
SET LOC='COREA', DNAME = '�ѱ۳���'
WHERE deptno=60;
-- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.
COMMIT;
-- [����] 30�� �μ���, ������ -> 60�� �μ���, ���������� UPDATE ����
-- ORA-00936: missing expression
UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno =30),loc=(SELECT loc FROM dept WHERE deptno =30)
WHERE deptno = 60;
--
UPDATE dept
SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno =30)
WHERE deptno = 60;
--
SELECT *
FROM dept;
--
COMMIT;

-- DML(INSERT, UPDATE, [DELETE]) + �Ϸ�COMMIT, ���ROLLBACK
DELETE FROM [��Ű��].���̺��
[WHERE ������;] -- ��� ���ڵ� ����

-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
-- �μ�dept(10,20,30) : �θ����̺� / ���emp : �ڽ����̺� => �θ����̺��� �����Ҽ� ����!!
-- ������̺��� ������ �������� �μ����̺�(40,50)�� ��������.
DELETE FROM dept
Where deptno IN (50,60);
WHERE deptno=50 OR deptno=60;
--
COMMIT;
--
SELECT *
FROM dept;

SELECT *
FROM emp;

-- [����] emp ���̺��� sal�� 10%�� �λ��ؼ� ���ο� sal�� �����ϼ���.
SELECT *
FROM emp;

UPDATE emp
SET sal = sal*1.1;
-- 12�� �� ��(��) ������Ʈ�Ǿ����ϴ�.
ROLLBACK;

-- LIKE SQL ������ : % _ ���ϱ�ȣ
-- REGEXP_LIKE �Լ� : ����ǥ���� 
-- [����] insa ���̺��� ���� �达, �̾� �� ��� ��ȸ.
SELECT *
FROM insa
WHERE SUBSTR(name, 1, 1) = '��' OR  SUBSTR(name, 1, 1) = '��';

WHERE REGEXP_LIKE( name, '^[^����]' );

WHERE REGEXP_LIKE( name, '[����]$' );
WHERE REGEXP_LIKE( name, '^(��|��)' );
WHERE REGEXP_LIKE( name, '^[����]' );
WHERE name LIKE '��%' OR name LIKE '��%';
WHERE SUBSTR(name, 1, 1)IN ('��', '��');
WHERE SUBSTR(name, 1, 1) = '��' OR  SUBSTR(name, 1, 1) = '��';

-- [����] insa ���̺��� 70��� ���� ����� ��ȸ...
-- ���� 1,3,5,7,9 ����
-- gender % 2 == 1
-- ����Ŭ ������ ������ ����X
-- ������ ���ϴ� �Լ� MOD()
SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE( ssn, '^7\d{5}-[13579]' );

--WHERE ssn LIKE '7%' AND SUBSTR(ssn, 8,1) IN (1,3,5,7.9) ;
--WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn, 8,1), 2) = 1 ;
--WHERE ssn LIKE '7_____-1%';
--WHERE REGEXP_LIKE( ssn, '^7[0-9]' ) AND (SUBSTR(ssn, 8,1) = 1);







