-- SCOTT
SELECT *
FROM tabs;

-- [����Ŭ DATA TYPE ] --
--1. CHAR �������� 2000 byte
--2. N+CHAR �������� 2000 byte
--3. VAR+CHAR2 �������� 4000 byte --����: VARCHAR2(SIZE BYTE|CHAR)
--4. N+VAR+CHAR2 �������� 4000 byte
--5. LONG     �������� 2GB
-- ORA-01438: value larger than specified precision allowed for this column
INSERT INTO dept (deptno, dname, loc ) VALUES( 100, 'QC', 'SEOUL' ); X
INSERT INTO dept (deptno, dname, loc ) VALUES( -20, 'QC', 'SEOUL' );
ROLLBACK;
DESC dept;

-- 6. NUMBER [(precision[,scale])] ����(����, �Ǽ�)
--            p(���е�) : 1~38     ��ü�ڸ���
--            s(�Ը�) : -84~127   �Ҽ��� ���� �ڸ���
��)
NUMBER == NUMBER(38,127) -- �ְ�
DEPTNO NUMBER(2) == NUMBER(2,0) == 2�ڸ� ����   -99~99 ����
KOR NUMBER(3) == NUMBER(3,0) == 3�ڸ� ����   -999~999 ����
                                            0 <=    <=100 -- ����ɶ� : üũ�������� ���
AVG NUMBER(5,2) == 100.00
    98.66666    == 98.67

-- ���� ������ �����ϰ� �߻��ؼ� ����
INSERT INTO �������̺� ( kor, eng, mat ) 
VALUES ( SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100) );

-- �й�(PK), �л���, ��,��,��,��,��,�� �÷��� -- ���б���:�����̸� Ű(������ Ű,�⺻Ű,PK)==�ĺ� Ű
-- ORA-00907: missing right parenthesis / ��ȣ() �Ǵ� �޸�(,)�� ������ �� �����߻�
CREATE TABLE tbl_score
(
    no      NUMBER(2)      NOT NULL     PRIMARY KEY -- PK==NN(NOT NULL) + UK(���ϼ� ��������)
    , name  VARCHAR2(30)   NOT NULL              
    , kor   NUMBER(3)
    , eng   NUMBER(3)
    , mat   NUMBER(3)
    , tot   NUMBER(3)
    , avg   NUMBER(5,2)
    , rank  NUMBER(2)
);

INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 1, 'ȫ�浿', 90, 87, 88.89 );
--INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 2, '������', 990, -88, 65 );
INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 2, '������', 99, 88, 65 );
--INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 3, '�躴��', 1999, 68, 82 );
INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 3, '�躴��', 19, 68, 82 );
COMMIT;
-- 1 �� ��(��) ���ԵǾ����ϴ�.
ROLLBACK;
SELECT *
FROM tbl_score
ORDER BY RANK;

--
UPDATE tbl_score
SET eng = 0
WHERE no = 2;

-- 3�� �л��� ��/��/��/��/�� �Է�. -> ��/��/�� ó��
UPDATE tbl_score
SET tot = kor+eng+mat, avg=(kor+eng+mat)/3, rank = 1;
-- WHERE

-- [����] ��� ó���ϴ� UPDATE �� �ۼ�.
UPDATE tbl_score p
SET p.rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE c.tot > p.tot ) ;
--WHERE �ʿ�x

-- FLOAT(p) �����ڷ���, ���������� NUMBER ó��

-- ��¥ �ڷ���
 ��. DATE 7����Ʈ, ��������, �ʱ��� ����
 ��. TIMESTAMP(n) 0~9(nano)
    TIMESTAMP == TIMESTAMP(6) 00:00:00.000000
    
-- ���������� ����     ???.png �̹����� 101010101010 ���������͸� ����.
RAW(SIZE) 2000byte
LONG RAW  2GB

--
B + FILE    Binary �����͸� �ܺο� file���·� (264 -1����Ʈ)���� ���� 
B + LOB    Binary �����͸� 4GB���� ���� (4GB= (232 -1����Ʈ)) 
C + LOB    Character �����͸� 4GB���� ���� --�Խ��Ǹ��鶧���
NC + LOB    Unicode �����͸� 4GB���� ����  --�Խ��Ǹ��鶧���
-- ***** �ڷ��� ��� �����ϱ�
-- ex) �����ڷ���-char, cLOB....�� / �������ڷ���-RAW, BFILE, BLOB...��

