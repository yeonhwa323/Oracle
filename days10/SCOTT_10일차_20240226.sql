-- SCOTT 10����
SELECT *
FROM tabs;
--(��) : MERGE(����) x /�������� x / ���� x / ������ ����-����
(ȭ) : DB �𵨸� + ����������Ʈ
(��) : DB �𵨸� + ��ǥ
(��) : PL/SQL

������Ʈ �䱸/ ��/��/��+
(��)/(ȭ) PL/SQL ���� X
��/��/��/��/��/��/ȭ  -> ��ǥ ��/��/��   �� 

CREATE TABLE tbl_emp(
    id number primary key, 
    name varchar2(10) not null,
    salary  number,
    bonus number default 100
);
-- Table TBL_EMP��(��) �����Ǿ����ϴ�.
INSERT INTO tbl_emp(id,name,salary) values(1001,'jijoe',150);
INSERT INTO tbl_emp(id,name,salary) values(1002,'cho',130);
INSERT INTO tbl_emp(id,name,salary) values(1003,'kim',140);
COMMIT;
--
DESC tbl_emp;
--
SELECT * 
FROM tbl_emp;
--
CREATE TABLE tbl_bonus
(
    id number
    , bonus number default 100
);
-- Table TBL_BONUS��(��) �����Ǿ����ϴ�.
INSERT INTO tbl_bonus(id) (select e.id from tbl_emp e);
--
SELECT * FROM tbl_bonus;
--
1001	100
1002	100
1003	100
--
INSERT INTO tbl_bonus VALUES ( 1004,50 );
COMMIT;
--
1001	100
1002	100
1003	100
1004	50
--
-- ����
MERGE INTO tbl_bonus b
USING ( SELECT id, salary FROM tbl_emp ) e
ON (b.id = e.id )
WHEN MATCHED THEN
    UPDATE  SET b.bonus = b.bonus + e.salary * 0.01
    -- WHERE
WHEN NOT MATCHED THEN
    INSERT INTO (b.id, b.bonus) VALUES (  e.id, e.salary * 0.01 )
;

-- ���� 2)
CREATE TABLE tbl_merge1
(
     id number primary key
     , name varchar2(20)
     , pay number
     , sudang number
);
-- Table TBL_MERGE1��(��) �����Ǿ����ϴ�.
CREATE TABLE tbl_merge2
(
     id number primary key
     , sudang number
);
-- Table TBL_MERGE2��(��) �����Ǿ����ϴ�.
--
INSERT INTO tbl_merge1 ( id, name, pay, sudang) values ( 1, 'a', 100, 10);
INSERT INTO tbl_merge1 ( id, name, pay, sudang) values ( 2, 'b', 150, 20);
INSERT INTO tbl_merge1 ( id, name, pay, sudang) values ( 3, 'c', 130, 0);

INSERT INTO tbl_merge2 ( id, sudang) values ( 2,5);
INSERT INTO tbl_merge2 ( id, sudang) values ( 3,10);
INSERT INTO tbl_merge2 ( id, sudang) values ( 4,20);

COMMIT;

SELECT *
FROM tbl_merge1;
FROM tbl_merge2;
-- ���� : tbl_merge1(�ҽ�) -> tbl_merge2(Ÿ��) ����
--          1               insert
--          2               update

-- merge
MERGE INTO tbl_merge2 t2
--USING ( tbl_merge1 ) t1
USING ( SELECT id, sudang FROM tbl_merge1 ) t1
ON (t2.id = t1.id )
WHEN MATCHED THEN
    UPDATE  SET t2.sudang = t2.sudang + t1.sudang
WHEN NOT MATCHED THEN
    INSERT (t2.id, t2.sudang ) values (t1.id, t1.sudang);
COMMIT;
--
SELECT *
FROM tbl_merge2:
    
DROP TABLE tbl_merge1 PURGE;   
DROP TABLE tbl_merge2 PURGE;   
    
