-- SCOTT
SELECT *
FROM tabs;

-- [SET 집합 연산자]
-- 1) 합집합( UNION, UNION ALL)
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부' 
--UNION -- 17명 -- 6명은 중복된다. 제거1번만 포함
UNION ALL -- 23명 -- 중복 제거x 모두출력 
SELECT name, city, buseo
FROM insa
WHERE city = '인천'; -- 9명

-- 2) 차집합( MINUS)
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
MINUS
SELECT name, city, buseo
FROM insa
WHERE city = '인천'; -- 8명

-- 3) 교집합( INTERSECT)
-- 개발부이면서 인천인 사원들을 파악
-- [2] 
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city = '인천'; 

-- [1]
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부' AND city = '인천'; -- 6명

-- [SET 집합 연산자를 사용할 때 주의할 점]
-- : 타입의 자료형,갯수가 같아야한다.
-- ORA-01790: expression must have same datatype as corresponding expression
--            수식                  동일한 데이터타입       해당식
-- ORA-01789: query block has incorrect number of result columns
SELECT name, city, buseo -- 42행, 20열에서 오류 발생
FROM insa
WHERE buseo = '개발부' 
UNION ALL --23명
SELECT name, city --, jikwi --, basicpay
FROM insa
WHERE city = '인천'; 
-- insa 테이블의 사원 정보 + emp 테이블의 사원 정보 모두 출력.
SELECT buseo, num, name, ibsadate, basicpay, sudang
FROM insa
UNION ALL
SELECT TO_CHAR(deptno), empno, ename, hiredate, sal, comm
FROM emp;
-- [MULTISET 연산자]
MULTISET EXCEPT
MULTISET INTERSECT
MULTISET UNION
-- [계층적 질의 연산자]
-- PRIOR, CONNECT_BY_ROOT
-- {연결 연산자 ] ||

-- [산술 연산자] + - / *
--              나머지 구하는 연산자 X
--              나머지 구하는 함수 MOD(5,3) ****    5-3*FLOOR(5/3)
--              나머지 구하는 함수 REMAINDER(5,3)   5-3*ROUND(5/3) X
SELECT 
    -- 10/0 -- ORA-01476: divisor is equal to zero
    -- 'A' / 2 -- ORA-01722: invalid number
    MOD(10, 0)
FROM dual;

IS [NOT] NAN    Not A Number
IS [NOT] INFINITE 무한대

-- 오라클 함수(function)
-- 1. 복잡한 쿼리문을 간단하게 해주고 데이터의 값을 조작하는데 사용되는 것.
-- 2. 종류 : 단일행 함수, 복수행 함수
SELECT LOWER( ename )
FROM emp;

SELECT COUNT(*) --복수행함수
FROM emp;

-- [숫자 함수] --
-- 1) ROUND(number) 숫자값을 특정 위치에서 반올림하여 리턴한다. 
-- 형식 ROUND(number, n)  n = 0, 음수, 양수
SELECT 3.141592
    , ROUND( 3.141592 ) a -- 소숫점 첫 번째 자리에서 반올림.
    , ROUND( 3.141592, 0 ) b -- n을 생략한 경우와 같다.
    , ROUND( 3.141592, 2 ) c -- 소숫점 세 번째 자리에서 반올림...
    , ROUND( 1234.5678, 2 ) d
    , ROUND( 1234.5678, -1 ) e
    , ROUND( 1234.5678, -2 ) f   
    , ROUND( 1234.5678, -3 ) g
FROM dual;