-- COUNT() OVER() ������ ���� ������ ������� ��ȯ
-- ORA-00937: not a single-group group function
SELECT buseo, name, basicpay
--    , COUNT(*) OVER(ORDER BY basicpay ASC)
--    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC)

--    , SUM(basicpay) OVER(ORDER BY basicpay ASC)
--    , SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC)
    
    , AVG(basicpay) OVER(ORDER BY basicpay ASC)
    , AVG(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC)    
FROM insa;

-- [����] �� ������(city) �޿� ���
-- ORA-00937: not a single-group group function
SELECT city, name, basicpay
--    , AVG(basicpay)
    , AVG(basicpay) OVER(PARTITION BY city ORDER BY city ASC)
    , basicpay - AVG(basicpay) OVER(PARTITION BY city ORDER BY city ASC)
FROM insa;

-- [���̺� ����, ����, ����] + ���ڵ� �߰�, ����, ���� --
-- 1) ���̺�(table) ? �����������
2) DB �𵨸� -> ���̺� ����
 ��) �Խ����� �Խñ� �����ϱ� ���� ���̺� ����
  ��. ���̺�� : tbl_board
  ��. �����÷�     �������÷���       �ڷ���(ũ��)             �����(�ʼ��Է�)
   �۹�ȣ(PK)      seq                 NUMBER  p38,s127        NOT NULL(NN)
   �ۼ���          writer              VARCHAR2(20)             NN
   ��й�ȣ(Ȯ�ο�) password            VARCHAR2(15)             NN
   ����           title                VARCHAR2(100)            NN   
   ����           content              CLOB                    
   �ۼ���          regdate             DATE                    DEFAULT SYSDATE
   ��ȸ��          readno              NUMBER                  DEFAULT 0
   ���
   
�����������ġ�
    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
      ( 
        ���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] 
       [,���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] ] 
       [,...]  
      ); 
      
    ��)TEMPORARY �ӽ� ���̺� ���� -> ����(����) ��������(�α׾ƿ���) �ӽ����̺� �����
--    CREATE GLOBAL TEMPORARY TABLE tbl_board
    CREATE TABLE tbl_board
    (
        seq           NUMBER            NOT NULL     PRIMARY KEY--���ϼ���������
        , writer      VARCHAR2(20)      NOT NULL
        , password    VARCHAR2(15)      NOT NULL
        , title       VARCHAR2(100)     NOT NULL
        , content     CLOB           
        , regdate     DATE              DEFAULT SYSDATE
    );

DESC tbl_board;

-- ���̺� ���� : CREATE TABLE (DDL)
-- ���̺� ���� : ALTER TABLE (DDL)
    --? alter table ... add �÷�,��������      �߰�
    --? alter table ... modify �÷�   ����
    --? alter table ... drop[constraint] ��������   ����
    --? alter table ... drop column �÷� ����
-- ���̺� ���� : DROP TABLE (DDL)
SELECT *
FROM tbl_board;
--
INSERT INTO tbl_board ( seq,writer,password,title,content,regdate)
VALUES                ( 1, 'ȫ�浿', '1234', 'test-1', 'test-1', SYSDATE );
COMMIT;
-- ORA-00001: unique constraint (SCOTT.SYS_C007023) violated 
--            ���ϼ� ��������                         ����ȴ�.
INSERT INTO tbl_board ( seq,writer,password,title,content,regdate)
VALUES                ( 2, '�Ǹ���', '1234', 'test-2', 'test-2', SYSDATE );
COMMIT;
--            ���ϼ� ��������                         ����ȴ�.
INSERT INTO tbl_board 
VALUES                ( 3, '�迵��', '1234', 'test-3', 'test-3', SYSDATE );
COMMIT;
--            ���ϼ� ��������                         ����ȴ�.
-- ORA-00947: not enough values
INSERT INTO tbl_board ( seq,writer,password,title,content)
VALUES                ( 4, '�̵���', '1234', 'test-4', 'test-4' );
COMMIT;
--            ���ϼ� ��������                         ����ȴ�.  
INSERT INTO tbl_board ( writer,seq,password,title,content,regdate)
VALUES                ( '�̽���',5,'1234', 'test-5', 'test-5', null );
COMMIT;
--
SELECT *
FROM tbl_board;

