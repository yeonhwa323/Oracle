-- SCOTT
SELECT *
FROM tabs;

-- 내일 수업 !
-- [문제] insa 테이블에서 각 사원들의 만나이를 계산해서 출력...
-- 1) 만나이 = 올해년도-생일년도     (생일지났는지 여부 X -1)
--     ㄱ. 생일 지났는지 여부
--     ㄴ. 981223-1XXXXXX
--               12 1900 / 34 2000 / 89  1800
-- 오라클 나이를 반환하는 함수를 만들 때 또 아래 코딩 사용...(암기!!!)
-- 10분 풀어보기
SELECT name
    , SUBSTR(ssn,1,8)
    , TO_DATE(SYSDATE)
    , TO_DATE ( substr(ssn,1,6), 'YYMMDD')
    , TO_DATE(SYSDATE) - TO_DATE ( substr(ssn,1,6), 'YYMMDD')
FROM insa;
--
-- [내일 문제]
SELECT t.name, t.ssn
    , 올해년도-생일년도 + CASE S
                            WHEN 1 THEN -1
                            ELSE 0
                        END 만나이
FROM(
        SELECT name, ssn
            , TO_CHAR(SYSDATE, 'YYYY') 올해년도
         --   , SUBSTR(ssn, 8, 1) 성별
         --   , SUBSTR(ssn, 1, 2) 생일년도
            , CASE
                WHEN SUBSTR(ssn, 8, 1) IN (1,2,5,6) THEN 1900
                WHEN SUBSTR(ssn, 8, 1) IN (3,4,7,8) THEN 2000
                ELSE 1800
              END + SUBSTR(ssn, 1, 2) 생일년도
              , SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE)) S -- 생일전,오늘생일,생일후     1,0,-1 SIGN()
        FROM insa
    ) t;
-- 자바       임의의 난수    0.0 <= double  Math.random() < 1.0 , Random를
-- 오라클     dbms_random 패키지     !=     자바 패키지 java.io
--           서로 관련 PL/SQL(프로시저,함수) 의 묶음     서로 관련된 클래스들의 묶음

SELECT 
    --SYS.dbms_random.value -- 0.0 <=  < 1.0
    --SYS.dbms_random.value(0,100) -- 0.0<=  < 100.0    
    --SYS.dbms_random.string('U', 5) -- Upper(대문자)
    --SYS.dbms_random.string('X', 5) -- Upper(대문자) + 숫자 
    SYS.dbms_random.string('P', 5)   -- Upper(대문자)+특수문자+숫자

    --SYS.dbms_random.string('L', 5) -- Lower(소문자)   
    --SYS.dbms_random.string('A', 5) -- 알파벳  
FROM dual;

--[문제] 임의의 국어점수 1개를 발생시켜서 출력하세요.(0~100 정수)
SELECT SYS.dbms_random.value(0,100) 국어점수 -- 0.0<= 실수 < 100
    , CEIL(SYS.dbms_random.value(0,100))
    , ROUND(SYS.dbms_random.value(0,100))
    , TRUNC(SYS.dbms_random.value(0,101))  -- 0.0<= 실수 < 101.0
    
    , ROUND(SYS.dbms_random.value(0,44)) +1
    , ROUND(SYS.dbms_random.value(1,45)) 
FROM dual;
--[문제] 임의의 로또번호 1개를 발생시켜서 출력하세요.(0~45 정수)
SELECT 
    TRUNC(SYS.dbms_random.value(0,45)) 로또번호
FROM dual;

-- [ 피봇(pivot) 설명 ] (암기)
-- https://blog.naver.com/gurrms95/222697767118
-- pivot 사전적 의미 : 축을 중심으로 회전시키다.
--      ㄴ 모니터 가로/세로 - 피벗 기능
-- 세로->가로:피봇 / 가로->세로:언피봇
-- 형식
--SELECT * 
--FROM (피벗 대상 쿼리문 1)
--PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN(피벗컬럼 값 AS 별칭...))
--[출처] [Oracle] 오라클 PIVOT(피벗)함수|작성자 끄니
-- 실습 1)
SELECT empno, ename
    , job