-- [문제] emp 테이블에서 pay, 평균급여, 총급여합, 사원수 출력
-- ORA-00937: not a single-group group function
-- 집계함수는 일반함수들과 함께 사용할 수 없음
-- ( ? )GROUP BY 집계함수, SELECT 같이 사용할 수있지만 일반적인 GROUP BY절과 집계함수는 같이 쓸수 없음.
SELECT emp.*
    , sal + NVL(comm, 0) pay
    --, COUNT(*) -- 사원수
    , ( SELECT COUNT(*) FROM emp) t_cnt
    -- SUM ( sal+NVL(comm,0) )
    , (SELECT SUM ( sal+NVL(comm,0) FROM emp) total_pay
    --평균급여 계산해서 소수점 2자리까지 출력하자...
    , (SELECT SUM( sal+NVL(comm,0) )/COUNT(*) FROM emp ) avg_pay
    , ROUND(SELECT AVG( sal+NVL(comm,0) FROM emp ),2) avg_pay    
FROM emp;
-- [집계함수]
SELECT COUNT(*) -- null 값을 포함한 갯수를 반환
    , COUNT(empno)
    , COUNT(deptno)
    , COUNT(sal)
    , COUNT(hiredate)    
    , COUNT(comm) --4
FROM emp;

-- 평균 커미션 ?
SELECT AVG(comm) -- 550 -- NULL값제외한 평균값

SELECT SUM(comm)/COUNT(*) -- 183.333333333333333333333333333333333333 -- NULL값 포함한 평균값
    , SUM(comm)/COUNT(comm) -- 550ll
FROM emp;

-- TRUNC(날짜, 숫자), FLOOR(숫자) 절삭하는 2가지 함수.
-- 2가지 차이점? 두 번째 차이점은
--             TRUNC() 는 특정 위치에서 절삭 가능
--             FLOOR() 는 소수점 첫 번째 자리에서 절삭만 가능.
SELECT 3.141592
    , TRUNC( 3.141592 ) -- 소수점 첫 번째 자리에서 절삭 가능.
    , TRUNC( 3.141592, 0 ) -- 소수점 첫 번째 자리에서 절삭 가능.
    , FLOOR( 3.141592 )
    
    , TRUNC( 3.141592 , 3) -- 특정 위치에서 절삭 가능.
    , FLOOR( 3.141592 ) * 1000 / 1000
    
    , TRUNC( 3.141592 , -1)    
FROM dual; 
-- CEIL() : 소숫점 첫째자리에서 올림(절상)하는 함수
SELECT CEIL( 3.14 ), CEIL( 3.54 )
FROM dual;
-- 3.141595 를 소수점 세 번째 자리에서 올림하자.
SELECT CEIL( 3.141592 *100) /100   -- 3.15
FROM dual;
-- 총페이지수를 계산할 때 CEIL() 올림(절상)함수를 사용한다.
-- 총 게시글(사원) 수 : 
-- 한 페이지에 출력할 게시글(사원) 수 : 5
SELECT COUNT(*) FROM emp;
SELECT CEIL( ( SELECT COUNT(*) FROM emp ) /5 ) --총페이지수
FROM dual;
--
SELECT *
FROM emp
ORDER BY sal+NVL(comm,0) DESC;
-- [1] 2 3
7839	KING	PRESIDENT		81/11/17	5000		10
7902	FORD	ANALYST	7566	81/12/03	3000		20
7566	JONES	MANAGER	7839	81/04/02	2975		20
7698	BLAKE	MANAGER	7839	81/05/01	2850		30
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
-- 1 [2] 3
7782	CLARK	MANAGER	7839	81/06/09	2450		10
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	30
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	30
7934	MILLER	CLERK	7782	82/01/23	1300		10
-- 1 2 [3]
7900	JAMES	CLERK	7698	81/12/03	950		30
7369	SMITH	CLERK	7902	80/12/17	800		20
-- ABS() : 절댓값 구하는 함수
SELECT ABS(100), ABS(-100)
FROM dual;
-- SIGN() :  숫자값의 부호에 따라 1, 0, -1의 값으로 리턴한다. 
SELECT SIGN(100), SIGN(0), SIGN(-100)
FROM dual;

-- [문제] emp 테이블의 평균급여를 구해서
-- 각 사원의 급여(pay)가 평균급여보다 많으면 "평균급여보다 많다"라고 출력하고
--                                적으면 "평균급여보다 적다"라고 출력.
-- 2260.416666666666666666666666666666666667
-- [평균 급여]
SELECT AVG ( sal+NVL(comm,0) )
FROM emp;
-- [1]
SELECT p.*--, '많다'     
FROM emp p 
WHERE sal+NVL(comm,0) > (SELECT AVG ( sal+NVL(comm,0) )avg_pay FROM emp) 
UNION ALL
SELECT p.*, '적다'     
FROM emp p 
WHERE sal+NVL(comm,0) < (SELECT AVG ( sal+NVL(comm,0) )avg_pay FROM emp) ;
-- [2]
SELECT ename, sal+NVL(comm,0) pay 
    , (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) avg_pay
    , SIGN( sal+NVL(comm,0) - (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) ) s 
    , REPLACE(   REPLACE( SIGN( sal+NVL(comm,0) - (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) ), -1, '적다'), 1, '많다')  ㄱ
FROM emp
ORDER BY s;
-- [3]
SELECT ename, pay, avg_pay
    , NVL2( NULLIF( SIGN( pay - avg_pay ), 1 ), '적다', '많다')
FROM (
        SELECT  ename, sal+NVL(comm,0) pay 
            , (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) avg_pay
        FROM emp
     );

     
-- POWER(), SQRT()
SELECT power(2,3), power(2,-3)
    , SQRT(2)
FROM dual;
 
-- [문자 함수] --
-- INSTR() == JAVA indexOf(), lastIndexOf() 비슷
SELECT instr('Corea','e') -- 4
From dual;

SELECT 
    instr('corporate floor','or') -- 2 번째 자리 위치(2)
    , instr('corporate floor','or',3,2) -- 3번째자리부터시작해서 14번째자리 위치(14)
    , instr('corporate floor','or',-3,2) -- 뒤에서3번째자리부터 2번째(2)
FROM dual;

SELECT '010-1234-5678' hp
    , SUBSTR('02-1234-5678', 1,3) a --010
    , SUBSTR('02-1234-5678', 5,4) b --1234
    , SUBSTR('02-1234-5678', 10,4) c --5678
FROM dual;

SELECT '02-1234-5678' tel
    , INSTR('02-1234-5678', '-') "첫번째 - 위치" -- 3
    , INSTR('02-1234-5678', '-', -1) "두번째 - 위치" -- 8
    , SUBSTR('02-1234-5678', 1, INSTR('02-1234-5678', '-')-1) a --02
    , SUBSTR('02-1234-5678', INSTR('02-1234-5678', '-')+1) -- 1234-5678
        , INSTR('02-1234-5678', '-',-1)-1-(INSTR('02-1234-5678', '-')+1) --3
    , SUBSTR('02-1234-5678', INSTR('02-1234-5678', '-',-1)+1,4) --5678
FROM dual;
--
DESC tbl_tel;
--
SELECT *
FROM tbl_tel;
--
INSERT INTO tbl_tel (tel,name) VALUES ('063)456-4567', '큰삼촌');
INSERT INTO tbl_tel (tel,name) VALUES ('052)1456-2367', '둘째삼촌');
COMMIT;
-- 지역번호 / 앞자리 전화번호 / 뒷자리 전화번호
SELECT name, tel
    , INSTR( tel, ')' ) ") 위치" -- 4
    , INSTR( tel, '-' ) "- 위치" -- 8
    , SUBSTR( tel, 1, INSTR( tel, ')' )-1 ) "지역번호 )-1"
    , SUBSTR( tel, INSTR( tel, ')' )+1, INSTR( tel, '-' )-INSTR( tel, ')' )-1 ) "앞 전화번호"
    , SUBSTR( tel, INSTR( tel, '-' )+1) "뒤 전화번호"
FROM tbl_tel;

-- RPAD / LPAD
    -- PAD == 덧 대는 것, 메워 넣은 것, 패드
    -- 형식) RPAD(expr1, n [,expr2])
    SELECT ename, pay
        , RPAD(pay, 10, '*' )
        , LPAD(pay, 10, '*' )
    FROM(
        SELECT ename, sal+NVL(comm,0) pay
        FROM emp
        ) t;