-- ���������̸��� �����ؼ� ���������� ������ �� �ְ�
-- , ���������̸� �������� ������ SYS_xxx �̸����� �ڵ� �ο��ȴ�.
-- ���������̸� : SCOTT.SYS_C007023
SELECT *
FROM user_constraints
WHERE table_name LIKE '%BOARD'; -- ��������Ȯ��
FROM tabs;
FROM user_tables;

-- ���̺� ���� : ��ȸ�� �÷� (1��) �߰�...
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0; -- 1�� Į���� �߰��� ��� () ��ȣ ���� �����ϴ�.
-- ADD ();
DESC tbl_board;
-- 
SELECT *
FROM tbl_board;

--
INSERT INTO tbl_board ( writer,seq,password,title)
VALUES                ( '�̻���',( SELECT NVL(MAX(seq),0)+1 FROM tbl_board) ,'1234', 'test-6' );
COMMIT;
-- content  NULL �� ��� "���� ����" UPDATE.
UPDATE tbl_board
SET content = '���� ����'
WHERE content IS NULL ;
--
SELECT *
FROM tbl_board;

-- �Խ����� �ۼ���(WRITER   NOT NULL   VARCHAR2(20->40) SIZE Ȯ��(O) )
-- �÷��� �ڷ����� ũ�⸦ ����.
DESC tbl_board;
-- ORA-00907: missing right parenthesis 
-- ���������� ������ �� ����. ->  �����߻� ( ���� -> ���� �߰� ) NOT NULL ����
-- NOT NULL ���������� �� ����.
ALTER TABLE tbl_board
MODIFY ( WRITER VARCHAR2(40) );
-- WRITER  NOT NULL  VARCHAR2(40)

-- [ �÷�����( title -> subject ) ���� ]
--     �� �÷��̸��� �������� ������ �Ұ����ϴ�.
-- ALTER TABLE ���̺��  MODIFY () ; X
SELECT title AS subject, content
FROM tbl_board;
--
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;
-- Table TBL_BOARD��(��) ����Ǿ����ϴ�. -- SUBJECT  NOT NULL VARCHAR2(100)
DESC tbl_board;

-- [ ��Ÿ ���� ���� ����  bigo �÷� ���� �߰� -> �÷� ���� ]
ALTER TABLE tbl_board
ADD bigo VARCHAR2(100) ; 
--
DESC tbl_board;
--
SELECT *
FROM tbl_board;
--
ALTER TABLE tbl_board
DROP COLUMN bigo;

-- [ ���̺��� �̸��� tbl_board -> tbl_test �� ���� ]
RENAME tbl_board TO tbl_test;
-- ���̺� �̸��� ����Ǿ����ϴ�.
SELECT *
FROM tabs;
-- ���̺� ����
DROP TABLE tbl_test;

-- ���̺� �����ϴ� ��� : 6����
-- [ 3. Subquery�� �̿��� table ���� ]
--      �� �̹� �����ϴ� ���̺��� �̿��ؼ� => ���ο� ���̺� ���� + ������(���ڵ�) �߰�
--�����ġ�
--	CREATE TABLE ���̺�� [�÷��� (,�÷���),...]
--	AS subquery;
--? �ٸ� ���̺� �����ϴ� Ư�� �÷��� ���� �̿��� ���̺��� �����ϰ� ���� �� ���
--? Subquery�� ��������� table�� ������
--? �÷����� ����� ��� subquery�� �÷����� ���̺��� �÷����� �����ؾ� �Ѵ�.
--? �÷��� ������� ���� ���, �÷����� subquery�� �÷���� ���� �ȴ�.
--? subquery�� �̿��� ���̺��� ������ �� CREATE TABLE ���̺�� �ڿ� �÷����� ����� �ִ� ���� ����.

-- ��) emp ���̺��� �̿��ؼ�
--    30�� �μ������� empno, ename, hiredate, job �� ���ο� ���̺� ����
CREATE TABLE tbl_emp30 (no, name, hdate, job, pay)
AS 
(
    SELECT empno, ename, hiredate, job , sal+NVL(comm,0) pay
    FROM emp
    WHERE deptno = 30
)
-- Table TBL_EMP30��(��) �����Ǿ����ϴ�.
-- PAY      NUMBER : �ڵ����� ������ �ڷ������� �����ȴ�.
DESC tbl_emp30;
SELECT *
FROM tbl_emp30;
-- ���������� ������� �ʴ´�.
-- ��. emp ���̺� �������� Ȯ��
-- ��. tbl_emp30 ���̺� �������� Ȯ��
-----------------------------------------------------
-- ��) ���� ���̺��� -> ���ο� ���̺� ���� + ���ڵ� �ʿ�X ( ���� ���̺��� ������ ���� )
CREATE TABLE tbl_emp20 -- ( �÷�...)
AS 
(
    SELECT *
    FROM emp
    WHERE 1 = 0 -- ������ �׻� ����
)

