-- SCOTT 14����
SELECT *
FROM tabs;
-- (ȭ) : PL/SQL
---------------------------------------------------------------------
--1. [%TYPE�� ����]
--2. [%ROWTYPE�� ����]
--3. [RECORD�� ����] --
SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno
WHERE empno = 7369 ;
-- 1. �͸����ν��� ���� + �׽�Ʈ ( %TYPE �� ���� : �ϳ��� ���� )
DECLARE
    vdeptno dept.deptno%TYPE ;
    vdname dept.dname%TYPE ;
    vempno emp.empno%TYPE ;
    vename emp.ename%TYPE ;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
        INTO vdeptno, vdname, vempno, vename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369 ;
    
    DBMS_OUTPUT.PUT_LINE( vdeptno || ', ' || vdname
        || ', ' || vempno || ', ' || vename || ', ' || vpay );
--EXCEPTION
END ;

-- 2. �͸����ν��� ���� + �׽�Ʈ ( %ROWTYPE �� ���� : �Ѳ����� ���� )
DECLARE
    vdrow dept%ROWTYPE;
    verow emp%ROWTYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
        INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369 ;
    
    DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname
        || ', ' || verow.empno || ', ' || verow.ename || ', ' || vpay );
--EXCEPTION
END ;
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

-- 3. �͸����ν��� ���� + �׽�Ʈ ( RECORD �� ���� : �ѹ��� �������� �� ���� ��� ���� ������ ���� )
DECLARE
    -- "�μ���ȣ,�μ���,�����ȣ,�����,�޿�" ���ο� �ϳ��� �ڷ��� ����
    -- ( ����� ���� ����ü Ÿ�� ���� )
    TYPE EmpDeptType IS RECORD
    (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    -- ���� ����
    vderow EmpDeptType ;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
        INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno 
    WHERE empno = 7369 ;
    
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );
--EXCEPTION
END ;

-- 4. �͸����ν��� ���� + �׽�Ʈ ( RECORD �� ���� )
-- Ŀ�� ����ؾ� ���� �ذᰡ��.
--ORA-01422: exact fetch returns more than requested number of rows
--*Cause:    The number specified in exact fetch is less than the rows returned.
--*Action:   Rewrite the query or change number of rows requested
DECLARE
    TYPE EmpDeptType IS RECORD
    (
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE,
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        pay NUMBER
    );
    vderow EmpDeptType;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
      --INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno ;
    --WHERE empno = 7369 ;    
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );
--EXCEPTION
END;

-- [ 5) Ŀ��(CURSOR) ]
1) Ŀ�� ? PL/SQL�� ����� �ȿ��� ����Ǵ� SELECT�� �ǹ�
2) Ŀ���� 2���� ����
 ��. ������ Ŀ�� : SELECT���� ���� ����� 1��, FOR �� SELECT ��
    (�ڵ�)
 ��. ����� Ŀ�� : SELECT���� ���� ����� ���� ��
    (1) CURSOR ���� - ������ SELECT �� �ۼ�
    (2) OPEN       - �ۼ��� SELECT ���� ����Ǵ� ����
    (3) FETCH   - Ŀ���� ���� ���� ���� ���ڵ� �о�ͼ� ó������
        - LOOP ��(�ݺ���) ���
         [ Ŀ�� �Ӽ��� ��� ]
         %ROWCOUNT �Ӽ�   : Ŀ�� ���ο� ���� ����(����� ��)
         %FOUND �Ӽ�      : Ŀ�� ���ο� FETCH �� �ڷᰡ ������ true, ������ false
         %NOTFOUND �Ӽ�   : Ŀ�� ���ο� FETCH �� �ڷᰡ ������ false, ������ true
         %ISOPEN �Ӽ�     : Ŀ���� OPEN �����̸� true ��ȯ(������ Ŀ���� �׻� false)

    (4) CLOSE