-- ASCII()
SELECT ename
    , SUBSTR( ename, 1,1)
    , ASCII( SUBSTR( ename, 1,1) )
    , CHR( ASCII( SUBSTR( ename, 1,1) ) )
FROM emp;
-- 
SELECT ASCII('A'), ASCII('a'), ASCII('0') -- 65	97	48
FROM dual;

-- GREATEST(), LEAST()  나열된 숫자, 문자 중에 가장 큰, 작은 값을 리턴하는 함수
SELECT GREATEST(3,5,2,4,1)
    , GREATEST('R', 'A', 'Z', 'X')
    , LEAST(3,5,2,4,1)
    , LEAST('R', 'A', 'Z', 'X')
FROM dual;

-- VSIZE()
SELECT ename
    , VSIZE(ename) -- 5
    , VSIZE('홍길동') -- 9 byte
    , VSIZE('a')
    , VSIZE('한')
FROM emp;
-- 숫자 함수
-- 문자 함수
-- [날짜 함수] 
SELECT SYSDATE -- '24/02/19'   초
    , ROUND( SYSDATE ) a -- 일 반올림/ '24/02/20' 정오를 기준으로 날짜 반올림.  
    , ROUND( SYSDATE, 'DD' ) b -- 일 반올림/ '24/02/20' 정오를 기준으로 날짜 반올림.  
    , ROUND( SYSDATE, 'MONTH' ) c -- 월 반올림/ 그 달의 15일 기준으로 이월
    , ROUND( SYSDATE, 'YEAR' ) d -- 년 반올림