DROP TABLE tbl_bonus PURGE;   
DROP TABLE tbl_emp PURGE;        
----------------------------------------------
-- [ Constraints(��������) ]
-- scott �� �����ϰ� �ִ� ���̺� ��ȸ
SELECT * 
FROM user_tables;
-- scott �� �����ϰ� �ִ� emp ���̺� ������ �������Ǹ� ��ȸ
SELECT * 
FROM user_constraints
WHERE table_name = UPPER('emp');
-- ���������� ���̺� I/U/D �Ҷ��� ��Ģ���� ���
--             data integrity(������ ���Ἲ) �� ����
INSERT INTO dept values ( 10, 'QC', 'SEOUL' ); -- ��ü ���Ἲ(Entity Integrity)�� ����..

-- �������Ἲ(Relational Integrity )
-- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found ( 90 - ����x )
UPDATE emp 
SET deptno = 90
WHERE empno = 7369;

-- ������ ���Ἲ
DESC emp;

INSERT INTO emp ( empno ) VALUES ( 9999 );
-- ORA-01400: cannot insert NULL into ("SCOTT"."EMP"."EMPNO")
insert into emp ( ename ) values ( 'admin');
SELECt * FROM emp;
ROLLBACK;

tbl_score
    kor     0~100 ���� ��������
    
insert into tbl_score   kor     values(111); X

-- ���������� �����ϴ� �ñ⿡ ����
    ��. CREATE TABLE ��   : ���̺� ���� + �������� �߰�/����
        1) IN-LINE ��������     ( == �÷� ���� )    �������� ���� ���
            �� NOT NULL �������� ����
            
        2) OUT-OF-LINE �������� ( == ���̺� ���� )   �������� ���� ���
            �� �� �� �̻��� �÷��� �ϳ��� ���������� ������ ��..
        
    [��� �޿� ���� ���̺�]
    PK(primary key) - �ϳ��� ���ڵ带 �����ϱ� ���� Ű
    �޿����޳�¥ + ȸ��ID => PK (����Ű)  // ������ ���� (����) �� ���� ������ȭ ���
    (������ȭ) 
    ����  �޿����޳�¥  ȸ��ID  �޿���  ....��Ÿ�÷�
    1    20240125    7369    300����
    2    20240125    7666    300����
    3    20240125    8223    300����
    4        :
    15    20240225    7369    300����
    16    20240225    7666    300����
    17    20240225    8223    300����
    :

    U/D
   WHERE �޿����޳�¥='20240125' AND   ȸ��ID = 8223
   WHERE ���� =  3;
        
    ��. ALTER TABLE ��    : ���̺� ���� + �������� �߰�/����
    
select *
from emp
where ename='KING';
    
update emp
set deptno = null
where empno = 7839;
commit;

-- �ǽ� ) CREATE TABLE ������ COLUM LEVEL ������� �������� �����ϴ� ��
DROP TABLE tbl_constraint1;
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY -- �������Ǹ��� ������� �ʾƵ�
                                            -- SYS_xxxxx �ڵ����� �ڵ尪 �ο���.
    empno NUMBER(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL
    -- dept ���̺��� deptno (PK) ========> deptno �÷����� ����
    -- �ܷ�Ű==����Ű==����Ű ex) deptno
    , deptno NUMBER(2) CONSTRAINT FK_tblconstraint1_deptno REFERENCES dept(deptno)
    , email VARCHAR2(150) CONSTRAINT UK_tblconstraint1_email UNIQUE
    , kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100) -- WHERE�������� ���� ���� �ִ´�.
    , city NUMBER(20) CONSTRAINT CK_tblconstraint1_city CHECK(city IN ('����', '�뱸', '����'))
);
-- Table TBL_CONSTRAINT1��(��) �����Ǿ����ϴ�.
select *
from user_constraints
where table_name LIKE '%CONSTR' ;

-- �������� ��Ȱ��ȭ/Ȱ��ȭ --
-- city ���� �뱸 ���� üũ��������
ALTER TABLE TBL_CONSTRAINT1
DISABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY [CASCADE]; -- �������� ��Ȱ��ȭ.
ENABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY; -- �������� Ȱ��ȭ