-- ��)
SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno ;
-- [����� Ŀ�� + �͸����ν��� �ۼ�. �׽�Ʈ]
DECLARE
     TYPE EmpDeptType IS RECORD
    (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    vderow EmpDeptType;
    -- 1) Ŀ�� ����
    CURSOR edcursor IS (
            SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
            FROM dept d JOIN emp e ON d.deptno = e.deptno 
        );
BEGIN
    -- 2) Ŀ�� OPEN
    OPEN edcursor;
    -- 3) FETCH
    -- while(true){ if() break; }
    LOOP
        FETCH edcursor INTO vderow;
        EXIT WHEN edcursor%NOTFOUND;
        DBMS_OUTPUT.PUT(edcursor%ROWCOUNT || ' : ' ) ;
        DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );
                
    END LOOP;
    -- 4) Ŀ�� CLOSE
    CLOSE edcursor;
--EXCEPTION
END;
---------------------------------------

-- ��. [�Ͻ��� Ŀ�� + �͸����ν��� �ۼ�] FOR�� ���
DECLARE
     TYPE EmpDeptType IS RECORD
    (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    vderow EmpDeptType;
    -- 1) Ŀ�� ����
    CURSOR edcursor IS (
            SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
            FROM dept d JOIN emp e ON d.deptno = e.deptno 
        );
BEGIN
    --FOR i IN [REVERSE]1..10
    FOR vderow IN edcursor
    LOOP
        DBMS_OUTPUT.PUT(edcursor%ROWCOUNT || ' : ' ) ;
        DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );              
    END LOOP;
    
--EXCEPTION
END;

-- ��. [�Ͻ��� Ŀ�� + �͸����ν��� �ۼ�] FOR�� ���
--- FOR ���� �ݺ��Ǵ� Ŀ������ ���� �������� �ʾƵ��ȴ�. DECLARE�� ���� �ʿ����

BEGIN
    FOR vderow IN (
            SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
            FROM dept d JOIN emp e ON d.deptno = e.deptno 
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );              
    END LOOP;
    
--EXCEPTION
END;

-- [ ���� ���ν���(STORED PROCEDURE) ]
CREATE OR REPLACE PROCEDURE ���ν�����
(
)
IS
BEGIN
    ���� ��
EXCEPTION
    ���� ó�� ��
END;

-- �͸� ���ν���
CREATE OR REPLACE PROCEDURE ���ν�����
(
    �Ű�����(argument, parameter ),
    �Ű�����(argument, parameter ),
    p
)
IS
    v;
    v;
BEGIN    
EXCEPTION
END;

-- ���� ���ν����� �����ϴ� 3���� ���
--1) EXECUTE ������ ����.
--2) �͸����ν������� ȣ���ؼ�
--3) �� �ٸ� �������ν������� ȣ���ؼ� ����

-- ���������� ����ؼ� ���̺� ����
CREATE TABLE tbl_emp
AS
(SELECT * FROM emp);
--
SELECT *
FROM tbl_emp ;
-- ����(stored) ���ν��� :    up_ = userprocedue_ �ǹ̷� �����ϰڴ�
DELETE FROM tbl_emp
WHERE empno = 9999;

--
CREATE OR REPLACE PROCEDURE up_deltblemp
(
    -- pempno NUMBER(4) X -> �ڸ���(4) �����ʴ´�! (���)
    -- pempno NUMBER    O 
    -- pempno IN tbl_emp.empno%TYPE
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
    --ROLLBACK;
END;
-- Procedure UP_DELTBLEMP��(��) �����ϵǾ����ϴ�.
-- [UP_DELTBLEMP ���� ] - 3����
--1) execute  �� ����
-- PLS-00306: wrong number or types of arguments in call to 'UP_DELTBLEMP'
EXECUTE UP_DELTBLEMP ; X
EXECUTE UP_DELTBLEMP(7369);
EXECUTE UP_DELTBLEMP(pempno=>7499) ;
SELECT *
FROM tbl_emp;

--2) �͸����ν������� ȣ���ؼ� ����
-- DECLARE
BEGIN
    UP_DELTBLEMP(7566);
