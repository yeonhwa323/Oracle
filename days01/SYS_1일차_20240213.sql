-- �ּ� ó��        Ctrl + /
-- ��� ����� ���� ��ȸ
-- ���� �밳 ���� ������ ������ ���Ѵ�(����).
-- keyword(�����)�� �빮�ڷ� �Է��ϵ��� ���Ѵ�(�������)
-- ���̺��, �÷����� �ҹ��� ���(����)
-- ������ ( ��, �� ���� ) ����
SELECT *
FROM all_users;  -- ���� ����Ű: Ctrl + Enter, F5

select *
From ALL_USERS;  --> ��ҹ��� ��� ���X

-- ���� �߿� ����� ���� ����, ����, ���� --
-- 1) SCOTT ���� ����, ����, ����
--   (1) SCOTT ���� ���� Ȯ��
SELECT *
FROM all_users;
--   (2) SCOTT ���� ���� p153
--              �� ����Ҽ��ִ� ��� �������� ��Ű��(��ġ����ex:�繰�� ��) ����������.
-- Ora_help - create user �˻� 
 CREATE USER SCOTT IDENTIFIED BY tiger;
 --  (3) SCOTT ���� ��й�ȣ 1234 ����
 ALTER USER SCOTT IDENTIFIED BY tiger;
 --  (4) SCOTT ���� ����
 DROP USER SCOTT CASCADE;

-- SYS �ְ������ ������ CREATE SESSION �����ͺ��̽� ����(����) �ý��� ������  SCOTT �����ο�.
GRANT CREATE SESSION TO SCOTT;

GRANT CREATE SESSION TO student_role;
GRANT student_role TO SCOTT;

GRANT CONNECT, RESOURCE TO SCOTT;

-- DDL( CREATE, DROP, ALTER )
-- CREATE USER, DROP USER, ALTER USER
-- CREATE TABLESPACE, DROP TABLESPACE, ALTER TABLESPACE
-- CREATE ROLE, DROP ROLE, ALTER ROLE

-- ����Ŭ ��ġ �ÿ� �̸� ���ǵ� ��(role) Ȯ���ϴ� ����(sql)�� �ۼ��ϼ���. (32 ��)
SELECT *
FROM dba_roles;

SELECT grantee,privilege 
FROM DBA_SYS_PRIVS 
WHERE grantee='CONNECT'; 

-- SCOTT ���� + ���� ���̺� �߰�
C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql ���� ����

GRANT CONNECT,RESOUCE, UNLIMITED TABLESPACE TO SCOTT IDENTIPED BY tiger;
CONNECT SCOTT/tiger;
CREATE TABLE dept, emp, bonus, salgrade ���̺� ����
INSERT �� - ���ڵ� �߰� + TCL (COMMIT)

SQL> show user
USER is "SCOTT"
SQL>
--[����] SCOTT���� ���� �Ŀ� scott.sql �����ؼ� ������� ���̺��� Ȯ��
SELECT *
FROM tabs;

--
SELECT *
FROM dba_tables;
-- COUNT() ����Ŭ �Լ�
SELECT COUNT(*)
SELECT *
FROM dictionary;

-- SYS
 CREATE USER madang IDENTIFIED BY madang DEFAULT TABLESPACE users TEMPORARY
 TABLESPACE temp PROFILE DEFAULT;
 GRANT CONNECT, RESOURCE TO madang;
 GRANT CREATE VIEW, CREATE SYNONYM TO madang;
 GRANT UNLIMITED TABLESPACE TO madang;
 
 -- madang ���� ���� Ȯ��
SELECT *
FROM dba_users;
FROM all_users;

FROM dba_tables;
FROM all_tables;
FROM user_tables;

-- HR ���� Ȯ�� --
--1) HR ������ ��й�ȣ�� lion���� �����ϰ�
--2) + �� ���� Ŭ�� - HR ����
--3) HR ������ �����ϰ� �ִ� ���̺� ����� ��ȸ...
ALTER USER HR IDENTIFIED BY lion;
ALTER USER HR ACCOUNT UNLOCK;


