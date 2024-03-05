-- SCOTT
-- [문제] insa 테이블에서 70년대생(70~79년생)만 아래와 같이 출력(조회)
SELECT name
    --, ssn
    , CONCAT( SUBSTR( SSN, 1, 8), '*******') rrn -- ||
--    , EXTRACT( YEAR FROM 날짜 ) 안됨X
FROM insa 
-- '79' -> 79 형변환
WHERE TO_NUMBER(SUBSTR(ssn, 0, 2)) BETWEEN 70 AND 79;

WHERE SUBSTR(ssn, 0, 2) BETWEEN 70 AND 79; -- 자바에서 틀린내용(숫자와문자열의비교라서...)
WHERE SUBSTR(ssn, 1,1) = '7';

 SELECT name, substr(ssn,0,8) || '******' rrn
        , TO_DATE(SUBSTR(SSN, 0, 2), 'YY' ) --'YY'없을경우 오류남(YY만가능)
--        , substr(ssn,0,6) -- '771212'
--        , to_date(substr(ssn,0,6)) -- '77/12/12'
--        , extract (year from to_date(substr(ssn,0,6)) ) -- '77'
 FROM insa
-- WHERE extract (year from to_date(substr(ssn,0,6)) ) between 1970 and 1979 ; 복잡해서X

-- [문제] insa 테이블에서 사원명, 주민등록번호, 년도,월,일 성별 출력 ( STR 함수 )
DESC insa;
SELECT name, ssn, ibsadate
    , substr(ssn, 1, 2) YEAR
    , substr(ssn, 3, 2) MONTH
    , substr(ssn, 5, 2) "DATE" --DATE 예약어
            -- ORA-00923: FROM keyword not found where expected (DATE사용오류)
    , substr(ssn, 8, 1) GENDER
FROM insa;

-- 오라클의 예약어 : DATE
SELECT *
FROM dictionary
WHERE table_name LIKE '%WORD%';
--
SELECT *
FROM V$RESERVED_WORDS;

-- [문제] emp 테이블에서 입사일자(hiredate)가 81년도인 사원 정보 조회(출력)
--[3]
--String hiredate = "80/12/17";
--String year = hiredate.substring(0,2);
-- year = "80";

SELECT 'abcdefg'
    ,substr('abcdefg', 1, 2) -- ab 1 첫 문자
    ,substr('abcdefg', 0, 2) -- ab 0 첫 문자
    ,substr('abcdefg', 3) -- cdefg     
    ,substr('abcdefg', -5, 3) -- cde 
    ,substr('abcdefg', -1, 1) -- g 
From dual;

SELECT ename, hiredate -- '80/12/17'
    , SUBSTR( hiredate, 1, 2)
FROM emp
WHERE SUBSTR( hiredate, 1, 2) = '81' ;

--[2] DATE -> 입사년도만 얻어오기를 원함
-- 오늘 날짜의 년/월/일 출력: DATE(초), TIMESTAMP(나노세컨드, 시간대까지나타냄).
-- 자바 : Date d = new Date();    Calendar c = Calendar.getInstance();
--          d.getYear()                 c.get(Calendar.YEAR)
SELECT SYSDATE, CURRENT_TIMESTAMP 
    , EXTRACT( YEAR FROM SYSDATE ) --  2024 숫자 
    , TO_CHAR(SYSDATE, 'YYYY') -- '2024' 문자열:왼쪽 정렬 
    , TO_CHAR(SYSDATE, 'YY') -- '24'
    , TO_CHAR(SYSDATE, 'YEAR') -- 'TWENTY TWENTY-FOUR' 문자형태로
FROM dual;
-- 게시판 : 작성일 컬럼 SYSDATE 사용해서 초까지 저장.

SELECT ename, hiredate    
FROM emp
WHERE EXTRACT( YEAR FROM hiredate ) = '1981';
WHERE TO_CHAR( hiredate, 'YYYY' ) = '1981';

--[1]
-- 비교 연산자 : 숫자, 문자, 날짜(80/12/17)
DESC emp;
-- HIREDATE            DATE
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN '81/01/01' AND '81/12/31';
-- WHERE hiredate>= '81/01/01' AND hiredate<= '81/12/31';

