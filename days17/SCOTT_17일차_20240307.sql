-- SCOTT
-- (��) : PL/SQL ��������, ��Ű��

-- ��ǰ ���̺� �ۼ�
CREATE TABLE ��ǰ (
   ��ǰ�ڵ�      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,��ǰ��        VARCHAR2(30)  NOT NULL
  ,������        VARCHAR2(30)  NOT NULL
  ,�Һ��ڰ���     NUMBER
  ,������       NUMBER DEFAULT 0
);

-- �԰� ���̺� �ۼ�
CREATE TABLE �԰� (
   �԰��ȣ      NUMBER PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�԰�����     DATE
  ,�԰����      NUMBER
  ,�԰�ܰ�      NUMBER
);

-- �Ǹ� ���̺� �ۼ�
CREATE TABLE �Ǹ� (
   �ǸŹ�ȣ      NUMBER  PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�Ǹ�����      DATE
  ,�Ǹż���      NUMBER
  ,�ǸŴܰ�      NUMBER
);

-- ��ǰ ���̺� �ڷ� �߰�
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('AAAAAA', '��ī', '���', 100000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('BBBBBB', '��ǻ��', '����', 1500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('CCCCCC', '�����', '���', 600000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('DDDDDD', '�ڵ���', '�ٿ�', 500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
         ('EEEEEE', '������', '���', 200000);
COMMIT;

SELECT * FROM ��ǰ;
-----------------------------------------------------------
����1) �԰� ���̺� ��ǰ�� �԰� �Ǹ� �ڵ����� ��ǰ ���̺��� ��������  update �Ǵ� Ʈ���� ���� + Ȯ��
-- ut_insIpgo
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER
    INSERT ON �԰�
FOR EACH ROW -- �� ���� Ʈ����
BEGIN
    -- �԰� :NEW.��ǰ�ڵ�, :NEW.�԰����
    UPDATE ��ǰ
    SET ������ = ������ + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    --COMMIT/ROLLBACK �ʿ�X
--EXCEPTION
END;
-- Trigger UT_INSIPGO��(��) �����ϵǾ����ϴ�.

-- �԰� ���̺� ������ �Է�
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);
COMMIT ;
-------------------------------------------------------------
SELECT * FROM �԰�;
SELECT * FROM ��ǰ;

����2) �԰� ���̺��� �԰� �����Ǵ� ���    ��ǰ���̺��� ������ ����. 
-- ut_updIpgo
-- �԰���� : 25 :OLD.�԰���� / 30 :NEW.�԰����  
CREATE OR REPLACE TRIGGER ut_updIpgo
AFTER
    UPDATE ON �԰�
FOR EACH ROW -- �� ���� Ʈ����
BEGIN
    -- :NEW.��ǰ�ڵ�, :NEW.�԰����
    UPDATE ��ǰ
    SET ������ = ������ -:OLD.�԰���� + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    --COMMIT/ROLLBACK �ʿ�X
--EXCEPTION
END;

UPDATE �԰� 
SET �԰���� = 30 
WHERE �԰��ȣ = 5;
COMMIT;
------------------------------
--����3) �԰� ���̺��� �԰� ��ҵǾ �԰� ����. ��ǰ���̺��� ������ ����.
-- ut_delIpgo
CREATE OR REPLACE TRIGGER ut_delIpgo
AFTER
    DELETE ON �԰�
FOR EACH ROW 
BEGIN
    -- :NEW.��ǰ�ڵ�, :NEW.�԰����
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰����
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;    
--EXCEPTION
END; 
--
DELETE FROM �԰�
WHERE �԰��ȣ = 5;
COMMIT;
--
SELECT * FROM �԰�;
SELECT * FROM ��ǰ;

-- ����4) �Ǹ����̺� �ǸŰ� �Ǹ� (INSERT)
--       ��ǰ���̺��� �������� ����
-- ut_insPan
CREATE OR REPLACE TRIGGER ut_insPan
BEFORE
    INSERT ON �Ǹ�
FOR EACH ROW -- �� ���� Ʈ����
DECLARE
    vqty ��ǰ.������%TYPE;
BEGIN
    SELECT ������ INTO vqty
    FROM ��ǰ
    WHERE  ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    
    IF vqty < :NEW.�Ǹż��� THEN
        RAISE_APPLICATION_ERROR(-20007, '������ �������� �Ǹ� ����');
    ELSE
        UPDATE ��ǰ
        SET ������ = ������ - :NEW.�Ǹż���
        WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ� ;
    END IF;
    --COMMIT/ROLLBACK �ʿ�X