-- �������� ����
1) PK �������� ����
ALTER TABLE TBL_CONSTRAINT1
DROP PRIMARY KEY;
--CASCADE : �� ���̺��� �����ؼ� PK�� ������ �ִ� ���� ���� �����ϸ� FK�� ����� ���� ���ÿ� �����ǰ� �ϴ� �ɼ��̴�
ALTER TABLE TBL_CONSTRAINT1
DROP CONSTRAINT ' PK_tblconstraint1_empno ' ;
CASCADE �ɼ� �߰� : FOREIGN KEY

2) CK
ALTER TABLE TBL_CONSTRAINT1
DROP CONSTRAINT 'CK_tblconstraint1_CITY' ;

3) UK
ALTER TABLE TBL_CONSTRAINT1
DROP CONSTRAINT 'UK_tblconstraint1_EMAIL' ;
--
ALTER TABLE TBL_CONSTRAINT1
DROP UNIQUE(email);

-- �ǽ� ) CREATE TABLE ������ TABLE LEVEL ������� �������� �����ϴ� ��
CREATE TABLE tbl_constraint2
(
      empno NUMBER(4) NOT NULL -- �÷� ���� �߰�
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) 
    , email VARCHAR2(150) 
    , kor NUMBER(3) 
    , city NUMBER(20) 
    
    --, CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY ( empno, ename ) ����Ű
    , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY ( empno )
    , CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT UK_tblconstraint2_email UNIQUE ( email )
    , CONSTRAINT CK_tblconstraint2_kor CHECK(kor BETWEEN 0 AND 100)                 -- �������� kor BETWEEN 0 AND 100�� ���� kor �ο��Ǿ��ֱ⶧���� ���� �������ص���
    , CONSTRAINT CK_tblconstraint2_city CHECK(city IN ('����', '�뱸', '����'))    
);
-- Table TBL_CONSTRAINT2��(��) �����Ǿ����ϴ�.

drop table tbl_constraint2 purge;
drop table tbl_constraint1 purge;

-- �ǽ�3) alter table ������ �������� �����ϴ� ��
 CREATE TABLE tbl_constraint3
 (
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
 );
-- Table TBL_CONSTRAINT3��(��) �����Ǿ����ϴ�.
����)
ALTER TABLE ���̺��
	ADD [CONSTRAINT �������Ǹ�] ��������Ÿ�� (�÷���);
    
1) empno �÷��� PK �������� �߰�...
ALTER TABLE tbl_constaint3
ADD CONSTRAINT PK_tblconstraint3_empno PRIMARY KEY(empno);
 
2) deptno �÷��� FK �������� �߰�
ALTER TABLE Tbl_Constaint3
ADD CONSTRAINT FK_tblconstraint3_deptno FOREIGN KEY (deptno) REFERENCES deptno(deptno) ;

--
DROP TABLE tbl_constraint3;

DELETE FROM dept
where deptno = 10;

create table emp
(
    -- deptno number(2) C ���� [F K(deptno)] R d(deptno) ON DELETE CASCADE
    ,  deptno number(2) C ���� [F K(deptno)] R d(deptno) ON DELETE SET NULL
);
null
null
null
--> ON DELETE CASCADE / ON DELETE SET NULL  �ǽ�
1) emp -> tbl_emp ����
2) dept -> tbl_dept ����

DROP TABLE tbl_dept;
DROP TABLE tbl_emp;

create table tbl_emp
AS
( SELECT * FROM emp );
-- Table TBL_EMP��(��) �����Ǿ����ϴ�.

create table tbl_dept
AS
( SELECT * FROM dept );
-- Table TBL_DEPT��(��) �����Ǿ����ϴ�.
-- tbl_dept PK �������� �߰�
-- tbl_emp PK �������� �߰�
-- �������� ����
ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tbldept_deptno PRIMARY KEY(deptno);
-- Table TBL_DEPT��(��) ����Ǿ����ϴ�.
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblemp_empno PRIMARY KEY(empno);
-- Table TBL_EMP��(��) ����Ǿ����ϴ�.

