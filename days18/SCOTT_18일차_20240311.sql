-- SCOTT 18일차
-- (월) : 트랜잭션, 암호화, 스케줄러
-- 트랜잭션 처리  ( A + B ) 계좌 이체 
-- 예) 계좌이체
---------------- A      X  -> 출금            실패
---------------- B      Y  <- 입금            성공

-- DML문(I,U,D)    +  LOCK(잠김)       -> 반드시 잠금해제 (COMMIT, ROLLBACK)

-- SCOTT
-- 750204
SELECT USERENV('SESSIONID')
FROM dual;
--
SELECT *
FROM emp
WHERE ename = 'MILLER';
-- job CLERK
UPDATE emp
SET job = 'MANAGER'
WHERE ename = 'MILLER';
--1 행 이(가) 업데이트되었습니다.
ROLLBACK;

-- VIEW
-- PL/SQL : 저장함수, 저장프로시저, 트리거, 패키지 
C O R P
IS
BEGIN
   I
   U
   D
   S
   
   COMMIT;
E
 WHEN THEN
   ROLLBACK;
E;
   