--EXCEPTION
END; 
--
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
               (1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
               (2, 'AAAAAA', '2004-11-12', 50, 1000000);
COMMIT;

-- ����5) �ǸŹ�ȣ 1   20   �Ǹż��� 5 -> 10
UPDATE �Ǹ�
SET �Ǹż��� = 10
WHERE �ǸŹ�ȣ = 1;
-- ��ǰ ���̺��� ������ ���� Ʈ����
-- AAA          20   - 5    = 15
-- ut_updPan
CREATE OR REPLACE TRIGGER ut_updPan
BEFORE
    INSERT ON �Ǹ�
FOR EACH ROW 
DECLARE
    vqty ��ǰ.������%TYPE;
BEGIN
    SELECT ������ INTO vqty -- 15
    FROM ��ǰ
    WHERE  ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    -- 15 + 5
    IF (vqty + :OLD.�Ǹż���) < :NEW.�Ǹż��� THEN
        RAISE_APPLICATION_ERROR(-20007, '������ �������� �Ǹ� ����');
    ELSE
        UPDATE ��ǰ
        SET ������ = ������ + :OLD.�Ǹż��� - :NEW.�Ǹż���
        WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ� ;
    END IF;
    --COMMIT/ROLLBACK �ʿ�X
--EXCEPTION
END;
--
select * from ��ǰ ;
select * from �Ǹ� ;

-- ����) �ǸŹ�ȣ 1   (AAAAA  10) �Ǹ� ��� (DELETE)
--      ��ǰ���̺� ������ ����
--ut_delPan
CREATE OR REPLACE TRIGGER ut_delPan
AFTER
    DELETE ON �Ǹ�
FOR EACH ROW 
BEGIN

        UPDATE ��ǰ
        SET ������ = ������ + :OLD.�Ǹż��� 
        WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ� ;

--EXCEPTION
END;

DELETE FROM �Ǹ�
WHERE �ǸŹ�ȣ = 1;
--------------------------------------------------------------
-- ��Ű��
--   �� ���� ���Ǵ� ���� procedure, function���� �ϳ��� package��� ������ ����� �� (�ڹ��� package �� ����)
-- DBMS ���
--DBMS_OUTPUT.PUT();
--DBMS_OUTPUT.PUT_LINE();

-- ��Ű���� ���� �κ�
CREATE OR REPLACE PACKAGE employee_pkg 
AS 
    PROCEDURE up_print_ename
    (
        pempno NUMBER
    ); 
    PROCEDURE up_print_sal(pempno NUMBER); 
    FUNCTION uf_age
    (
        prrn VARCHAR2
        , ptype IN NUMBER -- 1(���� ����)  0(������)
    )
    RETURN NUMBER;
END employee_pkg; 
-- Package EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.

-- ��Ű���� ���� �κ�
CREATE OR REPLACE PACKAGE employee_pkg 
AS 
     PROCEDURE up_printename
     (
       p_empno NUMBER
      ); 
     PROCEDURE up_printsal(p_empno NUMBER); 
     FUNCTION uf_age
     (
       prrn IN VARCHAR2 
      ,ptype IN NUMBER 
     )
     RETURN NUMBER;
END employee_pkg;
-- Package EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.
CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS 
   
      procedure UP_PRINTENAME(p_empno number) is 
        l_ename emp.ename%type; 
      begin 
        select ename 
          into l_ename 
          from emp 
          where empno = p_empno; 
       dbms_output.put_line(l_ename); 
     exception 
       when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end UP_PRINTENAME; 
  
   procedure UP_PRINTSAL(p_empno number) is 
     l_sal emp.sal%type; 
   begin 
     select sal 
       into l_sal 
       from emp 
       where empno = p_empno; 
     dbms_output.put_line(l_sal); 
   exception 
     when NO_DATA_FOUND then 
       dbms_output.put_line('Invalid employee number'); 
   end UP_PRINTSAL; 
   
   FUNCTION uf_age
(
   prrn IN VARCHAR2 
  ,ptype IN NUMBER --  1(���� ����)  0(������)
)
RETURN NUMBER
IS
   �� NUMBER(4);  -- ���س⵵
   �� NUMBER(4);  -- ���ϳ⵵
   �� NUMBER(1);  -- ���� ���� ����    -1 , 0 , 1
   vcounting_age NUMBER(3); -- ���� ���� 
   vamerican_age NUMBER(3); -- �� ���� 
