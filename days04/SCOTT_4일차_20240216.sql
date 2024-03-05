-- SCOTT 
SELECT *
FROM tabs;

SELECT SYSDATE, CURRENT_TIMESTAMP
FROM dual;
--[ dual 설명 ]
SELECT SYSDATE
FROM dual;

DESC dual; -- DUMMY    VARCHAR2(1) 
-- 산술연산자
SELECT 5+3, 5-3, 5*3, 5/3, MOD(5,3)
-- ORA-01476: divisor is equal to zero [0으로 나눌수없음]
SELECT 5/0
SELECT MOD(5,0) -- 5/0
FROM dual;

-- 
SELECT *
FROM emp;
FROM scott.emp;

-- PUBLIC SYNONYM 생성
-- ORA-01031: insufficient privileges [ scott은 생성권한없음 ]
CREATE PUBLIC SYNONYM arirang
FOR  scott.emp;

--[ YY와 RR의 차이점: ]
--  ㄴ RR과 YY는 둘다 년도의 마지막 두자리를 출력해 주지만, 
--  ㄴ 현재 system상의 세기와 나타내고자 하는 년도의 세기를 비교할 했을 때 출력되는 값이 다르다.
--  ㄴ [RR]은
--      ㄴ 시스템상(1900년대)의 년도를 기준으로 하여 이전 50년도에서 이후 49년까지는 기준년도와 가까운 1850년도에서 1949년도까지의 값으로 표현하고, 
--  ㄴ 이 범위를 벗아날 경우 다시 2100년을 기준으로 이전 50년도에서 이후 49년까지의 값을 출력한다.
--
--  ㄴ [YY] 는 무조건 system상의 년도(2000)를 따른다.

SELECT TO_CHAR( SYSDATE, 'CC' ) -- 21세기(2024년도)
FROM dual;

SELECT
    '05/01/10' -- 날짜,[문자열]
    , TO_CHAR( TO_DATE('05/01/10', 'YY/MM/DD'), 'YYYY' ) a_YY -- 2005
    , TO_CHAR( TO_DATE('05/01/10', 'RR/MM/DD'), 'YYYY' ) b_RR -- 2005
FROM dual;

SELECT
    '97/01/10' -- 날짜,[문자열]
    , TO_CHAR( TO_DATE('97/01/10', 'YY/MM/DD'), 'YYYY' ) a_YY -- 2097
    , TO_CHAR( TO_DATE('97/01/10', 'RR/MM/DD'), 'YYYY' ) b_RR -- 1997
FROM dual;
--
SELECT name, ibsadate
FROM insa;
-- ORDER BY 절
-- 1차적으로 부서별로 오름차순 정렬시킨 후
-- 2차 정렬 pay 많이 받는 사람 순으로
SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
ORDER BY 1 ASC, 3 DESC ;
ORDER BY deptno ASC, pay DESC;

-- 
-- [ 오라클 연산자(operator) 정리 ]
-- 1) 비교 연산자 : WHERE 절에서 숫자,날짜,문자 순서, 크기를 비교하는 연산자(오라클 boolean값없음)
--  = != ^= <> < >= <=
--      ㄴ SQL 연산자 ANY, SOME, ALL
--       true, false, null
SELECT ename, sal
FROM emp
WHERE sal>=NULL;
WHERE sal<=1250;
WHERE sal<1250;
WHERE sal>=1250;
WHERE sal!=1250;
WHERE sal=1250;

ANY
SOME
ALL
--p226 질의 4-12
--emp 테이블에서 평균급여보다 많이 받는 사원들의 정보를 조회.
--1. emp 테이블의 평균급여 ? avg() 집계함수, 그룹함수
SELECT AVG( sal+NVL(comm,0)) avg_pay
FROM emp;
-- 2260.416666666666666666666666666666666667
SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= (SELECT AVG( sal+NVL(comm,0)) avg_pay
                          FROM emp);                          
WHERE sal+NVL(comm,0) >= 2260.416666666666666666666666666666666667;