END;
--3) �� �ٸ� �������ν������� ȣ���ؼ� ����
CREATE OR REPLACE PROCEDURE up_DELTBLEMP_test
AS
BEGIN
    UP_DELTBLEMP(7521);
END up_DELTBLEMP_test ;
-- Procedure UP_DELTBLEMP_TEST��(��) �����ϵǾ����ϴ�.
EXEC up_DELTBLEMP_test;

-- ����1) dept -> tbl_dept ���̺� ����
CREATE TABLE tbl_dept
AS 
(SELECT * FROM dept);
-- ����2) tbl_dept ���̺� deptno �÷��� PK �������� ����.
ALTER TABLE tbl_dept
ADD CONSTRAINT PK_TBLDEPT_DEPTNO PRIMARY KEY(deptno);
-- Table TBL_DEPT��(��) ����Ǿ����ϴ�.

-- ����3) ����� Ŀ�� + tbl_dept ���̺��� SELECT ���� ���ν��� ����
-- ����
-- up_seltbldept
-- �Ű����� x, ������ ����� Ŀ�� ����
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
   vdrow tbl_dept%ROWTYPE;
   CURSOR dcursor IS (
                         SELECT deptno, dname, loc
                         FROM tbl_dept
                       );
BEGIN 
   OPEN dcursor; 
   LOOP
     FETCH dcursor INTO vdrow; 
     EXIT WHEN dcursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( dcursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
      || ', ' ||  vdrow.loc);  
   END LOOP; 
   CLOSE dcursor;
--EXCEPTION
END;

EXEC UP_SELTBLDEPT;

-- ����4) ���ο� �μ��� �߰��ϴ� ���� ���ν���
--  deptno      ������
--  dname, loc
select *
from user_sequences;
-- 4-1) seq_deptno ������ ����  50/10/NOCYCLE/NOĳ��/90
CREATE SEQUENCE seq_deptno
INCREMENT BY 10
START WITH 50
MAXVALUE 90
NOCYCLE
NOCACHE;
-- Sequence SEQ_DEPTNO��(��) �����Ǿ����ϴ�.
CREATE OR REPLACE PROCEDURE UP_INSTBLDEPT
(
    pdname IN tbl_dept.dname%TYPE := null
    , ploc IN tbl_dept.loc%TYPE DEFAULT NULL
)
IS
    --vdeptno tbl_dept.deptno%TYPE;
BEGIN
--    SELECT MAX(deptno)+1 INTO vdeptno
--    FROM tbl_dept;
--    vdeptno := vdeptno + 10;
    
--    INSERT INTO tbl_dept(deptno, dname, loc )
--    values(vdeptno, pdname, ploc);

    INSERT INTO tbl_dept (deptno, dname, loc)
    values (seq_deptno.nextval,pdname,ploc);
    commit;
--EXCEPTION
END;
-- Procedure UP_INSTBLDEPT��(��) �����ϵǾ����ϴ�.   

--EXEC UP_SELTBLDEPT;
EXEC UP_INSTBLDEPT('QC', 'SEOUL');
EXEC UP_INSTBLDEPT(ploc=>'SEOUL', pdname=>'QC');

EXEC UP_INSTBLDEPT(pdname=>'QC2');
EXEC UP_INSTBLDEPT(ploc=>'SEOUL');
EXEC UP_INSTBLDEPT;
--
SELECT *
FROM tbl_dept;

-- ����) up_seltbldept, up_instbldept
--  [ up_updtbldept ]
EXEC up_updtbldept(50, 'X', 'Y');   --dname, loc
EXEC up_updtbldept(pdeptno=>50, pdname=>'QC3'); --loc
EXEC up_updtbldept(pdeptno=>50, ploc=>'SEOUL'); --dname

-- ��.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
  vdname tbl_dept.dname%TYPE;
  vloc   tbl_dept.loc%TYPE;