FROM emp;
-- 각 job별로 사원수가 몇 명인지 조회.
SELECT job, COUNT(*) CNT
FROM emp
GROUP BY ROLLUP(job);
-- 1) 피봇 대상 쿼리문
SELECT DISTINCT job
FROM emp;
-- 피봇 함수사용해서 처리.
SELECT *
FROM (
    SELECT job
    FROM emp
    )
PIVOT( COUNT(job) FOR job IN ('CLERK', 'SALESMAN','PRESIDENT','MANAGER','ANALYST') );

SELECT
     COUNT(DECODE( job, 'CLERK', 'O')) CLERK
    , COUNT(DECODE( job, 'SALESMAN', 'O')) SALESMAN
    , COUNT(DECODE( job, 'PRESIDENT', 'O')) PRESIDENT
    , COUNT(DECODE( job, 'MANAGER', 'O')) MANAGER
    , COUNT(DECODE( job, 'ANALYST', 'O')) ANALYST
FROM emp;
-- 실습 2) 월별 입사한 사원의 수를 파악
SELECT hiredate
    , TO_CHAR(hiredate, 'MM')
FROM emp;
--1월 2월 3월 ... 12월
--2   0   4       3
SELECT *
FROM (
    SELECT 
        TO_CHAR(hiredate, 'YYYY') year
        , TO_CHAR(hiredate, 'MM') month
    FROM emp
    )
PIVOT( COUNT(month) FOR month IN ('01' AS "1월", '02' AS "2월",'03','04','05','06', '07','08','09','10','11','12') );
    
SELECT  TO_CHAR(hiredate, 'MM') month
         , TO_CHAR(hiredate, 'FFMM')||'월' month
         , EXTRACT(MONTH FROM hiredate ) month
FROM emp;
-- 실습 3) 년도별 월별 입사한 사원의 수를 파악

-- 문제) emp 테이블에서 각 부서별, job의 사원수를 조회
SELECT *
FROM (
    SELECT d.deptno
        , dname
        , job
    FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
    )
PIVOT( COUNT(job) FOR job IN ('CLERK', 'SALESMAN','PRESIDENT','MANAGER','ANALYST') )
ORDER BY deptno ASC;
-- 실습)
SELECT job, deptno, sal
FROM emp;
--
SELECT *
FROM(
    SELECT job, deptno, sal
    FROM emp
    )
PIVOT ( SUM(sal) FOR deptno IN ('10', '20', '30') );
--
SELECT *
FROM(
    SELECT job, deptno, sal, ename
    FROM emp
    )
PIVOT ( SUM(sal) AS 합계, MAX(sal) AS 최고액, MAX(ename) AS 최고연봉 FOR deptno IN ('10', '20', '30') );

-- RIGHT OUTER JOIN
SELECT d.deptno
        , dname
        , job
FROM emp e, dept d
WHERE e.deptno(+)= d.deptno; -- RIGHT OUTER
WHERE e.deptno= d.deptno(+); -- LEFT OUTER
--FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno;
--FROM emp e LEFT OUTER JOIN dept d ON e.deptno = d.deptno;

-- [문제] emp 테이블에서 sal가 상위 20%에 해당되는 사원의 정보를 조회...
SELECT *
FROM(
    SELECT 
    RANK() OVER(ORDER BY sal DESC) sal_rank
    , deptno,ename, sal 
    FROM emp
    )
WHERE sal_rank <= (SELECT COUNT(*) FROM emp)*0.2 ;

-- [문제] emp 에서 각 사원의 급여가 전체급여의 몇 %가 되는 지 조회.
       ( %   소수점 3자리에서 반올림하세요 )
            무조건 소수점 2자리까지는 출력.. 7.00%,  3.50%  
SELECT t.ename, t.pay, t.totalpay
    , TO_CHAR(ROUND(t.pay/t.totalpay*100, 2), '999.00') 비율
FROM(
        SELECT  ename
            , sal+NVL(comm,0) pay
            , ( SELECT SUM(sal+NVL(comm,0)) FROM emp)  TOTALPAY
         FROM emp 
    ) t ;