SELECT *
FROM tbl_emp20;
--
DROP TABLE tbl_emp20;
-- [����] emp, dept ���̺��� �̿��ؼ�
-- deptno, dname, empno, ename, hiredate, pay, grade �÷���
-- ���� ���ο� ���̺� ����. ( tbl_empgrade )
-- ( ���� ��� )
-------���� Ǯ�
CREATE TABLE tbl_empgrade (deptno, dname, empno, ename, hiredate, pay, grade )
AS 
(
    SELECT 
    d.deptno, d.dname
    ,empno, ename, hiredate
    , sal+NVL(comm,0) pay
    FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
)
-------------------------------[�ؼ�]
-- JOIN ���� : dept.deptno = emp.deptno ��������
--            emp = salgrade            NON ���� ���� BETWEEN AND
-- dept : deptno, dname
-- emp : deptno, empno, ename, hiredate, pay
-- salgrade : grade
CREATE TABLE tbl_empgrade
AS
(SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0) pay
     , s.losal || ' ~ ' || s.hisal sal_range , grade
FROM dept d JOIN emp e ON d.deptno = e.deptno
            JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
);             
        --  JOIN ���̺�� s ON ��������
        --  JOIN ���̺�� s ON ��������
        --            :
--
SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0) pay
     , s.losal || ' ~ ' || s.hisal sal_range , grade
FROM dept d, emp e, salgrade s
WHERE d.deptno = e.deptno AND e.sal BETWEEN s.losal AND s.hisal;
--
SELECT *
FROM tbl_empgrade;


-- ���̺� ����
DROP TABLE TBL_EMPGRADE; -- ������ �̵�
PURGE RECYCLEBIN; -- ������ ����

-- ���̺� ���� + ���� ���� ( ��������� )
DROP TABLE TBL_EMPGRADE PURGE; -- ���� ���̺� ���� XE

-- INSERT �� --
DML - insert, update, delete
INSERT INTO ���̺�� [( �÷���, �÷���,... )] VALUES (�÷���,�÷���...);
COMMIT;
ROLLBACK;
-- [MultiTable INSERT ��] 4���� ����
--1) unconditional insert all ������ ���� INSERT ALL
CREATE TABLE tbl_dept10 AS ( SELECT * FROM dept WHERE 1=0 );
CREATE TABLE tbl_dept20 AS ( SELECT * FROM dept WHERE 1=0 );
CREATE TABLE tbl_dept30 AS ( SELECT * FROM dept WHERE 1=0 );
CREATE TABLE tbl_dept40 AS ( SELECT * FROM dept WHERE 1=0 );

DESC tbl_dept10;
DESC tbl_dept20;
DESC tbl_dept30;
DESC tbl_dept40;

-- unconditional insert all ��
--INSERT INTO ���̺�� (�÷���...) VALUES (�÷���...);
-- ���������� ��� ���ڵ� ���� ���Ǿ��� ��� ���̺� INSERT �ϴ� ��
INSERT ALL
    INTO tbl_dept10 VALUES (deptno, dname, loc)
    INTO tbl_dept20 VALUES (deptno, dname, loc)
    INTO tbl_dept30 VALUES (deptno, dname, loc)
    INTO tbl_dept40 VALUES (deptno, dname, loc)
 SELECT deptno, dname, loc
 FROM dept;

SELECT *
FROM tbl_dept40;

--2) conditional insert all   ������ �ִ� INSERT ALL
--    emp ->    tbl_emp10,tbl_emp20, tbl_emp30, tbl_emp40
CREATE TABLE tbl_emp10
AS
( SELECT * FROM emp WHERE 1=0 );

CREATE TABLE tbl_emp20
AS
( SELECT * FROM emp WHERE 1=0 );

CREATE TABLE tbl_emp30
AS
( SELECT * FROM emp WHERE 1=0 );

CREATE TABLE tbl_emp40
AS
( SELECT * FROM emp WHERE 1=0 );