BEGIN
   -- ������ = ���س⵵ - ���ϳ⵵    ������������X  -1 ����.
   --       =  ���³��� -1  
   -- ���³��� = ���س⵵ - ���ϳ⵵ +1 ;
   �� := TO_CHAR(SYSDATE, 'YYYY');
   �� := CASE 
          WHEN SUBSTR(prrn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(prrn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(prrn,1,2);
   �� :=  SIGN(TO_DATE(SUBSTR(prrn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (����X)

   vcounting_age := �� - �� +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ��, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ��
                                         WHEN 1 THEN -1
                                         ELSE 0
                                        END;

   IF ptype = 1 THEN
      RETURN vcounting_age;
   ELSE 
      RETURN (vamerican_age);
   END IF;
--EXCEPTION
END uf_age;
  
END employee_pkg; 
--
select name, ssn
    , employee_pkg.uf_age(ssn,1) age
from insa;

--------------------------------------------------------------
-- ���� SQL ****
--------------------------------------------------------------
���� �迭
int [] m ; -- �迭�� ũ�� X
int size = 10;
m = new int[size];
-- ���� SQL(����)
��) �Ϲ����� �Խ��ǿ��� �˻�
    1) �������� �˻� WHERE title LIKE '%�˻���%'
    2) �ۼ���       WHERE writer LIKE '%�˻���%'
    3) ����         WHERE content LIKE '%�˻���%'
    4) ���� & ����  WHERE title LIKE '%�˻���%' OR content LIKE '%�˻���%'
    
-- ���� ������ SQL�� �� ���� ����
-- 1) ���� ����(SQL)�� ����ϴ� 3���� ���
        ��. ������ �ÿ� SQL������ Ȯ������ ���� ���( ���� ���� ����ϴ� ��� )
        ��) WHERE ������...
        ��. PL/SQL �� �ȿ��� DDL���� ����ϴ� ���
        CREATE, ALTER, DROP ��
        ��) ������ Į������ �������� �Խ��� ���̺� ����.
            �ʿ�� ���� ���� ���� �Խ��� ���̺� ����.
        ��. PL/SQL �� �ȿ���
        ALTER SYSTEM/SESSION ��ɾ ����� ���
-- 2) PL/SQL ���� ������ ����ϴ� 2���� ���.
    ��. DBMS_SQL ��Ű�� ����X - ���� �ʿ�� å����
    ��. EXECUTE IMMEDIATE ��  ����O
     ����)
        EXEC[UTE] IMMEDIATE ����������
        [INTO ������,������...]
        [USING [IN/OUT/IN OUT] �Ķ����,�Ķ����...]
-- 3) ��
-- �͸� ���ν��� ����.

DECLARE
    vsql VARCHAR2(1000);
    
    vdeptno     emp.deptno%TYPE;
    vempno    emp.empno%TYPE;
    vename    emp.ename%TYPE;
    vjob      emp.job%TYPE;
    
BEGIN
    vsql := 'SELECT deptno, empno, ename, job';
    vsql := vsql || 'FROM emp';
    vsql := vsql || 'WHERE empno = 7369';

    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob;

    DBMS_OUTPUT.PUT_LINE (vdeptno|| ', ' || vempno || ', ' || vename|| ', ' || vjob );
--EXCEPTION
END ;

-- ���� ���ν��� 2
CREATE OR REPLACE PROCEDURE up_ndsemp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000);
    
    vdeptno     emp.deptno%TYPE;
    vempno    emp.empno%TYPE;
    vename    emp.ename%TYPE;
    vjob      emp.job%TYPE;
    
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || 'FROM emp ';
   -- vsql := vsql || 'WHERE empno = pempno'; X
   -- vsql := vsql || 'WHERE empno = ' || pempno;
    vsql := vsql || 'WHERE empno = ' || pempno;

    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob
            USING IN pempno ;

    DBMS_OUTPUT.PUT_LINE (vdeptno|| ', ' || vempno || ', ' || vename|| ', ' || vjob );
--EXCEPTION
END ;
--Procedure UP_NDSEMP��(��) �����ϵǾ����ϴ�.

CREATE OR REPLACE PROCEDURE up_ndsemp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000);
    
    vdeptno     emp.deptno%TYPE;
    vempno    emp.empno%TYPE;
    vename    emp.ename%TYPE;
    vjob      emp.job%TYPE;
    
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || 'FROM emp ';
   -- vsql := vsql || 'WHERE empno = pempno'; X
   vsql := vsql || 'WHERE empno = : pempno';

    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob;

    DBMS_OUTPUT.PUT_LINE (vdeptno|| ', ' || vempno || ', ' || vename|| ', ' || vjob );