BEGIN
    -- ���� ���� ���� dname, loc
    SELECT dname, loc INTO vdname, vloc
    FROM tbl_dept
    WHERE deptno = pdeptno;
    
    IF pdname IS NULL AND ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = vdname, loc = vloc
       WHERE deptno = pdeptno;
    ELSIF pdname IS NULL THEN
       UPDATE tbl_dept
       SET dname = vdname, loc = ploc
       WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = pdname, loc = vloc
       WHERE deptno = pdeptno;    
    ELSE
      UPDATE tbl_dept
       SET dname = pdname, loc = ploc
       WHERE deptno = pdeptno; 
    END IF;    
    COMMIT;
-- EXCEPTION
END;

-- ��.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
BEGIN
    IF pdname IS NULL AND ploc IS NULL THEN
    ELSIF pdname IS NULL THEN
       UPDATE tbl_dept
       SET loc = ploc
       WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = pdname
       WHERE deptno = pdeptno;    
    ELSE
       UPDATE tbl_dept
       SET dname = pdname, loc = ploc
       WHERE deptno = pdeptno; 
    END IF;    
    COMMIT;
-- EXCEPTION
END;

-- ��.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
BEGIN
    
       UPDATE tbl_dept
       SET dname  = NVL(pdname,dname)
            , loc = CASE
                        WHEN ploc IS NULL THEN loc
                        ELSE ploc
                    END
       WHERE deptno = pdeptno; 
  
    COMMIT;
-- EXCEPTION
END;
-- Procedure UP_UPDTBLDEPT��(��) �����ϵǾ����ϴ�.

-- Ǯ�� ��) UP_SELTBLDEPT ��� �μ� ��ȸ...+����� Ŀ��
SELECT * FROM tbl_emp ; �μ���ȣ�� �Ű�����
-- �ش�Ǵ� �μ����鸸 ��ȸ�ϴ� ���� ���ν��� �ۼ�.
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
   verow tbl_emp%ROWTYPE;
   CURSOR ecursor IS (
                         SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL(pdeptno, 10)
                       );
BEGIN 
   OPEN ecursor; 
   LOOP
     FETCH ecursor INTO verow; 
     EXIT WHEN ecursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( ecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP; 
   CLOSE ecursor;
--EXCEPTION
END;
-- Procedure UP_SELTBLEMP��(��) �����ϵǾ����ϴ�.
EXEC UP_SELTBLEMP;
EXEC UP_SELTBLEMP(30);

-- Ǯ�� ��) UP_SELTBLDEPT ��� �μ� ��ȸ...+����� Ŀ��
-- �ش�Ǵ� �μ����鸸 ��ȸ�ϴ� ���� ���ν��� �ۼ�.
-- [ Ŀ�� �Ķ���͸� �̿��ϴ� ��� ]
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
   verow tbl_emp%ROWTYPE;
   CURSOR ecursor( cdeptno tbl_emp.deptno%TYPE ) IS (
                         SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL( cdeptno, 10)
                       );
BEGIN 
   OPEN ecursor( pdeptno ); 
   LOOP
     FETCH ecursor INTO verow; 
     EXIT WHEN ecursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( ecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP; 
   CLOSE ecursor;
--EXCEPTION
END;

-- Ǯ�� ��) UP_SELTBLDEPT ��� �μ� ��ȸ...+����� Ŀ��
-- �ش�Ǵ� �μ����鸸 ��ȸ�ϴ� ���� ���ν��� �ۼ�.
-- [ FOR �� �̿��ϴ� ���� ]
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS 
BEGIN 
    FOR verow IN (       SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL( pdeptno, 10)
                       )
    LOOP
    DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);
    END LOOP;
--EXCEPTION
END;

-- ����) tbl_dept ���̺��� ���ڵ� �����ϴ� up_deltbldept ����
--          ���ν����� �ۼ�, 50, 60, 70, 80 ����
--          ( ������ �μ���ȣ�� �Ű������� �޾ƾ� �ȴ�. )
EXEC up_deltbldept(50);
EXEC up_deltbldept(60);
EXEC up_deltbldept(70);
EXEC up_deltbldept(80);
EXEC up_deltbldept(90);
SELECT * FROM tbl_dept;