FROM dual;
-- 날짜의 절삭함수 : TRUNC()
SELECT SYSDATE
    , TO_CHAR( SYSDATE, 'YYYY.MM.DD HH24.MI.SS' ) a -- 2024.02.19 03.38.25
    , TRUNC( SYSDATE )         -- 시간 분 초 00:00:00 절삭
    , TRUNC( SYSDATE, 'DD' )   -- 시간 분 초 00:00:00 절삭    
    , TO_CHAR( TRUNC( SYSDATE ), 'YYYY.MM.DD HH24.MI.SS' ) b -- 2024.02.19 12.00.00
    , TRUNC ( SYSDATE, 'MONTH' ) -- 24/02/[01] 월 밑으로 절삭
    , TRUNC ( SYSDATE, 'YEAR' ) -- 24/[01]/[01] 년 밑으로 절삭
FROM dual;

-- 날짜 + 숫자 날짜 날짜에 일수를 더하여 날짜 계산
SELECT SYSDATE + 100 -- 24/05/29
FROM dual;
-- 날짜 - 숫자 날짜 날짜에 일수를 감하여 날짜 계산
SELECT SYSDATE -30
FROM dual;
-- 날짜 + 숫자/24 날짜 날짜에 시간을 더하여 날짜 계산 
-- 2시간 후에 만나자 ( 약속 )
SELECT SYSDATE
    -- 2024/02/19 16:03:49
    , TO_CHAR( SYSDATE, 'YYYY/MM/DD HH24:MI:SS' )
    , SYSDATE + 2/24
    -- 2024/02/19 18:05:08
    , TO_CHAR( SYSDATE +  2/24, 'YYYY/MM/DD HH24:MI:SS' ) 
FROM dual;
-- 날짜 - 날짜 = 일수  날짜에 날짜를 감하여 일수 계산
-- [문제] 입사한 날짜 부터오늘 날짜까지 근무한 일수 몇일 ?
SELECT ename
    , hiredate
    , SYSDATE
    , CEIL( SYSDATE - hiredate ) -- 반올림한 값
    , TRUNC(SYSDATE+1) - TRUNC(hiredate) -- 날짜-날짜=근무일수
from emp;

-- [문제] 24년 2월 마지막 날짜 몇 일까지?
-- [2]
SELECT SYSDATE
    -- 매개변수 날짜의 마지막 날짜를 반환하는 함수 LAST_DAY()
    , LAST_DAY(SYSDATE) -- 24/02/29
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD') -- 29
FROM dual;

-- [1]
SELECT SYSDATE a --24/02/19
    -- , TRUNC( SYSDATE, 'DD' ) 시간,분,초 절삭
    , TRUNC( SYSDATE, 'MONTH' ) b -- 24/02/01
    -- 1달 더하기
 --   , ADD_MONTHS( TRUNC( SYSDATE, 'MONTH' ), -1 ) -- 24/01/01
 --   , ADD_MONTHS( TRUNC( SYSDATE, 'MONTH' ), 1 ) -- 24/03/01
 --   , ADD_MONTHS( TRUNC( SYSDATE, 'MONTH' ), 1 )-1 -- 24/02/29
    , TO_CHAR( ADD_MONTHS( TRUNC( SYSDATE, 'MONTH' ), 1 ) -1, 'DD') -- 29