-- [NOT] LIKE     SQL연산자 설명
-- 문자의 패턴 일치 여부 체크하는 연산자
-- 와일드카드( % _ )
-- %   0~여러 개의 문자
-- _   한 개의 문자
-- 와일드카드( % _ ) 를 일반문자처럼 사용하려면 ESCAPE 옵션을 사용하라.. ****

-- [문제] insa 테이블에서 70년대생(70~79년생)만 아래와 같이 출력(조회)
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7%';

-- [문제] insa 테이블에서 12월생만 아래와 같이 출력(조회)
SELECT name, ssn
FROM insa
WHERE SUBSTR( ssn, 3,2) = '12';
--
SELECT name, ssn
FROM insa
WHERE SSN LIKE '7_12%'
WHERE SSN LIKE '_12%';
WHERE REGEXP_LIKE( ssn, '^7[0-9]12' );
--
SELECT name, ssn
    , SUBSTR(ssn, 1,4)
    , TO_DATE ( SUBSTR(ssn, 0,4) , 'YYMM') -- 1일 설정
    , EXTRACT(MONTH FROM  TO_DATE ( SUBSTR(ssn, 0,4) , 'YYMM') ) MONTH
FROM insa  
WHERE EXTRACT(MONTH FROM  TO_DATE ( SUBSTR(ssn, 0,4) , 'YYMM') ) = '12';

-- [문제] insa 테이블에서 김씨 성을 가진 사원 모두 출력
SELECT name, ssn
FROM insa
WHERE name LIKE '김%';

-- [문제] insa 테이블에서 김씨 성 제외한 모든 사원 출력
SELECT name, ssn
FROM insa
WHERE name LIKE '_김_'; -- 이름의 가운데 글자가 '김'일경우 출력
WHERE name LIKE '%김_'; -- 이름의 끝에서 두 번째 문자가 '김'이면 출력
WHERE name LIKE '_김%'; -- 이름의 두 번째 문자가 '김'이면 출력
WHERE name LIKE '%김%'; -- 이름 속에 '김' 문자가 잇으면 출력
WHERE name NOT LIKE '김%';

-- "영업부".length() : 문자열 길이

-- [문제] 출신도가 서울, 부산, 대구 이면서 
--  전화번호에 5 또는 7이 포함된 자료 출력하되 
--  부서명의 마지막 부는 출력되지 않도록함. (이름, 출신도, 부서명, 전화번호)
SELECT  name
    , city
    , buseo
    , tel
    , substr( buseo, 1, length(buseo)-1)
FROM insa
WHERE city IN ('서울' ,'부산' , '대구') AND  tel LIKE '%5%' OR tel LIKE '%7%';

-- 동적 쿼리 --
FROM 노트북테이블
WHERE 조건 AND 조건 AND 조건 AND
            :
            
-- [ LIKE 연산자의 ESCAPE 옵션 설명 ] : 와일드카드를 일반문자처럼 사용할 때 사용
-- dept 테이블 구조 확인
DESC dept;
SELECT deptno, dname, loc
FROM dept;
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON

-- SQL 5가지 : DQL(SELECT), DDL, DML(INSERT, UPDATE, DELETE) + 완료COMMIT, 취소ROLLBACK
--            DCL, TCL

-- DML[INSERT] 새로운 부서를 추가...
DESC dept;

INSERT INTO 테이블명 [( 컬럼명, 컬럼명....)] VALUES (값,...);
COMMIT;

INSERT INTO dept ( deptno, dname, loc ) VALUES ( 50,'QC100%T','SEOUL');
-- 1 행 이(가) 삽입되었습니다.
-- 커밋 완료.
SELECT *
FROM dept;
-- 50	QC100%T	SEOUL -- 추가됨
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
--                      유일성 제약조건  PK_DEPT
INSERT INTO dept VALUES ( 50,'한글_나라','COREA'); -- 이미 있는 값은 추가불가
INSERT INTO dept VALUES ( 60,'한글_나라','COREA');
-- 1 행 이(가) 삽입되었습니다.