INSERT ALL
   WHEN deptno = 10 THEN
     INTO tbl_emp10 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
   WHEN deptno = 20 THEN  
     INTO tbl_emp20 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
   WHEN deptno = 30 THEN
     INTO tbl_emp30 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
   ELSE
   INTO tbl_emp40 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * FROM emp;

SELECT * FROM tbl_emp10;
SELECT * FROM tbl_emp20;
SELECT * FROM tbl_emp30;

--3) conditional(������ �ִ�) first insert  
INSERT ALL --/ FIRST
    WHEN deptno = 10 THEN
        INTO tbl_emp10 VALUES ()
    -- 7934	MILLER	CLERK	7782	82/01/23	1300		10    
    WHEN job = 'CLERK' THEN
        INTO tbl_emp_clerk VALUES ()    
    -- 7934	MILLER	CLERK	7782	82/01/23	1300		10
    ELSE
        INTO tbl_else VALUES ()
SELECT * FROM emp;
--
SELECT * FROM emp
WHERE deptno = 10 AND job = 'CLERK'; 

--4) pivoting insert          
CREATE TABLE sales( -- �Ǹ� ���̺�
     employee_id       number(6), -- �ǸŸ� �� ���ID
     week_id            number(2),-- �Ǹ��� ��
     sales_mon          number(8,2), -- �� �Ǹ��� ����
     sales_tue          number(8,2),
     sales_wed          number(8,2),
     sales_thu          number(8,2),
     sales_fri          number(8,2)  -- �� �Ǹ��� ����
);

INSERT INTO sales VALUES(1101,4,100,150,80,60,120);
Insert Into sales VALUES(1102,5,300,300,230,120,150);
COMMIT;
--
SELECT * 
FROM sales;
--
CREATE TABLE sales_data(
     employee_id        number(6),
     week_id            number(2),
     sales              number(8,2));
-- Table SALES_DATA��(��) �����Ǿ����ϴ�.
INSERT ALL
    INTO sales_data VALUES (employee_id, week_id, sales_mon)
    INTO sales_data VALUES (employee_id, week_id, sales_tue)
    INTO sales_data VALUES (employee_id, week_id, sales_wed)
    INTO sales_data VALUES (employee_id, week_id, sales_thu)
    INTO sales_data VALUES (employee_id, week_id, sales_fri)
SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed, sales_thu, sales_fri
FROM sales;

SELECT *
FROM sales_data;

COMMIT;

DROP TABLE tbl_emp10 PURGE;
DROP TABLE tbl_emp20 PURGE;
DROP TABLE tbl_emp30 PURGE;
DROP TABLE tbl_emp40 PURGE;

-- TRUNCATE ��
DROP TABLE SALES; -- ���̺� ��ü�� ����
DELETE FROM sales_data; -- ���̺� ���� ��� ���ڵ� ����
ROLLBACK;
SELECT * FROM sales_data;
-- 
TRUNCATE TABLE sales_data; -- ���̺� ���� ��� ���ڵ� ����( �ѹ�,���� + �ڵ�Ŀ�� ���ü���(�����Ϸ�)) - �����Ĵٽõ����� ����
DROP TABLE sales_data PURGE;

[����1] insa ���̺��� num, name �÷����� �����ؼ� 
      ���ο� tbl_score ���̺� ����
      (  num <= 1005 )
      
CREATE TABLE    tbl_score 
AS
(

   SELECT num, name
   FROM insa
   WHERE num <= 1005
)
-- Table TBL_SCORE��(��) �����Ǿ����ϴ�.

[����2] tbl_score ���̺�   kor,eng,mat,tot,avg,grade, rank �÷� �߰�
( ����   ��,��,��,������ �⺻�� 0 )
(       grade ���  char(1 char) )

ALTER TABLE tbl_score
ADD (
          kor NUMBER(3) DEFAULT 0
         ,eng NUMBER(3) DEFAULT 0
         ,mat NUMBER(3) DEFAULT 0
         ,tot NUMBER(3) DEFAULT 0
         ,avg NUMBER(5,2) 
         ,grade CHAR(1 CHAR)
         , rank NUMBER(3)
    );

DESC tbl_score;

CREATE TABLE
ALTER TABLE  �÷� �߰�, �������� �߰�, ����  ���
DROP TABLE   PURGE;