-- ���� ) tbl_emp ���̺� deptno �÷��� FK ���� + ON DELETE CASCADE �ɼ��� �߰�.
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblemp_deptno FOREIGN KEY ( deptno )
                                REFERENCES tbl_dept(deptno) 
                                ON DELETE SET NULL;
                               -- ON DELETE CASCADE;
-- Table TBL_EMP��(��) ����Ǿ����ϴ�.

SELECT *
FROM tbl_dept;
select *
from tbl_emp;
--
delete from dept
where deptno = 30;
--
delete from tbl_dept
where deptno = 30;

-- JOIN (����) --
-- exerd �˻�

-- å ���̺�
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- åID
      ,title    VARCHAR2(100)   NOT NULL  -- å ����
      ,c_name   VARCHAR2(100)   NOT NULL     -- c �̸�
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK��(��) �����Ǿ����ϴ�.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

COMMIT;

SELECT *
FROM book;

-- �ܰ����̺�( å�� ���� )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (�ĺ����� ***)
      ,price  NUMBER(7)    NOT NULL    -- å ����
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA��(��) �����Ǿ����ϴ�.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- å�� ���� �������̺�
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * 
FROM au_book;

-- ��(����) ���̺� 
-- �Ǹ� ( ���ǻ� <-> ���� )
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- �Ǹ� ���̺� ( � �������� � å�� ��ĥ�� �� �� �Ǹ��ߴ��� )
 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   
-- * ���� ����˱� *        
-- ��������
-- �������� ���� ��� : create - in/out line��� / arter table

-- ���� ���� ~
-- JOIN 
-- 1) equi join

-- [����] åID, å����, ���ǻ�(c_name), �ܰ� �÷� ���
-- book : b_id(PK), title, c_name
-- danga : b_id(PK, FK), [price]
--  ��. ����Ŭ���� natural join  �̶�� �θ���.
    SELECT book.b_id, title, c_name, price
    FROM book, danga
    WHERE book.b_id = danga.b_id; -- ��������   = ,
--  ��.
    SELECT book.b_id, title, c_name, price
    FROM book b, danga d
    WHERE b.b_id = d.b_id; -- ��������   = ,
--  ��. JOIN ~ ON ����
    SELECT b.b_id, title, c_name, price
    FROM book b join danga d ON b.b_id = d.b_id; -- ��������   = ,
--  ��. USING �� ��� : book.b_id(��ü��.�÷���) x,   b.b_id(��Ī��.�÷���) x
    SELECT b.b_id, title, c_name, price
    FROM book JOIN danga USING( b_id );
--  ��.
    ELECT b.b_id, title, c_name, price
    FROM book NATURAL JOIN danga ;
-- [����] åID, å����, �Ǹż���, �ܰ�, ������, �Ǹűݾ�(=�Ǹż���*�ܰ�) ���
-- ��. ���� ��,�� ������� Ǯ��
-- book : b_id, title, c_name
-- au_book : id, b_id, name
-- danga : b_id, price
-- panmai : id, g_id, b_id, p_date, p_su
-- gogaek : g_id, g_name, g_tel
--------------------------------------------
-- book : b_id, title
-- panmai : p_su 
-- danga : price
-- gogaek : g_name ����

select b.b_id, title, price, g_name, p_su
    , p_su*price �Ǹűݾ�
from book b, panmai p, gogaek g, danga d
where b.b_id = p.b_id AND g.g_id = p.g_id AND b.b_id = d.b_id;

-- ��. JOIN~ON�� �������
select b.b_id, title, price, g_name, p_su
    , p_su*price �Ǹűݾ�
from book b inner join panmai p on b.b_id = p.b_id
            inner join gogaek g on g.g_id = p.g_id
            inner join danga d on b.b_id = d.b_id;

-- ��. USING�� ����ؼ� Ǯ��
select b_id, title, price, g_name, p_su
    , p_su*price �Ǹűݾ�
from book join panmai using (b_id)
            join gogaek using (g_id)
            join danga using (b_id) ;

-- book : b_id, title
-- panmai : p_su 
-- danga : price
-- gogaek : g_name 

-- NONE EQUI JOIN
-- ������ ���� x
-- BETWEEN ~ AND ������ ���
SELECT ename, sal, grade, losal || ' ~ ' || hisal
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
--
SELECT ename, sal, grade, losal || ' ~ ' || hisal
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal ;

-- 
SELECT *
FROM emp;
select *
from dept;
-- emp / dept join [ INNER JOIN ]
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno ; -- EQUI JOIN
--      NULL -> 10/20/30/40 �� �ش�X
-- 11�� KING ��� X
SELECT *
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno ;

-- [OUTER JOIN]
-- ��. LEFT OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno;
--
SELECT d.deptno, ename, hiredate
FROM dept d, emp e 
WHERE d.deptno = e.deptno(+);

-- ��. RIGHT OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d RIGHT OUTER JOIN emp e ON d.deptno = e.deptno;
--
SELECT d.deptno, ename, hiredate
FROM dept d, emp e 
WHERE d.deptno (+)= e.deptno;

-- ��. FULL OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d FULL OUTER JOIN emp e ON d.deptno = e.deptno;
-- X -> ���ʿ� (+)����� �� ����
SELECT d.deptno, ename, hiredate
FROM dept d, emp e 
WHERE d.deptno(+) = e.deptno(+);

-- SELF JOIN
-- �����ȣ, �����, �Ի�����, ���ӻ������ȣ, ���ӻ���� �����
SELECT a.empno, a.ename, a.hiredate, a.mgr, b.ename
FROM emp a, emp b
where a.mgr = b.empno ;
--
SELECT a.empno, a.ename, a.hiredate, a.mgr, b.ename
FROM emp a join emp b on a.mgr = b.empno ;

-- CROSS JOIN : ��ī��Ʈ �� [emp 12 * dept 4 = 48 ��]
SELECT e.*, d.*
FROM emp e, dept d ;

SELECT e.*, d.*
FROM emp e CROSS JOIN dept d ;

-- book : b_id, title, c_name
-- au_book : id, b_id, name
-- danga : b_id, price
-- panmai : id, g_id, b_id, p_date, p_su
-- gogaek : g_id, g_name, g_tel

-- ����1) åID, å����, �Ǹż���, �ܰ�, ������(��), �Ǹűݾ�(�Ǹż���*�ܰ�) ��� 
select b_id, title, p_su, price, g_name
    , p_su*price �Ǹűݾ�
from book b join panmai p ON b.b_id = p.b_id
            join gogaek g ON p.g_id = g.g_id
            join danga d ON b.b_id = d.b_id ;         

-- ����2) ���ǵ� å���� ���� �� ����� �ǸŵǾ����� ��ȸ     
--      (    åID, å����, ���ǸűǼ�, �ܰ� �÷� ���   )
book : b_id, title
danga : price
panmai : p_su
-- [1]
select b.b_id, title, price, SUM(p_su) ���ǸűǼ�
from book b JOIN panmai p ON b.b_id = p.b_id 
            JOIN danga d ON b.b_id = d.b_id 
group by b.b_id, title, price -- ������ ���ǵ� ���ƾ� sum�Լ� ��밡��
order by b.b_id;
-- [2]
SELECT DISTINCT b.b_id åID, title ����, price �ܰ� 
   --, p_su �Ǹż���
, (SELECT SUM(p_su) FROM panmai WHERE b_id = b.b_id) ���ǸűǼ�
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id;

-- ����3) �ǸűǼ��� ���� ���� å ���� ��ȸ 
WITH t
AS 
  (
  SELECT b.b_id, title , price, SUM( p_su )  ���ǸűǼ�
 FROM  book b JOIN  panmai p ON b.b_id = p.b_id
              JOIN danga d ON  b.b_id = d.b_id
 GROUP BY   b.b_id, title , price
 ORDER BY  b.b_id
 ), 
 s AS (
 SELECT t.*
   , RANK() OVER( ORDER BY  ���ǸűǼ� DESC ) �Ǹż���
 FROM t
 )
 SELECT s.*
 FROM s
 WHERE �Ǹż��� = 1;

