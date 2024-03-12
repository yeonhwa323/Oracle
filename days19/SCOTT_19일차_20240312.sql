-- SCOTT 19일차

-- (화) : 트랜잭션, [암호화], 스케줄러

-- 브라우저->   미들서버  ->    DB
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

-- 오라클 암호화/복호화 패키지 제공 : DBMS_OBFUSCATION_TOOLKIT ( 4개의 프로시저 )
-- VARCHAR2 만 암호화 가능 / NUMBER 숫자타입은 암호화 불가

-- 파일탐색기 검색
-- search-ms:displayname=oraclexe의%20검색%20결과&crumb=System.Generic.String%3ADBMSOBTK&crumb=location:C%3A%5Coraclexe

-- CMD 실행
--C:\Users\user>SQLPLUS SYS/123$ AS SYSDBA
--SQL> SHOW USER
-- 파일 끌어가져오기
--SQL> exit

-- 파일탐색기 검색
-- search-ms:displayname=oraclexe의%20검색%20결과&crumb=System.Generic.String%3Aprvtobtk&crumb=location:C%3A%5Coraclexe

-- CMD 실행
-- 파일 끌어가져오기

-- SYS 계정으로 접속
-- SYS -> SCOTT DBMS_OBFUSCATION_TOOLKIT 패키지를 사용할 권한 부여.
GRANT EXECUTE ON DBMS_OBFUSCATION_TOOLKIT TO scott;
--
GRANT EXECUTE ON DBMS_OBFUSCATION_TOOLKIT TO PUBLIC;
-- DBMS_OBFUSCATION_TOOLKIT 패키지의 저장 프로시저를 사용해서
-- 나만의 암호화 로직을 처리하는 패키지를 선언..
-- Crypt - 암호의미
-- encrypt - 암호화
--선언
CREATE OR REPLACE PACKAGE CryptIT
IS
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
END CryptIT;

--몸체
CREATE OR REPLACE PACKAGE BODY CryptIT
IS
   s VARCHAR2(2000);
    
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
            p NUMBER := ((FLOOR(LENGTH(str)/8+0.9))*8); -- 넣는 값은 사람마다 달라질수 있음.
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
-- ㄴ 데이터 임포트 설명