ENAME             PAY   TOTALPAY 비율     
---------- ---------- ---------- -------
SMITH             800      27125   2.95%
ALLEN            1900      27125   7.00%
WARD             1750      27125   6.45%
JONES            2975      27125  10.97%
MARTIN           2650      27125   9.77%
BLAKE            2850      27125  10.51%
CLARK            2450      27125   9.03%
KING             5000      27125  18.43%
TURNER           1500      27125   5.53%
JAMES             950      27125   3.50%
FORD             3000      27125  11.06%
MILLER           1300      27125   4.79%
12개 행이 선택되었습니다.    

--[문제] insa 테이블
-- [ㄴ]
SELECT 
    COUNT(*) 총사원수
    , COUNT(DECODE( MOD(SUBSTR(ssn,8,1),2), 1,'남자' )) 남자사원수
    , COUNT(DECODE( MOD(SUBSTR(ssn,8,1),2), 0,'여자' )) 여자사원수
    , SUM(DECODE( MOD(SUBSTR(ssn,8,1),2), 1, basicpay )) "남사원들의 총급여합"
    , SUM(DECODE( MOD(SUBSTR(ssn,8,1),2), 0, basicpay )) "여사원들의 총급여합"
    , MAX(DECODE( MOD(SUBSTR(ssn,8,1),2), 1, basicpay )) "남자-max(급여)"
    , MAX(DECODE( MOD(SUBSTR(ssn,8,1),2), 0, basicpay )) "여자-max(급여)"
FROM insa;
-- [ㄱ]
SELECT 
    DECODE( MOD(SUBSTR(ssn,8,1),2), 1,'남자',0,'여자', '전체')|| '사원수'
    , COUNT(*) 사원수
    , SUM (basicpay) 급여합
    , MAX (basicpay) 최고급여합
FROM  insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2));

-- [문제] 순위(RANK) 함수 사용해서 풀기 
--   emp 에서 각 부서별 최고급여를 받는 사원의 정보 출력
-- [ㄱ. rank 함수 없이]
SELECT t.deptno, e.ename, t.max_pay, 1 DEPTNO_RANK
FROM (
        SELECT deptno, MAX( sal+NVL(comm,0)) max_pay
        FROM emp
        GROUP BY deptno
    ) t , emp e 
WHERE t.deptno = e.deptno AND t.max_pay = (e.sal+NVL(comm,0))
ORDER BY deptno;
-- [ㄴ. rank 함수 사용]
SELECT deptno, ename, pay, deptno_pay_rank
FROM(
    SELECT deptno, ename
    , sal+NVL(comm,0) pay
    , RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) pay_rank
    , RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) deptno_pay_rank
    FROM emp
    ) t
WHERE deptno_pay_rank = 1
ORDER BY deptno;   

    DEPTNO ENAME             PAY DEPTNO_RANK
---------- ---------- ---------- -----------
        10 KING             5000           1
        20 FORD             3000           1
        30 BLAKE            2850           1

-- [문제] emp 테이블에서
-- 각 부서의 사원수, 부서 총급여합, 부서 평균급여

SELECT d.deptno
    , COUNT(empno) 부서원수
    , NVL(SUM(sal+NVL(comm,0)),0) 총급여합
    , NVL(ROUND(AVG(sal+NVL(comm,0)),2),0) 평균
--FROM emp e , dept d
--WHERE e.deptno (+)= d.deptno
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
ORDER BY d.deptno ASC;

-- [문제] insa 테이블에서 각 부서별 / 출신지역별 / 사원수 몇 명인지 출력(조회)
-- (조건) 출신지역의 사원이 존재하지 않아도 모든 출신지역의 사원수를 출력 )
-- ( PARTITION OUTER JOIN 구문 사용 )
WITH c AS (
    SELECT DISTINCT city
    FROM insa
)
SELECT buseo, c.city, COUNT(num)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN c ON i.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;

--
SELECT DISTINCT city
FROM insa
ORDER BY city ASC;
--강원
--경기
--경남
--경북
--부산
--서울
--인천
--전남
--전북
--제주
--충남

-- [문제]
 insa 테이블에서 
[실행결과]
                                           부서사원수/전체사원수 == 부/전 비율
                                           부서의 해당성별사원수/전체사원수 == 부성/전%
                                           부서의 해당성별사원수/부서사원수 == 성/부%
                                           