-- 1) TOP-N �м� ���

SELECT t.*
FROM ( 
        SELECT b.b_id, title, price, SUM( p_su  ) ���ǸűǼ�
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id 
        GROUP BY b.b_id, title, price
        ORDER BY ���ǸűǼ� DESC
) t
WHERE ROWNUM BETWEEN 3 AND 5; -- ����
WHERE ROWNUM <= 3;
WHERE ROWNUM = 1;

-- 2) RANK ���� �Լ� ..

WITH t AS (
    SELECT b.b_id, title, price, SUM( p_su  ) ���ǸűǼ�
       , RANK() OVER( ORDER BY SUM( p_su  ) DESC ) �Ǹż���
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id 
    GROUP BY b.b_id, title, price
)
SELECT *
FROM t
WHErE �Ǹż��� BETWEEN 3 AND 5;
WHErE �Ǹż��� <= 3;
WHErE �Ǹż��� = 1;

-- ����4) ���� �ǸűǼ��� ���� ���� å(������ ��������)
--      (  åID, å����, ���� )
SELECT ROWNUM ����, t.*
FROM ( 
    SELECT  p.b_id, title , SUM( p_su  ) �Ǹż���
    FROM panmai p, book b
    WHERE TO_CHAR(p_date, 'YYYY') = 2024 AND b.b_id = p.b_id
    GROUP BY p.b_id, title
    ORDER BY �Ǹż��� DeSC
 ) t 

-- ����5) book ���̺��� �ǸŰ� �� ���� ���� å�� ���� ��ȸ
-- å ���� : 9���� ����
 -- (ANTI JOIN : NOT IN ����)
 SELECT b.b_id, title, price
 FROM book b JOIN danga d ON b.b_id = d.b_id
 WHERE b.b_id NOT IN ( SELECT DISTINCT b_id  FROM panmai );

-- minus ������ SET(����) ������

-- ����6) book ���̺��� �ǸŰ� �� ���� �ִ� å�� ���� ��ȸ
--      ( b_id, title, price  �÷� ��� )
select distinct b.b_id, title, price
FROM book b, panmai p, danga d
where b.b_id = p.b_id AND b.b_id = d.b_id ;

-- EXISTS -- SEMI JOIN
select b.b_id, title, price
from book b JOIN danga d ON b.b_id = d.b_id
where b.b_id in ( select distinct b_id from panmai);

-- ����7) ���� �Ǹ� �ݾ� ��� (���ڵ�, ����, �Ǹűݾ�)
 SELECT g.g_id, g_name,  SUM(p_su) 
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY g.g_id, g_name ;

-- ����8) �⵵, ���� �Ǹ� ��Ȳ ���ϱ�
 SELECT  TO_CHAR( p_date, 'YYYY') p_year, TO_CHAR( p_date, 'MM' ) p_month,   SUM(p_su)
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY  TO_CHAR( p_date, 'YYYY') , TO_CHAR( p_date, 'MM')
 ORDER BY p_year, p_month;

-- ����9) ������ �⵵�� �Ǹ���Ȳ ���ϱ�
panmai : p_su, p_date
gogaek : g_id, g_name

select p_date
from panmai;

select g_name, TO_CHAR(p_date, 'YYYY') p_year , sum(p_su)
from panmai p JOIN gogaek g ON p.g_id = g.g_id
group by g_name, TO_CHAR(p_date, 'YYYY')
order by g_name, p_year ;
-- ������ ���ϱ� : cube ��� ( �հ�, �Ұ� �����ִ� �Լ� )

-- ����10) å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--      ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )
    
    select b.b_id, title, price, sum(p_su) ���ǸűǼ�
        , sum(p_su * price) ���Ǹűݾ�
    FROM book b jOin danga d on b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id
    group by b.b_id, title, price
        having sum(p_su) * price >= 15000
    order by b.b_id;



