--EXCEPTION
END ;

EXEC UP_NDSEMP( 7369 );

-- ����2. dept ���̺� ���ο� �μ� �߰��ϴ� ���� ���ν���( ���� ���� ��� )
SELECT *
FROM dept ;
--
CREATE OR REPLACE PROCEDURE up_ndsInsDept
(
    pdname  dept.dname%TYPE := NULL
    , ploc  dept.loc%TYPE := NULL
)
IS
    vsql  VARCHAR2(1000);
    vdeptno  dept.deptno%TYPE;
BEGIN
    SELECT MAX( deptno ) +10 INTO vdeptno
    FROM dept;

    vsql := 'INSERT INTO dept( deptno, dname, loc )';
    vsql := vsql || 'values (:vdeptno, :pdname, :ploc )';
    
    EXECUTE IMMEDIATE vsql
    -- into
    USING vdeptno, pdname, ploc;
    
    commit;
    dbms_output.put_line('INSERT ����!!!');
           
END;

EXEC UP_NDSINSDEPT('QC', 'SEOUL');

DELETE FROM dept WHERE deptno = 50;
COMMIT;

-- ����SQL - DDL�� ��� ����

DECLARE
    vtablename VARCHAR2(100);
    vsql VARCHAR2(1000);
BEGIN
    vtablename := 'tbl_board';
    
    vsql := 'CREATE TABLE ' || vtablename ;
    -- vsql := 'CREATE TABLE : vtablename ' ; - using�� ���
    vsql := vsql || '(' ;
    vsql := vsql || ' id NUMBER PRIMARY KEY' ;
    vsql := vsql || ' , name VARCHAR2(20)' ;
    vsql := vsql || ')' ;
    
    EXECUTE IMMEDIATE vsql;
    -- INTO -> �Ѱ��� ���ڵ��� ���
    -- using vtablename;
    
END;
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM tabs;

-- OPEN ~ FOR �� : ���� ���� ���� -> ��������(���� ���� ���ڵ�) + Ŀ�� ó��..
CREATE OR REPLACE PROCEDURE up_ndsSelEmp
(
    pdeptno  emp.deptno%TYPE
)
IS
    vsql  VARCHAR2(2000);
    vcur  SYS_REFCURSOR;    -- Ŀ�� Ÿ������ ���� ���� 9i REF CURSOR
    vrow  emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' where deptno = :pdeptno ';
    
    -- EXECUTE IMMEDIATE stmt INTO X USING �Ķ����...
    -- OPEN ~ FOR ��
    OPEN vcur FOR vsql USING pdeptno ;
    LOOP
        FETCH vcur INTO vrow ;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vrow.empno || ' ' || vrow.ename );
    END LOOP;
    CLOSE vcur;
END;
--Procedure UP_NDSSELEMP��(��) �����ϵǾ����ϴ�.
EXEC UP_NDSSELEMP(30);
EXEC UP_NDSSELEMP(20);
-- emp ���̺��� �˻� ��� ����
-- 1) �˻����� : 1 �μ���ȣ, 2 �����, 3 ��
-- 2) �˻���   : 
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
    psearchCondition NUMBER --1. �μ���ȣ, 2.�����, 3.��
    , psearchWord   VARCHAR2
)
IS
    vsql  VARCHAR2(2000);
    vcur  SYS_REFCURSOR;    -- Ŀ�� Ÿ������ ���� ���� 9i REF CURSOR
    vrow  emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    
    IF psearchCondition = 1 THEN -- �μ���ȣ�� �˻�
     vsql := vsql || ' where deptno = :pdeptno ';
    ELSIF psearchCondition = 2 THEN -- �����
    vsql := vsql || ' where REGEXP_LIKE(ename, :psearWord)'; 
    ELSIF psearchCondition = 3 THEN -- ��
    vsql := vsql || '  where REGEXP_LIKE(job, :psearWord, ''i'')';
    END IF;
    
    
    -- EXECUTE IMMEDIATE stmt INTO X USING �Ķ����...
    -- OPEN ~ FOR ��
    OPEN vcur FOR vsql USING psearchWord ;
    LOOP
        FETCH vcur INTO vrow ;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vrow.empno || ' ' || vrow.ename || '' || vrow.job );
    END LOOP;
    CLOSE vcur;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, '>EMP DATA NOT FOUND...');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, '>OTHER ERROR...');
END;

EXEC UP_NDSSEARCHEMP(1, '20');
EXEC UP_NDSSEARCHEMP(2, 'L');
EXEC UP_NDSSEARCHEMP(3, 's');