부서명     총사원수 부서사원수 성별  성별사원수  부/전%   부성/전%   성/부%
개발부       60       14         F       8       23.3%     13.3%       57.1%
개발부       60       14         M       6       23.3%     10%       42.9%
기획부       60       7         F       3       11.7%       5%       42.9%
기획부       60       7         M       4       11.7%   6.7%       57.1%
영업부       60       16         F       8       26.7%   13.3%       50%
영업부       60       16         M       8       26.7%   13.3%       50%
인사부       60       4         M       4       6.7%   6.7%       100%
자재부       60       6         F       4       10%       6.7%       66.7%
자재부       60       6         M       2       10%       3.3%       33.3%
총무부       60       7         F       3       11.7%   5%           42.9%
총무부       60       7         M    4       11.7%   6.7%       57.1%
홍보부       60       6         F       3       10%       5%           50%
홍보부       60       6         M       3       10%       5%           50%    
--
SELECT
    s.*
    , ROUND(부서사원수/총사원수*100,2) || '%' "부/전%"
    , ROUND(성별사원수/총사원수*100,2) || '%' "부성/전%"
    , ROUND(성별사원수/부서사원수*100,2) || '%' "성/부%"

FROM (
        SELECT buseo
            , ( SELECT COUNT(*) FROM insa ) 총사원수
            , ( SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) 부서사원수
            , gender  성별
            , COUNT(*) 성별사원수
        FROM (
                SELECT buseo, name, ssn
                    , DECODE( MOD(SUBSTR(ssn, 8, 1),2), 1, 'M', 'F' ) gender
                FROM insa
            ) t
        GROUP BY buseo, gender
        ORDER BY buseo, gender
    ) s ;

-- [문제] SMS 인증번호 임의의 6자리 숫자 발생
SELECT SYS.dbms_random.value
    , TRUNC(SYS.dbms_random.value(100000, 1000000)) SMS6자리
    , TO_CHAR(TRUNC(SYS.dbms_random.value(10000, 1000000)), '099999') SMS6자리
FROM dual;

SELECT deptno
    , TO_CHAR( deptno, '0999')
FROM dept;

-- [문제] LISTAGG 함수 ( 암기 )
-- https://blog.naver.com/doittall/223307658631
SELECT deptno, job
    , NVL(LISTAGG( ename, '/' ) WITHIN GROUP( ORDER BY ename), '사원없음' ) 사원 목록
FROM emp
ORDER BY deptno, job;

--  LISTAGG 함수 형식
SELECT LISTAGG(ename, '/') WITHIN GROUP (ORDER BY ename ASC) 
FROM emp ;
-- 
SELECT
    d.deptno
    , NVL(LISTAGG(ename, '/') WITHIN GROUP (ORDER BY ename ASC), '사원없음') enames
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno=d.deptno
GROUP BY d.deptno;

-- [문제] emp 테이블에서 30번 부서의 최고, 최저 sal를 받는 사원의 정보 조회
SELECT MAX(sal), MIN(sal) -- 2850	950
FROM emp
WHERE deptno = 30;
 출력할 컬럼 : deptno, ename, hiredate, sal
--   ㄱ. 
SELECT deptno
    , ename
    , hiredate
    , sal
    , 'MAX'
FROM emp
WHERE sal = (SELECT MAX(sal)
             FROM emp
             WHERE deptno = 30) and deptno = 30
UNION
SELECT deptno
    , ename
    , hiredate
    , sal    
    , 'MIN'
FROM emp
WHERE sal = (SELECT MIN(sal)
             FROM emp
             WHERE deptno = 30) and deptno = 30;
-- ㄴ.
  select deptno, ename, hiredate , sal
  from  emp s 
  where   s.sal = ( select max(sal)    from emp     where deptno = 30)
         or s.sal = ( select min(sal)    from emp     where deptno = 30)
         and deptno = 30; 
-- ㄷ.  
SELECT deptno,ename,hiredate,sal
FROM emp e
WHERE sal IN (
             (SELECT  MAX(sal)    FROM emp    WHERE deptno = 30)
            ,(SELECT  MIN(sal)    FROM emp    WHERE deptno = 30 )
            )  
     AND deptno = 30;
