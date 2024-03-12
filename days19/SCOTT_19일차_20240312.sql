-- SCOTT 19����

-- (ȭ) : Ʈ�����, [��ȣȭ], �����ٷ�

-- ������->   �̵鼭��  ->    DB
--         <-           <-

CREATE TABLE tbl_member
(
    id VARCHAR2(20)     PRIMARY KEY
    , password VARCHAR2(20)
);

-- 1. INSERT INTO tbl_member ( id, password ) VALUES ('hong', '1234');
-- 2.
INSERT INTO tbl_member ( id, password ) VALUES ('hong', CryptIT.encrypt('1234', 'TEST') );
INSERT INTO tbl_member ( id, password ) VALUES ('kenik', CryptIT.encrypt('kenik', 'TEST') );

select *
from tbl_member;
--
ROLLBACK;
--
SELECT t.*
        , cryptit.decrypt( t.password, 'test')
FROM tbl_member t;

-- ����Ŭ ��ȣȭ/��ȣȭ ��Ű�� ���� : DBMS_OBFUSCATION_TOOLKIT ( 4���� ���ν��� )
-- VARCHAR2 �� ��ȣȭ ���� / NUMBER ����Ÿ���� ��ȣȭ �Ұ�

-- ����Ž���� �˻�
-- search-ms:displayname=oraclexe��%20�˻�%20���&crumb=System.Generic.String%3ADBMSOBTK&crumb=location:C%3A%5Coraclexe

-- CMD ����
--C:\Users\user>SQLPLUS SYS/123$ AS SYSDBA
--SQL> SHOW USER
-- ���� ���������
--SQL> exit

-- ����Ž���� �˻�
-- search-ms:displayname=oraclexe��%20�˻�%20���&crumb=System.Generic.String%3Aprvtobtk&crumb=location:C%3A%5Coraclexe

-- CMD ����
-- ���� ���������

-- SYS �������� ����
-- SYS -> SCOTT DBMS_OBFUSCATION_TOOLKIT ��Ű���� ����� ���� �ο�.
GRANT EXECUTE ON DBMS_OBFUSCATION_TOOLKIT TO scott;
--
GRANT EXECUTE ON DBMS_OBFUSCATION_TOOLKIT TO PUBLIC;
-- DBMS_OBFUSCATION_TOOLKIT ��Ű���� ���� ���ν����� ����ؼ�
-- ������ ��ȣȭ ������ ó���ϴ� ��Ű���� ����..
-- Crypt - ��ȣ�ǹ�
-- encrypt - ��ȣȭ
--����
CREATE OR REPLACE PACKAGE CryptIT
IS
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
END CryptIT;

--��ü
CREATE OR REPLACE PACKAGE BODY CryptIT
IS
   s VARCHAR2(2000);
    
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
            p NUMBER := ((FLOOR(LENGTH(str)/8+0.9))*8); -- �ִ� ���� ������� �޶����� ����.
        BEGIN
            DBMS_OBFUSCATION_TOOLKIT.DESEncrypt(
               input_string => RPAD(str,p)
                ,key_string => RPAD(HASH,8,'#')
                ,encrypted_string => s
            );
            RETURN s;
        END;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
        BEGIN
            DBMS_OBFUSCATION_TOOLKIT.DESDecrypt(
               input_string => str
                ,key_string => RPAD(HASH,8,'#')
                ,decrypted_string => s
            );
            RETURN TRIM(s);
        END;    

END CryptIT;

--
-- 1
CREATE TABLE tbl_dept
AS
( SELECT *  FROM dept WHERE 1=0 );
-- 2.
ALTER TABLE tbl_dept
ADD CONSTRAINT PK_TBLDEPT_DEPTNO PRIMARY KEY( deptno );
-- 3.
SELECT *  FROM tbl_dept;
-- �� ������ ����Ʈ ����























