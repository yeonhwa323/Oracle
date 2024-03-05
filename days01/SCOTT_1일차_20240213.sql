-- [문제] 접속자의 소유한 테이블목록을 조회하는 쿼리
SELECT *
FROM dba_tables;
FROM all_tables; -- 데이타 사전, 뷰(view)
FROM user_tables;

-- [문제] tabs ?
-- Data dictionary(자료사전==데이터 사전==데이터 딕셔너리) 이란 ?
--          ㄴ 테이블, 뷰

-- [문제] dept 테이블 정보를 조회하는 쿼리 (계정명: scott)
SELECT *
FROM scott.dept;

-- [문제] emp (사원) 테이블 정보를 조회하는 쿼리
SELECT *
FROM emp;






