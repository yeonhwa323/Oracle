-- SCOTT
SELECT *
FROM tabs;

-- [조인( JOIN )]
--                  관계
-- dept(부서) 1    소속관계    0∈ emp(사원)
-- deptno 10~40                 deptno 참조
-- 부모table                     자식table

-- [문제] 사원 정보를 출력( 부서번호, 부서명, 사원명, 입사일자 )
-- dept : deptno, dname, loc
-- emp : deptno, empno, ename, sal, comm, job, hiredate
-- [1]
-- ORA-00918: column ambiguously defined
SELECT dept.deptno, dname, ename, hiredate --, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno; -- 조인 조건절
-- [2] 100% 같은 조인 조건절
SELECT dept.deptno, dname, ename, hiredate --, emp.deptno
FROM emp JOIN dept ON emp.deptno = dept.deptno; -- 조인 조건절
--------------------------------------------------------------
-- 오늘 수업 --
--------------------------------------------------------------
-- TO_CHAR(NUMBER): 숫자 -> 문자 변환
-- [TO_CHAR(DATE)  : 날짜 -> 문자 변환]
SELECT SYSDATE
--    , TO_CHAR(SYSDATE, 'CC')  -- 21세기, 년, 월, 일 D DD DDD, 월일, 요일
--    , TO_CHAR(SYSDATE, 'DDD') -- 51일
    
    , TO_CHAR(SYSDATE, 'WW') -- 08  년중 몇번째 주 
    , TO_CHAR(SYSDATE, 'W')  -- 3   달중 몇번째 주
    , TO_CHAR(SYSDATE, 'IW') -- 08  1년중 몇째주
FROM dual;