CREATE OR REPLACE PROCEDURE up_deltbldept
(
    pdeptno NUMBER
)
IS
BEGIN
    DELETE FROM tbl_dept
    where deptno = pdeptno ;
    commit ;
--EXCEPTION
END;

-- [ ���� ���ν��� ]
-- �Է¿� �Ű����� IN 
-- ��¿� �Ű����� OUT
-- ��/��¿� �Ű����� IN OUT
SELECT  num, name, ssn -- 770221-1****** -- OUT
FROM insa
WHERE num = 1001; -- IN
--
CREATE OR REPLACE PROCEDURE up_selinsa --********����
(
     pname OUT insa.name%TYPE
    , pssn OUT VARCHAR2
)
IS
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    SELECT  name, ssn into vname, vssn
    FROM insa
    ;
    
    pname := vname;
    prrn := SUBSTR(vssn, 1, 8) || '******' ;

--EXCEPTION
END;
DECLARE
    vname insa.name%TYPE;
    vrrn  VARCHAR2(14);
BEGIN
    UP_SELINSA(1001, vname, vrrn);
    DBMS_OUTPUT.PUT_LINE(vname || ' , ' || vrrn );
--EXCEPTION
END;

-- IN/OUT ����¿� �Ķ����(�Ű�����)
-- ��) �ֹε�Ϲ�ȣ 14�ڸ��� �Է¿� �Ű�������...
--     ���ڸ� 6�ڸ���       ��¿� �Ű������� ���.
CREATE OR REPLACE PROCEDURE up_rrn
(
    prrn IN OUT VARCHAR2 -- VARCHAR2(ũ��)->�Ķ���Ϳ��� ����X
)
IS
BEGIN
    prrn := SUBSTR(prrn, 1, 6);
--EXCEPTION
END;
-- Procedure UP_RRN��(��) �����ϵǾ����ϴ�.
DECLARE
    vrrn VARCHAR2(14) := '761230-1700001';
BEGIN
    UP_RRN(vrrn);
    DBMS_OUTPUT.PUT_LINE( vrrn );
END;

-- ���� �Լ�(Stored Function)
-- �ڹ� �޼���
public static void method1() { -- ���� ���ν���(����Ŭ)
    return 1000;               -- ���� �Լ�
}
-- ���ϰ��� ������ ���� ���ν��� / �Լ� ����
-- ���� �Լ�(Stored Function)
[����]
CREATE OR REPLACE PROCEDURE �������ν�����
(
    p �Ķ����,
    p �Ķ����,
)
RETURN �����ڷ���
IS
    v ������;
    v ������;
BEGIN

        RETURN (���ϰ�);
EXCEPTION
END;
-- ����1) ���� �Լ� ( �ֹε�Ϲ�ȣ�� �Ű����� ����/���� ���ڿ� ��ȯ�ϴ� �Լ� )
SELECT num, name, ssn
    , DECODE( MOD(SUBSTR(ssn, -7, 1),2),1,'����','����') gender  --�ֹε�Ϲ�ȣ�� ����ؼ� ���� ���
 --   , SCOTT.UF_GENDER(ssn) gender
    , UF_GENDER( ssn ) GENDER
    , SCOTT.UF_AGE(ssn, 0) ������
    , SCOTT.UF_AGE(ssn, 1) ���³���
FROM insa;
-- up_�������ν�����
-- uf_�����Լ���
CREATE OR REPLACE FUNCTION uf_gender
(
    prrn IN VARCHAR2
)
RETURN VARCHAR2    --�����ڷ���
IS
    vgender VARCHAR2(6);
BEGIN
    IF MOD( SUBSTR(prrn,-7,1), 2) = 1 THEN vgender := '����';
    ELSE
        vgender := '����';
    END IF;

    RETURN (vgender) ;
--EXCEPTION
END;
-- Function UF_GENDER��(��) �����ϵǾ����ϴ�.
*.sql content:age
*.sql C:\E\Sist\Class\Workspace\OracleClass\ content:AGE 