-- [문제]각 부서별 평균 급여보다 많이 받는 사원들의 정보를 조회.
SELECT AVG( sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 10; -- 10번 사원들의 평균:2916.666666666666666666666666666666666667

SELECT AVG( sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 20; -- 20번 사원들의 평균:2258.333333333333333333333333333333333333

SELECT AVG( sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 30; -- 30번 사원들의 평균:1933.333333333333333333333333333333333333

SELECT *
FROM emp
WHERE deptno =10 AND sal+NVL(comm,0) >= 2916.666666666666666666666666666666666667 
UNION
SELECT *
FROM emp
WHERE deptno =20 AND sal+NVL(comm,0) >= 2258.333333333333333333333333333333333333 
UNION
SELECT *
FROM emp
WHERE deptno =30 AND sal+NVL(comm,0) >= 1933.333333333333333333333333333333333333 ;
--
오라클 함수(function) 정리
-- 
오라클 자료형(data type) 정리

-- 30번 부서의 최고 급여보다 많이 받는 사원들의 정보를 조회.
SELECT MAX(sal + NVL(comm,0)) max_pay_30
FROM emp
WHERE deptno = 30;

SELECT *
FROM emp
WHERE sal + NVL(comm,0) > ALL (SELECT sal + NVL(comm,0) max_pay_30
                        FROM emp
                        WHERE deptno = 30);
                        
WHERE sal + NVL(comm,0) > (SELECT MAX(sal + NVL(comm,0)) max_pay_30
                        FROM emp
                        WHERE deptno = 30);

SELECT deptno, ename,empno,job
from emp
WHERE deptno=10 AND job='CLERK';
--
SELECT deptno, ename,empno,job
FROM emp
WHERE deptno=10 OR job='CLERK';
--
SELECT deptno, ename,empno,job
FROM emp
WHERE deptno NOT IN(10,30);

-- P229
WITH temp AS (SELECT sal+NVL(comm,0) pay FROM emp)
SELECT MAX(pay),   MIN(pay),  AVG(pay),  SUM(pay)
FROM temp;
--
SELECT MAX(pay),   MIN(pay),  AVG(pay),  SUM(pay)
FROM (SELECT sal+NVL(comm,0) pay FROM emp);

-- 상관 서브 쿼리 (correlated subquery)
-- [문제1] 사원 전체에서 최고 급여를 받는 사원의 정보를 조회(출력) 사원명, 사원번호, 급여액, 부서번호
SELECT deptno, ename, empno, sal + NVL(comm,0) pay
FROM emp
ORDER BY pay DESC;
--
select max( sal + NVL(comm,0)) max_pay
from emp
where sal + NVL(comm,0) = ( select max( sal + NVL(comm,0)) max_pay
                            from emp);
--
SELECT deptno, ename, empno, sal + NVL(comm,0) pay
FROM emp
WHERE sal + NVL(comm,0) = 5000;

-- [문제2]각 부서별 최고 급여를 받는 사원의 정보를 조회(출력)
-- 
SELECT MAX( sal + NVL(comm,0)) max_pay
from emp
WHERE deptno = 30;
-- [상호연관 서브쿼리]
SELECT deptno, ename, empno, sal + NVL(comm,0) pay
FROM emp p
WHERE sal + NVL(comm,0) = ( SELECT MAX( sal + NVL(comm,0)) max_pay
                            FROM emp c 
                            WHERE deptno = p.deptno);
-- 각 부서별 평균보다 큰 부서원들 정보 조회(출력)
-- ******* ORA-00937: not a single-group group function [집계함수는 일반함수와 함께 사용X]
SELECT deptno,ename,sal
    ,( SELECT  AVG( sal ) FROM emp WHERE deptno=t1.deptno )
FROM emp t1
WHERE sal > (SELECT avg(sal)
            FROM emp t2
            WHERE t2.deptno=t1.deptno)
ORDER BY deptno ASC;

SELECT deptno, ename, sal
   ,  ( SELECT AVG (sal) FROM emp WHERE deptno=t1.deptno )
FROM emp t1
WHERE sal > ( SELECT AVG(sal) FROM emp t2 WHERE t2.deptno=t1.deptno)
ORDER BY deptno ASC;


-- 문제1 내가풂
WITH temp
    AS (SELECT ename, empno, sal + NVL(comm,0) pay, deptno
        FROM emp
        WHERE deptno = 10)
SELECT MAX(pay)
FROM temp t;