-- ㄹ.  
SELECT deptno, ename, hiredate, sal
FROM (
    SELECT deptno, ename, hiredate, sal,
           RANK() OVER (PARTITION BY deptno ORDER BY sal ASC) AS srtop,
           RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS srlow
    FROM emp
    WHERE deptno = 30
) r
WHERE srtop = 1 OR srlow = 1;  
-- ㅁ.
SELECT b.*

-- [마지막문제] emp 테이블에서
--             사원수가 가장 작은 부서명과 사원수
--             사원수가 가장 많은 부서명과 사원수
--             출력
-- 1) UNION X
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;
-- 2) 
SELECT t.deptno, cnt
FROM (
        SELECT d.deptno, COUNT(empno) cnt
            , RANK() OVER(ORDER BY COUNT(empno) ASC) cnt_rank
        FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
        GROUP BY d.deptno
) t
WHERE t.cnt_rank IN (1, (SELECT COUNT(*) FROM dept) );
-- RANK 순위함수 사용 x 
-- MAX(cnt) , MIN(cnt) o
-- ㄱ.
WITH t AS(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
)
SELECT dname, cnt
FROM t
WHERE cnt IN ((SELECT MAX(cnt) FROM t), (SELECT MIN(cnt) FROM t));
-- ㄴ. WITH 절 이해하고 암기
WITH a AS (
        SELECT d.deptno, dname , COUNT(empno) cnt
        FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
        GROUP BY d.deptno, dname
    )
    , b AS (
        SELECT MIN(cnt) mincnt, MAX(cnt) maxcnt
        FROM a
    )
SELECT a.dname, a.cnt
FROM a, b 
WHERE a.cnt IN (b.mincnt, b.maxcnt);

-- ㄷ. 분석함수 : FIRST, LAST
--              ? 집계함수( COUNT, SUM, AVG, MAX, MIN )와 같이 사용하여
--                주어진 그룹에 대해 내부적으로 순위를 매겨 결과를 산출하는 함수.
WITH a AS (
        SELECT d.deptno, dname , COUNT(empno) cnt
        FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
        GROUP BY d.deptno, dname
    )
SELECT MAX(cnt)
    , MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt ASC) max_dname --MAX(deptno)도 가능
    , MIN(cnt)
    , MIN(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt ASC) min_dname    
FROM a;

-- 분석함수 중에 CUME_DIST() : 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
                    -- 분포도값(비율)  0 <   <= 1
SELECT deptno, ename, sal
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal ASC) 부서내누적분포도dept_dist
    , CUME_DIST() OVER( ORDER BY sal ASC) 전체누적분포도dept_dist
FROM emp;

-- 분석함수 중에 PERCENT_RANK() : 해당 그룹 내의 백분위 순위
--                  0 < 사이의 값 <= 1
--  백분위 순위 ? 그룹 안에서 해당 행의 값보다 작은 값의 비율
SELECT deptno, ename, sal
--    , PERCENT_RANK() OVER(ORDER BY sal ) PERCENT
    , PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal ) PERCENT
FROM emp;

-- NTILE() N타일 : 파티션 별로 expr에 명시된 만큼 분할한 결과를 반환하는 함수 
-- 분할하는 수를 버킷(bucket)이라고 한다.
-- ex) NTILE(4) = 4 버킷으로 나누어 담는다.
SELECT deptno, ename, sal
    ,NTILE(4) OVER(ORDER BY sal) ntiles
FROM emp;

SELECT buseo, name, basicpay
    , NTILE(2) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;

-- WIDTH_BUCKET(exr, minvalue, maxvalue, numbucket) == NTILE() 함수와 유사한 분석함수, 차이점( 최소값, 최대값 설정 가능 )
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal ) ntiles
    , WIDTH_BUCKET(sal, 0, 5000, 4) widthbuckets