FROM dual;

-- [문제] 개강일로부터 오늘날짜까지 일수 ?
-- 2023.12.29 개강
-- [문제] 오늘 날짜부터 수료일까지 남은 일수 ?
-- 2024.06.14 수료
-- 날짜 - 날짜 = 일수
SELECT SYSDATE
    , '2023.12.29'
    , TO_DATE('2023.12.29', 'YYYY.MM.DD') 
    , CEIL ( SYSDATE  - TO_DATE('2023.12.29', 'YYYY.MM.DD') )
    , ABS( CEIL( SYSDATE - TO_DATE('2024.06.14', 'YYYY.MM.DD'))) -- ABS(절대값)함수사용
FROM dual;

-- NEXT_DAY() 함수 : 명시된 요일이 돌아오는 가장 최근 날짜를 리턴하는 함수
SELECT SYSDATE
    ,TO_CHAR( SYSDATE, 'YYYY/MM/DD (DY)')   a
    ,TO_CHAR( SYSDATE, 'YYYY/MM/DD (DAY)')  b
    -- 가장 가까운 금요일날 약속하자...
    , NEXT_DAY( SYSDATE, '금') -- 24/02/23
    , NEXT_DAY( SYSDATE, '월') -- 24/02/26
FROM dual;
-- [문제] 4월 첫 번째 화요일에 만나자( 약속 )
--           첫 번째 월요일에 만나자( 약속 )
SELECT TO_DATE('2024.04.01')-1 ㄱ
--    , NEXT_DAY( TO_DATE('2024.04.01'), '화' ) -- 24/04/02
    , NEXT_DAY( TO_DATE('2024.04.01') -1, '월') ㄴ -- 24/04/01
FROM dual;

-- MONTHS_BETWEEN() : 두 날짜 사이의 개월수 반환하는 함수
SELECT ename, hiredate
    , SYSDATE
    , CEIL(ABS( hiredate - SYSDATE)) 근무일수
    , MONTHS_BETWEEN( SYSDATE, hiredate ) 근무개월수
    , ROUND( MONTHS_BETWEEN( SYSDATE, hiredate )/12 ) 근무년수
    , ROUND( MONTHS_BETWEEN( SYSDATE, hiredate )/12, 2) 근무년수 -- 소수점 두번째자리까지
FROM emp;

SELECT SYSDATE
    , CURRENT_DATE  
    , CURRENT_TIMESTAMP
FROM dual;

-- 2) TO_CHAR(날짜, 숫자)
-- [문제] emp 테이블에서 pay를 세자리 마다 콤마를 출력하고 앞에 통화기호를 붙이자.
SELECT num, name
    , basicpay, sudang
    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang, 'L9,999,999')
FROM insa;
--
SELECT 12345
    , TO_CHAR( 12345 ) -- 문자열'12345'
    , TO_CHAR( 12345, '9,999') -- ######(자리수부족할때)
    
    , TO_CHAR( 12345, '99,999' ) --  12,345
    , TO_CHAR( 12345, '99,999.00' ) --  12,345.00
    , TO_CHAR( 12345, '99,999.99' ) --  12,345.00  
    , TO_CHAR( 12345.123, '99,999.00' ) --  12,345.12
    , TO_CHAR( 12345.123, 'L99,999.00' ) -- ￦12,345.12
FROM dual;

SELECT TO_CHAR( -100, '9999PR') -- <100>
    , TO_CHAR( -100, '9999MI') --  100-
    , TO_CHAR(-100, 'S9999') -- -100
    , TO_CHAR(100, 'S9999') --  +100
FROM dual;

-- 변환 함수
-- 1) TO_NUMBER() X
-- 2) TO_CHAR(NUMBER) O,    TO_CHAR(날짜,문자)