SELECT 
    TO_CHAR(TO_DATE('2024.01.01'), 'WW')    
    ,TO_CHAR(TO_DATE('2024.01.02'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.03'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.04'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.05'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.06'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.07'), 'WW')   
    ,TO_CHAR(TO_DATE('2024.01.08'), 'WW') -- 02 둘째주 월요일  
    ,TO_CHAR(TO_DATE('2024.01.14'), 'WW') -- 02 둘째주 일요일  
    ,TO_CHAR(TO_DATE('2024.01.15'), 'WW') -- 03 셋째주 월요일  
    -- 1~7 한주로 끊어짐
FROM dual;

SELECT 
    TO_CHAR(TO_DATE('2022.01.01'), 'IW')  -- ISO 표준 주 월~일까지 1주. 
    ,TO_CHAR(TO_DATE('2022.01.02'), 'IW') 
    ,TO_CHAR(TO_DATE('2022.01.03'), 'IW')  
    ,TO_CHAR(TO_DATE('2022.01.04'), 'IW')   
    ,TO_CHAR(TO_DATE('2022.01.05'), 'IW')   
    ,TO_CHAR(TO_DATE('2022.01.06'), 'IW')   
    ,TO_CHAR(TO_DATE('2022.01.07'), 'IW')   
    ,TO_CHAR(TO_DATE('2022.01.08'), 'IW')  
    ,TO_CHAR(TO_DATE('2022.01.14'), 'IW')  
    ,TO_CHAR(TO_DATE('2022.01.15'), 'IW')   
FROM dual;
   
SELECT
    TO_CHAR( SYSDATE, 'BC')
    ,TO_CHAR( SYSDATE, 'Q') -- 1분기(1~3달) 2분기(4~6달) 3분기(7~9달) 4분기(10~12달)
FROM dual;

SELECT
    TO_CHAR( SYSDATE, 'HH')
    , TO_CHAR( SYSDATE, 'HH24')
    
    , TO_CHAR( SYSDATE, 'MI')    
    , TO_CHAR( SYSDATE, 'SS')  
    
    , TO_CHAR( SYSDATE, 'DY')    
    , TO_CHAR( SYSDATE, 'DAY')

    , TO_CHAR( SYSDATE, 'DL')    --LONG 2024년 2월 20일 화요일
    , TO_CHAR( SYSDATE, 'DS')    --SHORT 2024/02/20
FROM dual;

SELECT ename, hiredate
    , TO_CHAR(hiredate, 'DL')
    , TO_CHAR( SYSDATE, 'TS') -- 오후 3:50:12
    
    , TO_CHAR( CURRENT_TIMESTAMP, 'HH24:MI:SS.FF3' )
FROM emp;
--
-- TO_CHAR() 날짜, 숫자->문자 형식 변환
-- [문제] 오늘 날짜를 TO_CHAR() 함수를 사용해서
--      2024년 02월 20일 오후 16:05:29 (화)
--      문자열로 출력.

-- ORA-01821: date format not recognized
SELECT SYSDATE
--    , TO_CHAR( SYSDATE, 'DL' )
--    , LENGTH(TO_CHAR( SYSDATE, 'DL' )) 길이
--   , SUBSTR(TO_CHAR( SYSDATE, 'DL'), 0,13) || TO_CHAR( SYSDATE, 'TS (DY)' )  오늘날짜시간
--  , TO_CHAR( SYSDATE, 'YYYY') || '년 ' || TO_CHAR( SYSDATE, 'MM') || '월 '
    , TO_CHAR( SYSDATE, 'YYYY"년" MM"월" DD"일" AM HH24:MI:SS (DY)')
FROM dual;
--
SELECT name,ssn
    , SUBSTR(ssn, 1, 6)
    , TO_DATE( SUBSTR(ssn, 1, 6) )
    , TO_CHAR( TO_DATE( SUBSTR(ssn, 1, 6) ), 'DL' )
FROM insa;

-- ORA-01861: literal does not match format string
SELECT
    TO_DATE( '0821', 'MMDD' )   -- [24]/08/21   -- 현재년도로 자동처리됨.
    , TO_DATE( '2023', 'YYYY' ) -- 23/[02]/[01] -- 현재월로 자동처리됨.
    , TO_DATE( '202312', 'YYYYMM' ) -- 23/12/[01]
    , TO_DATE('23년 01월 12일', 'YY"년" MM"월" DD"일"') -- 23/01/12
FROM dual;  

-- [문제] 수료일 '6/14' 오늘부터 남은 일수 ?
-- ORA-01821: date format not recognized
SELECT SYSDATE
    , TO_DATE('6/14', 'MM/DD') -- 24/06/14
    , CEIL (ABS( SYSDATE - TO_DATE('6/14', 'MM/DD') )) -- 115
FROM dual;

-- [문제] 4자리 부서번호로 출력...     String.format("%04d", 10) "0010"
SELECT deptno
    , LPAD( deptno, 4, '0')
    , CONCAT('00', deptno)
    , TO_CHAR( deptno, '0999')
FROM emp;

-- java
if( a==b ) {
    c
    }
-- oracle DECODE(a,b,c)
if( a==b)
{
    c
}else{
    d
}

-- oracle DECODE(a,b,c,d)
if( a==b)
{
    c
}else if(a = d) {
    e
}else if(a = f) {
    g
}else {
    h
}
-- oracle DECODE(a,b,c,d,e,f,g,h)
-- [문제] insa테이블에서 남자/여자...
SELECT name, ssn
      , REPLACE( REPLACE( MOD(SUBSTR(ssn, 8, 1), 2), 0, '여자'), 1, '남자') gender
      , DECODE( MOD(SUBSTR(ssn, 8, 1), 2), 0,'여자','남자'  ) gender
FROM insa;
-- [문제] insa 테이블에서 오늘을 기준으로 생일이 지남 여부를 출력하는 쿼리를 작성하세요 . 
--   ( '지났다', '안지났다', '오늘 ' 처리 )
SELECT t.name, t.ssn
    , DECODE( s, 0, '오늘', 1, '생일 전', '생일 후')
FROM(
SELECT name, ssn
    , SIGN(TO_DATE(SUBSTR( ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)) s
FROM insa
) t;

-- [문제] emp 테이블에서 각 사원의 번호,이름, 급여 출력
--    조건)  10번 부서원들은 급여의 15% 인상해서 급여
--    조건)  20번 부서원들은 급여의 10% 인상해서 급여
--    조건)  30번 부서원들은 급여의  5% 인상해서 급여
SELECT empno, ename, sal+NVL(comm,0) pay, deptno
     , DECODE( deptno, 10, '15%', 20, '10%', 30, '5%' ) 인상률
     --, sal  + sal * DECODE( deptno, 10, 0.15 , 20, 0.1, 30, 0.05 ) "인상된 pay"
     , (sal+NVL(comm,0))*(1+DECODE( deptno, 10, 0.15 , 20, 0.1, 30, 0.05 )) "인상된 pay"
FROM emp;

-- 내일 : 자료형/테이블 생성