-- 
CREATE OR REPLACE FUNCTION uf_age
(
    prrn VARCHAR2
    , ptype IN NUMBER -- 1(���� ����)  0(������)
)
RETURN NUMBER
IS 
    �� NUMBER(4); -- ���س⵵
    �� NUMBER(4); -- ���ϳ⵵
    �� NUMBER(4); -- ���� ���� ����  -1,0,1
    vcounting_age NUMBER(3); -- ���³���
    vamerican_age NUMBER(3); -- ������
BEGIN
    -- ������ = ���س⵵ - ���ϳ⵵     ������������X -1 ����.
    --       = ���³��� -1
    -- ���³��� = ���س⵵ - ���ϳ⵵ +1 ;
    �� := TO_DATE(SYSDATE, 'YYYY') ;
    �� := CASE
          WHEN SUBSTR(prrn, 8, 1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(prrn, 8, 1) IN (3,4,7,8) THEN 2000
          ELSE 1800
         END + SUBSTR(prrn, 1, 2);
    �� := SIGN(TO_DATE(SUBSTR(prrn,3,4), 'MMDD') - TRUNC(SYSDATE)) ; -- 1(���Ͼ�����) 0(���û���) -1(��������)
    
    vcounting_age := �� - �� +1; -- ���³���
    vamerican_age := vcounting_age -1 + CASE ��
                                        WHEN 1 THEN -1
                                        ELSE 0
                                        END ;
    IF ptype =1 THEN
        return vcounting_age;
    ELSE
        return vamerican_age;
    END IF;
    
--EXCEPTION
END; -- *******************����

-- ��) �ֹε�Ϲ�ȣ->1998.01.20(ȭ) ������ ���ڿ��� ��ȯ�ϴ� �����Լ� �ۼ�.�׽�Ʈ
SELECT name, ssn
    , SCOTT.UF_BIRTH( ssn ) --'1998.01.20(ȭ)'
FROM insa;
--
CREATE OR REPLACE FUNCTION uf_birth
(
    prrn VARCHAR2 
)
RETURN VARCHAR2
IS
    vcentry NUMBER(2);   --19, 20, 18
    vbirth VARCHAR2(20); --'1998.01.20(ȭ)'
BEGIN
    -- 770221-1022432
    vbirth := SUBSTR(prrn, 1, 6); --
    vcentry := CASE
                WHEN SUBSTR(prrn, -7, 1) IN (1,2,5,6) THEN 19
                WHEN SUBSTR(prrn, -7, 1) IN (3,4,7,8) THEN 20
                ELSE 18
               END;
    vbirth := vcentry || vbirth;    -- '19770221'
    vbirth := TO_CHAR( TO_DATE( vbirth, 'YYYYMMDD' ), 'YYYY.MM.DD(DY)');
    RETURN vbirth;
--EXCEPTION
END;
-- Function UF_BIRTH��(��) �����ϵǾ����ϴ�.

-- [����] 
SELECT POWER(2,3), POWER(2,-3)
      , SCOTT.UF_POWER(2,3), SCOTT.UF_POWER(2,-3)
FROM dual;
--
public static double pow(int n, int m) {
    double result = 1;
    // if( m<0)  exp =  -1 * m;
    int exp = Math.abs(m);
    for (int i = 0; i < exp ; i++) {
        result *= n;
    }
    return m<0 ? 1/result: result;
}
--
CREATE OR REPLACE FUNCTION uf_power
(  
  pn NUMBER
  , pm NUMBER
)
RETURN NUMBER
IS
  vresult NUMBER := 1;
  vexp NUMBER;
BEGIN   
    vexp := ABS(pm); 
    FOR i IN 1 .. vexp
    LOOP
       vresult := vresult * pn;
    END LOOP; 
    IF pm<0 THEN
      RETURN 1/vresult; 
    ELSE
      RETURN vresult;
    END IF;  
--EXCEPTION
END;