-- [문제] dept 테이블에서 부서명 검색을 하는 데
--                    부서명에 % 이 있는 부서 정보를 조회
--                    부서명에 _ 이 있는 부서 정보를 조회
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\'; -- 문자(%)로 인식함
WHERE dname LIKE '%\_%' ESCAPE '\'; -- 문자(_)로 인식함.
--WHERE dname LIKE '%_%'; -- 와일드카드(_)로 인식해 1글자이상 모든문자 출력

-- DML(INSERT, [UPDATE], DELETE) + 완료COMMIT, 취소ROLLBACK
UPDATE [스키마].테이블명
SET 컬럼=값, 컬럼=값...
[WHERE 조건절]; -- 조건절없으면, 모든 레코드를 수정하겠다는 의미.
UPDATE scott.dept
SET LOC='XXX';
--6개 행 이(가) 업데이트되었습니다.
ROLLBACK;
--
UPDATE scott.dept
SET LOC='KOREA'
WHERE deptno=60;
-- 1 행 이(가) 업데이트되었습니다.
COMMIT;

UPDATE scott.dept
SET LOC='COREA', DNAME = '한글나라'
WHERE deptno=60;
-- 1 행 이(가) 업데이트되었습니다.
COMMIT;
-- [문제] 30번 부서명, 지역명 -> 60번 부서명, 지역명으로 UPDATE 하자
-- ORA-00936: missing expression
UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno =30),loc=(SELECT loc FROM dept WHERE deptno =30)
WHERE deptno = 60;
--
UPDATE dept
SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno =30)
WHERE deptno = 60;
--
SELECT *
FROM dept;
--
COMMIT;

-- DML(INSERT, UPDATE, [DELETE]) + 완료COMMIT, 취소ROLLBACK
DELETE FROM [스키마].테이블명
[WHERE 조건절;] -- 모든 레코드 삭제

-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
-- 부서dept(10,20,30) : 부모테이블 / 사원emp : 자식테이블 => 부모테이블은 삭제할수 없음!!
-- 사원테이블이 가지고 있지않은 부서테이블(40,50)은 삭제가능.
DELETE FROM dept
Where deptno IN (50,60);
WHERE deptno=50 OR deptno=60;
--
COMMIT;
--
SELECT *
FROM dept;

SELECT *
FROM emp;

-- [문제] emp 테이블에서 sal의 10%를 인상해서 새로운 sal로 수정하세요.
SELECT *
FROM emp;

UPDATE emp
SET sal = sal*1.1;
-- 12개 행 이(가) 업데이트되었습니다.
ROLLBACK;

-- LIKE SQL 연산자 : % _ 패턴기호
-- REGEXP_LIKE 함수 : 정규표현식 
-- [문제] insa 테이블에서 성이 김씨, 이씨 만 사원 조회.
SELECT *
FROM insa
WHERE SUBSTR(name, 1, 1) = '김' OR  SUBSTR(name, 1, 1) = '이';

WHERE REGEXP_LIKE( name, '^[^김이]' );

WHERE REGEXP_LIKE( name, '[경자]$' );
WHERE REGEXP_LIKE( name, '^(김|이)' );
WHERE REGEXP_LIKE( name, '^[김이]' );
WHERE name LIKE '김%' OR name LIKE '이%';
WHERE SUBSTR(name, 1, 1)IN ('김', '이');
WHERE SUBSTR(name, 1, 1) = '김' OR  SUBSTR(name, 1, 1) = '이';

-- [문제] insa 테이블에서 70년대 남자 사원만 조회...
-- 성별 1,3,5,7,9 남자
-- gender % 2 == 1
-- 오라클 나머지 연산자 존재X
-- 나머지 구하는 함수 MOD()
SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE( ssn, '^7\d{5}-[13579]' );

--WHERE ssn LIKE '7%' AND SUBSTR(ssn, 8,1) IN (1,3,5,7.9) ;
--WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn, 8,1), 2) = 1 ;
--WHERE ssn LIKE '7_____-1%';
--WHERE REGEXP_LIKE( ssn, '^7[0-9]' ) AND (SUBSTR(ssn, 8,1) = 1);