[����3] 1001~1005 
  5�� �л��� kor,eng,mat������ ������ ������ ����(UPDATE)�ϴ� ���� �ۼ�.
  
  SELECT *
  FROM tbl_score;
  
  UPDATE tbl_score
  SET kor = TRUNC( dbms_random.value(0, 101) )
     , eng= TRUNC( dbms_random.value(0, 101) )
     , mat = TRUNC( dbms_random.value(0, 101) );
  COMMIT;
[����4] 1005 �л��� k,e,m  -> 1001 �л��� ������ ���� (UPDATE) �ϴ� ���� �ۼ�.

SELECT kor, eng, mat 
FROM tbl_score
WHERE num = 1001;

UPDATE tbl_score
SET (kor, eng, mat) = (SELECT kor, eng, mat 
                        FROM tbl_score
                        WHERE num = 1001)
WHERE num = 1005;
COMMIT;
[����5] ��� �л��� ����, ����� ����...
     ( ���� : ����� �Ҽ��� 2�ڸ� )
UPDATE tbl_score
SET tot = kor + eng+mat
  , avg = (kor+eng+mat)/3
-- WHERE X

[����6] ���(grade) CHAR(1 char)  'A','B','c', 'D', 'F'
--  90 �̻� A
--  80 �̻� B
--  0~59   F
SELECT avg , avg/10, TRUNC( avg/10 )
FROM tbl_score;

DECODE ( TRUNC( avg/10 ), 10, 'A', 9, 'A', 8, 'B', 7,'C', 6, 'D', 'F')

UPDATE tbl_score
SET grade = CASE
               WHEN avg >= 90 THEN 'A'
               WHEN avg >= 80 THEN 'B'
               WHEN avg >= 70 THEN 'C'
               WHEN avg >= 60 THEN 'D'
               ELSE 'F'
            END;
COMMIT;
--
INSERT ALL
    WHEN avg >= 90 THEN
         INTO tbl_score (grade) VALUES( 'A' )
    WHEN avg >= 80 THEN
         INTO tbl_score (grade) VALUES( 'B' )
    WHEN avg >= 70 THEN
         INTO tbl_score (grade) VALUES( 'C' )
    WHEN avg >= 60 THEN
         INTO tbl_score (grade) VALUES( 'D' )
    ELSE
         INTO tbl_score (grade) VALUES( 'F' )
SELECT avg FROM tbl_score ; 



[����7] tbl_score ���̺��� ��� ó��.. ( UPDATE) 
UPDATE tbl_score p
-- SET  rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE c.tot > p.tot );
SET rank = (
               SELECT t.r
               FROM (
                   SELECT num, tot, RANK() OVER(ORDER BY tot DESC ) r
                   FROM tbl_score
               ) t
               WHERE t.num =p.num
           );
-- WHERE
COMMIT;
--
SELECT empno, ename, sal
  , ROW_NUMBER() OVER( ORDER BY sal DESC ) rn_rank
  , RANK() OVER( ORDER BY sal DESC ) r_rank
  , DENSE_RANK() OVER( ORDER BY sal DESC ) r_rank
FROM emp;

SELECT * 
FROM tbl_score;
-- [����8] ��� �л����� ���� ���� : 30�� �߰�...
76
26
21
95
76
UPDATE tbl_score
SET eng = CASE  
           WHEN eng + 30 > 100 THEN  100
           ELSE  eng+30
          END;
ROLLBACK;

SELECT * FROM tbl_score;
19
68
86 X
46
19
ROLLBACK;
-- [����] 1001~1005 �л� �߿� ���л��鸸 5���� ����... 
UPDATE tbl_score t
SET kor = kor + 5
where t.num = (
                select num 
                from insa 
                where MOD(substr(ssn,8,1), 2)=1 and t.num =num
            );
WHERE num = ANY( SELECT num
                FROM insa
                WHERE num <= 1005 AND MOD(SUBSTR(ssn,8,1),2)=1);
WHERE num IN ( SELECT num
                FROM insa
                WHERE num <= 1005 AND MOD(SUBSTR(ssn,8,1),2)=1);
--
(��) : MERGE(����)/��������/  ����/������ ����
(ȭ) : DB �𵨸� + ����������Ʈ
(��) : DB �𵨸� + ��ǥ
(��) : PL/SQL

������Ʈ �䱸/ ��/��/��+
(��)/(ȭ) PL/SQL ���� X
��/��/��/��/��/��/ȭ  -> ��ǥ ��/��/��   �� 
