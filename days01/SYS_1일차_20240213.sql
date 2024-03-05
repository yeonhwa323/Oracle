-- 주석 처리        Ctrl + /
-- 모든 사용자 계정 조회
-- 절은 대개 줄을 나누어 쓰도록 권한다(권장).
-- keyword(예약어)는 대문자로 입력하도록 권한다(권장사항)
-- 테이블명, 컬럼명은 소문자 사용(권장)
-- 가독성 ( 탭, 줄 맞춤 ) 권장
SELECT *
FROM all_users;  -- 실행 단축키: Ctrl + Enter, F5

select *
From ALL_USERS;  --> 대소문자 섞어도 상관X

-- 수업 중에 사용할 계정 생성, 수정, 삭제 --
-- 1) SCOTT 계정 생성, 수정, 삭제
--   (1) SCOTT 계정 유무 확인
SELECT *
FROM all_users;
--   (2) SCOTT 계정 생성 p153
--              ㄴ 사용할수있는 모든 계정명의 스키마(비치물건ex:사물함 등) 만들어놔야함.
-- Ora_help - create user 검색 
 CREATE USER SCOTT IDENTIFIED BY tiger;
 --  (3) SCOTT 계정 비밀번호 1234 수정
 ALTER USER SCOTT IDENTIFIED BY tiger;
 --  (4) SCOTT 계정 삭제
 DROP USER SCOTT CASCADE;

-- SYS 최고관리자 계정이 CREATE SESSION 데이터베이스 접속(연결) 시스템 권한을  SCOTT 계정부여.
GRANT CREATE SESSION TO SCOTT;

GRANT CREATE SESSION TO student_role;
GRANT student_role TO SCOTT;

GRANT CONNECT, RESOURCE TO SCOTT;

-- DDL( CREATE, DROP, ALTER )
-- CREATE USER, DROP USER, ALTER USER
-- CREATE TABLESPACE, DROP TABLESPACE, ALTER TABLESPACE
-- CREATE ROLE, DROP ROLE, ALTER ROLE

-- 오라클 설치 시에 미리 정의된 롤(role) 확인하는 쿼리(sql)을 작성하세요. (32 롤)
SELECT *
FROM dba_roles;

SELECT grantee,privilege 
FROM DBA_SYS_PRIVS 
WHERE grantee='CONNECT'; 

-- SCOTT 계정 + 샘플 테이블 추가
C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql 샘플 파일

GRANT CONNECT,RESOUCE, UNLIMITED TABLESPACE TO SCOTT IDENTIPED BY tiger;
CONNECT SCOTT/tiger;
CREATE TABLE dept, emp, bonus, salgrade 테이블 생성
INSERT 문 - 레코드 추가 + TCL (COMMIT)

SQL> show user
USER is "SCOTT"
SQL>
--[문제] SCOTT으로 접속 후에 scott.sql 실행해서 만들어진 테이블을 확인
SELECT *
FROM tabs;

--
SELECT *
FROM dba_tables;
-- COUNT() 오라클 함수
SELECT COUNT(*)
SELECT *
FROM dictionary;

-- SYS
 CREATE USER madang IDENTIFIED BY madang DEFAULT TABLESPACE users TEMPORARY
 TABLESPACE temp PROFILE DEFAULT;
 GRANT CONNECT, RESOURCE TO madang;
 GRANT CREATE VIEW, CREATE SYNONYM TO madang;
 GRANT UNLIMITED TABLESPACE TO madang;
 
 -- madang 계정 생성 확인
SELECT *
FROM dba_users;
FROM all_users;

FROM dba_tables;
FROM all_tables;
FROM user_tables;

-- HR 계정 확인 --
--1) HR 계정의 비밀번호를 lion으로 수정하고
--2) + 새 접속 클릭 - HR 접속
--3) HR 계정이 소유하고 있는 테이블 목록을 조회...
ALTER USER HR IDENTIFIED BY lion;
ALTER USER HR ACCOUNT UNLOCK;