FROM emp;
--   필수(컬럼명)    가져올 행의 위치    값이 없을 때 기본값
--  LAG( expr,      offset,           default_value )
-- ? 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수, 앞(선행 행)
-- LEAD( expr, offset, default_value )
-- ? 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수, 뒤(후행 행)
SELECT ename, hiredate, sal
    , LAG( sal, 1, 0 ) OVER(ORDER BY hiredate) pre_sal
  --  , LAG( sal, 2, -1 ) OVER(ORDER BY hiredate) pre_sal
    , LEAD( sal, 1, -1 ) OVER( ORDER BY hiredate) next_sal --PARTITION BY 사용가능
FROM emp
WHERE deptno = 30;

-------------------------------------------------------------------------------
-- [오라클 자료형( Data Type ) ]--
-- 1) 문자(열) 저장하는 자료형 CHAR[(size[BYTE ? CHAR])]
    형식)
    CHAR[(SIZE BYTE|CHAR)]
    예)
    CHAR(3 CHAR) ? 3문자를 저장하는 자료형, 'abc', '한글세'
    CHAR(3 BYTE) ? 3바이트의 문자를 저장하는 자료형 'abc', '한'
    CHAR(3) == CHAR(3 BYTE) 
    CHAR == CHAR(1) == CHAR(1 BYTE)
    '고정 길이의 문자 자료형' 일때 사용*****
    1바이트~ 2000바이트 저장가능
    
    CHAR(14)==CHAR(14 BYTE) ['A']['B']['C'][][][][][][][][][][][] 14바이트
    예) 주민등록번호(14자리) 우편번호(7자리) - 문자열의 길이가 정해져 있는 값을 저장할 때
    
    -- DDL
    CREATE TABLE tbl_char
    (
        aa char         --char(1) == char(1 byte)
        , bb char(3)    --char(3 byte)
        , cc char(3 char)
    );
    -- Table TBL_CHAR이(가) 생성되었습니다.
 SELECT *
 FROM tabs
 WHERE table_name LIKE '%CHAR%';
 --
 DESC tbl_char;
 -- 새로운 레코드(행)을 추가..
 INSERT INTO tbl_char (aa,bb,cc) VALUES ('a','aaa','aaa');
 -- 1 행 이(가) 삽입되었습니다.
 INSERT INTO tbl_char (aa,bb,cc) VALUES ('a','한','우리');
 -- 1 행 이(가) 삽입되었습니다.
 -- ORA-12899: value too large for column "SCOTT"."TBL_CHAR"."BB" (actual: 6, maximum: 3)
 INSERT INTO tbl_char (aa,bb,cc) VALUES ('a','우리','우리');
 COMMIT; -- 커밋 완료.
 SELECT VSIZE('우'), VSIZE('a')
 FROM dual;
 --
SELECT *
FROM tbl_char;
-- Table TBL_CHAR이(가) 삭제되었습니다.
DROP TABLE tbl_char;
--
DESC emp;

-- N == 유니코드(unicode)
NCHAR[(size)] == N + CHAR[(SIZE)]

 NCHAR == NCHAR(1)

 CREATE TABLE tbl_nchar
    (
        aa char(3)         --char(1) == char(1 byte)
        , bb char(3 char)    --char(3 byte)
        , cc nchar(3)
    );
-- Table TBL_CHAR이(가) 생성되었습니다.
INSERT INTO tbl_nchar (aa,bb,cc) VALUES ('홍','길동','홍길동');
--  ORA-12899: value too large for column "SCOTT"."TBL_NCHAR"."AA" (actual: 9, maximum: 3)
INSERT INTO tbl_nchar (aa,bb,cc) VALUES ('홍길동','홍길동','홍길동');

COMMIT;
--
SELECT *
FROM tbl_nchar;

DROP TABLE tbl_nchar;
-- char / nchar - 고정길이 2000byte 
-- VARCHAR2(size[BYTE ? CHAR])
 VARCHAR2(SIZE BYTE|CHAR) 가변길이
 
 char(5 byte)     [a][b][c][][]
 varchar2(5 byte) [a][b][c]
 VALCHAR2 == varchar2(1) == varchar2(1 BYTE) 4000byte
 
 DESC emp;
 -- N+VAR+CHAR2(size)
 NVARCHAR2 == NVARCHAR2(1) == '한' 'a'
 4000 byte
 
-----------------------------------------------------------------






