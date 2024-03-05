-- SCOTT
SELECT *
FROM tabs;

-- [오라클 DATA TYPE ] --
--1. CHAR 고정길이 2000 byte
--2. N+CHAR 고정길이 2000 byte
--3. VAR+CHAR2 가변길이 4000 byte --형식: VARCHAR2(SIZE BYTE|CHAR)
--4. N+VAR+CHAR2 가변길이 4000 byte
--5. LONG     가변길이 2GB
-- ORA-01438: value larger than specified precision allowed for this column
INSERT INTO dept (deptno, dname, loc ) VALUES( 100, 'QC', 'SEOUL' ); X
INSERT INTO dept (deptno, dname, loc ) VALUES( -20, 'QC', 'SEOUL' );
ROLLBACK;
DESC dept;

-- 6. NUMBER [(precision[,scale])] 숫자(정수, 실수)
--            p(정밀도) : 1~38     전체자릿수
--            s(규모) : -84~127   소수점 이하 자릿수
예)
NUMBER == NUMBER(38,127) -- 최고값
DEPTNO NUMBER(2) == NUMBER(2,0) == 2자리 정수   -99~99 정수
KOR NUMBER(3) == NUMBER(3,0) == 3자리 정수   -999~999 정수
                                            0 <=    <=100 -- 제약걸때 : 체크제약조건 사용
AVG NUMBER(5,2) == 100.00
    98.66666    == 98.67

-- 국어 점수를 랜덤하게 발생해서 저장
INSERT INTO 성적테이블 ( kor, eng, mat ) 
VALUES ( SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100) );

-- 학번(PK), 학생명, 국,영,수,총,평,등 컬럼명 -- 구분기준:프라이머 키(고유한 키,기본키,PK)==후보 키
-- ORA-00907: missing right parenthesis / 괄호() 또는 콤마(,)가 빠졌을 때 오류발생
CREATE TABLE tbl_score
(
    no      NUMBER(2)      NOT NULL     PRIMARY KEY -- PK==NN(NOT NULL) + UK(유일성 제약조건)
    , name  VARCHAR2(30)   NOT NULL              
    , kor   NUMBER(3)
    , eng   NUMBER(3)
    , mat   NUMBER(3)
    , tot   NUMBER(3)
    , avg   NUMBER(5,2)
    , rank  NUMBER(2)
);

INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 1, '홍길동', 90, 87, 88.89 );
--INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 2, '서영학', 990, -88, 65 );
INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 2, '서영학', 99, 88, 65 );
--INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 3, '김병훈', 1999, 68, 82 );
INSERT INTO tbl_score( no, name, kor, eng, mat ) VALUES( 3, '김병훈', 19, 68, 82 );
COMMIT;
-- 1 행 이(가) 삽입되었습니다.
ROLLBACK;
SELECT *
FROM tbl_score
ORDER BY RANK;

--
UPDATE tbl_score
SET eng = 0
WHERE no = 2;

-- 3명 학생의 학/이/국/영/수 입력. -> 총/평/등 처리
UPDATE tbl_score
SET tot = kor+eng+mat, avg=(kor+eng+mat)/3, rank = 1;
-- WHERE

-- [문제] 등수 처리하는 UPDATE 문 작성.
UPDATE tbl_score p
SET p.rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE c.tot > p.tot ) ;
--WHERE 필요x

-- FLOAT(p) 숫자자료형, 내부적으로 NUMBER 처리

-- 날짜 자료형
 ㄱ. DATE 7바이트, 고정길이, 초까지 저장
 ㄴ. TIMESTAMP(n) 0~9(nano)
    TIMESTAMP == TIMESTAMP(6) 00:00:00.000000
    
-- 이진데이터 저장     ???.png 이미지를 101010101010 이진데이터를 저장.
RAW(SIZE) 2000byte
LONG RAW  2GB

--
B + FILE    Binary 데이터를 외부에 file형태로 (264 -1바이트)까지 저장 
B + LOB    Binary 데이터를 4GB까지 저장 (4GB= (232 -1바이트)) 
C + LOB    Character 데이터를 4GB까지 저장 --게시판만들때사용
NC + LOB    Unicode 데이터를 4GB까지 저장  --게시판만들때사용
-- ***** 자료형 묶어서 정리하기
-- ex) 문자자료형-char, cLOB....등 / 데이터자료형-RAW, BFILE, BLOB...등

-- COUNT() OVER() 질의한 행의 누적된 결과값을 반환
-- ORA-00937: not a single-group group function
SELECT buseo, name, basicpay
--    , COUNT(*) OVER(ORDER BY basicpay ASC)
--    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC)

--    , SUM(basicpay) OVER(ORDER BY basicpay ASC)
--    , SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC)
    
    , AVG(basicpay) OVER(ORDER BY basicpay ASC)
    , AVG(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC)    
FROM insa;

-- [문제] 각 지역별(city) 급여 평균
-- ORA-00937: not a single-group group function
SELECT city, name, basicpay
--    , AVG(basicpay)
    , AVG(basicpay) OVER(PARTITION BY city ORDER BY city ASC)
    , basicpay - AVG(basicpay) OVER(PARTITION BY city ORDER BY city ASC)
FROM insa;

-- [테이블 생성, 수정, 삭제] + 레코드 추가, 수정, 삭제 --
-- 1) 테이블(table) ? 데이터저장소
2) DB 모델링 -> 테이블 생성
 예) 게시판의 게시글 저장하기 위한 테이블 생성
  ㄱ. 테이블명 : tbl_board
  ㄴ. 논리적컬럼     물리적컬럼명       자료형(크기)             널허용(필수입력)
   글번호(PK)      seq                 NUMBER  p38,s127        NOT NULL(NN)
   작성자          writer              VARCHAR2(20)             NN
   비밀번호(확인용) password            VARCHAR2(15)             NN
   제목           title                VARCHAR2(100)            NN   
   내용           content              CLOB                    
   작성일          regdate             DATE                    DEFAULT SYSDATE
   조회수          readno              NUMBER                  DEFAULT 0
   등등
   
【간단한형식】
    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
      ( 
        열이름  데이터타입 [DEFAULT 표현식] [제약조건] 
       [,열이름  데이터타입 [DEFAULT 표현식] [제약조건] ] 
       [,...]  
      ); 
      
    예)TEMPORARY 임시 테이블 생성 -> 접속(세션) 끊어지면(로그아웃시) 임시테이블 사라짐
--    CREATE GLOBAL TEMPORARY TABLE tbl_board
    CREATE TABLE tbl_board
    (
        seq           NUMBER            NOT NULL     PRIMARY KEY--유일성제약조건
        , writer      VARCHAR2(20)      NOT NULL
        , password    VARCHAR2(15)      NOT NULL
        , title       VARCHAR2(100)     NOT NULL
        , content     CLOB           
        , regdate     DATE              DEFAULT SYSDATE
    );

DESC tbl_board;

-- 테이블 생성 : CREATE TABLE (DDL)
-- 테이블 수정 : ALTER TABLE (DDL)
    --? alter table ... add 컬럼,제약조건      추가
    --? alter table ... modify 컬럼   수정
    --? alter table ... drop[constraint] 제약조건   삭제
    --? alter table ... drop column 컬럼 삭제
-- 테이블 삭제 : DROP TABLE (DDL)
SELECT *
FROM tbl_board;
--
INSERT INTO tbl_board ( seq,writer,password,title,content,regdate)
VALUES                ( 1, '홍길동', '1234', 'test-1', 'test-1', SYSDATE );
COMMIT;
-- ORA-00001: unique constraint (SCOTT.SYS_C007023) violated 
--            유일성 제약조건                         위배된다.
INSERT INTO tbl_board ( seq,writer,password,title,content,regdate)
VALUES                ( 2, '권맑음', '1234', 'test-2', 'test-2', SYSDATE );
COMMIT;
--            유일성 제약조건                         위배된다.
INSERT INTO tbl_board 
VALUES                ( 3, '김영진', '1234', 'test-3', 'test-3', SYSDATE );
COMMIT;
--            유일성 제약조건                         위배된다.
-- ORA-00947: not enough values
INSERT INTO tbl_board ( seq,writer,password,title,content)
VALUES                ( 4, '이동찬', '1234', 'test-4', 'test-4' );
COMMIT;
--            유일성 제약조건                         위배된다.  
INSERT INTO tbl_board ( writer,seq,password,title,content,regdate)
VALUES                ( '이시은',5,'1234', 'test-5', 'test-5', null );
COMMIT;
--
SELECT *
FROM tbl_board;

-- 제약조건이름을 지정해서 제약조건을 설정할 수 있고
-- , 제약조건이름 지정하지 않으면 SYS_xxx 이름으로 자동 부여된다.
-- 제약조건이름 : SCOTT.SYS_C007023
SELECT *
FROM user_constraints
WHERE table_name LIKE '%BOARD'; -- 제약조건확인
FROM tabs;
FROM user_tables;

-- 테이블 수정 : 조회수 컬럼 (1개) 추가...
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0; -- 1개 칼럼만 추가할 경우 () 괄호 생략 가능하다.
-- ADD ();
DESC tbl_board;
-- 
SELECT *
FROM tbl_board;

--
INSERT INTO tbl_board ( writer,seq,password,title)
VALUES                ( '이새롬',( SELECT NVL(MAX(seq),0)+1 FROM tbl_board) ,'1234', 'test-6' );
COMMIT;
-- content  NULL 인 경우 "내용 없음" UPDATE.
UPDATE tbl_board
SET content = '내용 없음'
WHERE content IS NULL ;
--
SELECT *
FROM tbl_board;

-- 게시판의 작성자(WRITER   NOT NULL   VARCHAR2(20->40) SIZE 확장(O) )
-- 컬럼의 자료형의 크기를 수정.
DESC tbl_board;
-- ORA-00907: missing right parenthesis 
-- 제약조건은 수정할 수 없다. ->  오류발생 ( 삭제 -> 새로 추가 ) NOT NULL 삭제
-- NOT NULL 제약조건의 한 일종.
ALTER TABLE tbl_board
MODIFY ( WRITER VARCHAR2(40) );
-- WRITER  NOT NULL  VARCHAR2(40)

-- [ 컬럼명을( title -> subject ) 수정 ]
--     ㄴ 컬럼이름의 직접적인 변경은 불가능하다.
-- ALTER TABLE 테이블명  MODIFY () ; X
SELECT title AS subject, content
FROM tbl_board;
--
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;
-- Table TBL_BOARD이(가) 변경되었습니다. -- SUBJECT  NOT NULL VARCHAR2(100)
DESC tbl_board;

-- [ 기타 여러 가지 설명  bigo 컬럼 새로 추가 -> 컬럼 삭제 ]
ALTER TABLE tbl_board
ADD bigo VARCHAR2(100) ; 
--
DESC tbl_board;
--
SELECT *
FROM tbl_board;
--
ALTER TABLE tbl_board
DROP COLUMN bigo;

-- [ 테이블의 이름을 tbl_board -> tbl_test 로 변경 ]
RENAME tbl_board TO tbl_test;
-- 테이블 이름이 변경되었습니다.
SELECT *
FROM tabs;
-- 테이블 삭제
DROP TABLE tbl_test;

-- 테이블 생성하는 방법 : 6가지
-- [ 3. Subquery를 이용한 table 생성 ]
--      ㄴ 이미 존재하는 테이블을 이용해서 => 새로운 테이블 생성 + 데이터(레코드) 추가
--【형식】
--	CREATE TABLE 테이블명 [컬럼명 (,컬럼명),...]
--	AS subquery;
--? 다른 테이블에 존재하는 특정 컬럼과 행을 이용한 테이블을 생성하고 싶을 때 사용
--? Subquery의 결과값으로 table이 생성됨
--? 컬럼명을 명시할 경우 subquery의 컬럼수와 테이블의 컬럼수를 같게해야 한다.
--? 컬럼을 명시하지 않을 경우, 컬럼명은 subquery의 컬럼명과 같게 된다.
--? subquery를 이용해 테이블을 생성할 때 CREATE TABLE 테이블명 뒤에 컬럼명을 명시해 주는 것이 좋다.

-- 예) emp 테이블을 이용해서
--    30번 부서원들의 empno, ename, hiredate, job 만 새로운 테이블 생성
CREATE TABLE tbl_emp30 (no, name, hdate, job, pay)
AS 
(
    SELECT empno, ename, hiredate, job , sal+NVL(comm,0) pay
    FROM emp
    WHERE deptno = 30
)
-- Table TBL_EMP30이(가) 생성되었습니다.
-- PAY      NUMBER : 자동으로 적당한 자료형으로 설정된다.
DESC tbl_emp30;
SELECT *
FROM tbl_emp30;
-- 제약조건은 복사되지 않는다.
-- ㄱ. emp 테이블 제약조건 확인
-- ㄴ. tbl_emp30 테이블 제약조건 확인
-----------------------------------------------------
-- 예) 기존 테이블을 -> 새로운 테이블 생성 + 레코드 필요X ( 기존 테이블의 구조만 복사 )
CREATE TABLE tbl_emp20 -- ( 컬럼...)
AS 
(
    SELECT *
    FROM emp
    WHERE 1 = 0 -- 조건절 항상 거짓
)

SELECT *
FROM tbl_emp20;
--
DROP TABLE tbl_emp20;
-- [문제] emp, dept 테이블을 이용해서
-- deptno, dname, empno, ename, hiredate, pay, grade 컬럼을
-- 가진 새로운 테이블 생성. ( tbl_empgrade )
-- ( 조인 사용 )
-------내가 풀어봄
CREATE TABLE tbl_empgrade (deptno, dname, empno, ename, hiredate, pay, grade )
AS 
(
    SELECT 
    d.deptno, d.dname
    ,empno, ename, hiredate
    , sal+NVL(comm,0) pay
    FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
)
-------------------------------[해설]
-- JOIN 조건 : dept.deptno = emp.deptno 이콜조인
--            emp = salgrade            NON 이콜 조인 BETWEEN AND
-- dept : deptno, dname
-- emp : deptno, empno, ename, hiredate, pay
-- salgrade : grade
CREATE TABLE tbl_empgrade
AS
(SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0) pay
     , s.losal || ' ~ ' || s.hisal sal_range , grade
FROM dept d JOIN emp e ON d.deptno = e.deptno
            JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
);             
        --  JOIN 테이블명 s ON 조인조건
        --  JOIN 테이블명 s ON 조인조건
        --            :
--
SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0) pay
     , s.losal || ' ~ ' || s.hisal sal_range , grade
FROM dept d, emp e, salgrade s
WHERE d.deptno = e.deptno AND e.sal BETWEEN s.losal AND s.hisal;
--
SELECT *
FROM tbl_empgrade;


-- 테이블 삭제
DROP TABLE TBL_EMPGRADE; -- 휴지통 이동
PURGE RECYCLEBIN; -- 휴지통 비우기

-- 테이블 삭제 + 완전 삭제 ( 휴지통비우기 )
DROP TABLE TBL_EMPGRADE PURGE; -- 완전 테이블 삭제 XE

-- INSERT 문 --
DML - insert, update, delete
INSERT INTO 테이블명 [( 컬럼명, 컬러명,... )] VALUES (컬럼값,컬럼값...);
COMMIT;
ROLLBACK;
-- [MultiTable INSERT 문] 4가지 종류
--1) unconditional insert all 조건이 없는 INSERT ALL
CREATE TABLE tbl_dept10 AS ( SELECT * FROM dept WHERE 1=0 );
CREATE TABLE tbl_dept20 AS ( SELECT * FROM dept WHERE 1=0 );
CREATE TABLE tbl_dept30 AS ( SELECT * FROM dept WHERE 1=0 );
CREATE TABLE tbl_dept40 AS ( SELECT * FROM dept WHERE 1=0 );

DESC tbl_dept10;
DESC tbl_dept20;
DESC tbl_dept30;
DESC tbl_dept40;

-- unconditional insert all 문
--INSERT INTO 테이블명 (컬럼명...) VALUES (컬럼값...);
-- 서브쿼리의 모든 레코드 들을 조건없이 모든 테이블에 INSERT 하는 문
INSERT ALL
    INTO tbl_dept10 VALUES (deptno, dname, loc)
    INTO tbl_dept20 VALUES (deptno, dname, loc)
    INTO tbl_dept30 VALUES (deptno, dname, loc)
    INTO tbl_dept40 VALUES (deptno, dname, loc)
 SELECT deptno, dname, loc
 FROM dept;

SELECT *
FROM tbl_dept40;

--2) conditional insert all   조건이 있는 INSERT ALL
--    emp ->    tbl_emp10,tbl_emp20, tbl_emp30, tbl_emp40
CREATE TABLE tbl_emp10
AS
( SELECT * FROM emp WHERE 1=0 );

CREATE TABLE tbl_emp20
AS
( SELECT * FROM emp WHERE 1=0 );

CREATE TABLE tbl_emp30
AS
( SELECT * FROM emp WHERE 1=0 );

CREATE TABLE tbl_emp40
AS
( SELECT * FROM emp WHERE 1=0 );


INSERT ALL
   WHEN deptno = 10 THEN
     INTO tbl_emp10 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
   WHEN deptno = 20 THEN  
     INTO tbl_emp20 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
   WHEN deptno = 30 THEN
     INTO tbl_emp30 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
   ELSE
   INTO tbl_emp40 VALUES (empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * FROM emp;

SELECT * FROM tbl_emp10;
SELECT * FROM tbl_emp20;
SELECT * FROM tbl_emp30;

--3) conditional(조건이 있는) first insert  
INSERT ALL --/ FIRST
    WHEN deptno = 10 THEN
        INTO tbl_emp10 VALUES ()
    -- 7934	MILLER	CLERK	7782	82/01/23	1300		10    
    WHEN job = 'CLERK' THEN
        INTO tbl_emp_clerk VALUES ()    
    -- 7934	MILLER	CLERK	7782	82/01/23	1300		10
    ELSE
        INTO tbl_else VALUES ()
SELECT * FROM emp;
--
SELECT * FROM emp
WHERE deptno = 10 AND job = 'CLERK'; 

--4) pivoting insert          
CREATE TABLE sales( -- 판매 테이블
     employee_id       number(6), -- 판매를 한 사원ID
     week_id            number(2),-- 판매한 주
     sales_mon          number(8,2), -- 월 판매한 수량
     sales_tue          number(8,2),
     sales_wed          number(8,2),
     sales_thu          number(8,2),
     sales_fri          number(8,2)  -- 금 판매한 수량
);

INSERT INTO sales VALUES(1101,4,100,150,80,60,120);
Insert Into sales VALUES(1102,5,300,300,230,120,150);
COMMIT;
--
SELECT * 
FROM sales;
--
CREATE TABLE sales_data(
     employee_id        number(6),
     week_id            number(2),
     sales              number(8,2));
-- Table SALES_DATA이(가) 생성되었습니다.
INSERT ALL
    INTO sales_data VALUES (employee_id, week_id, sales_mon)
    INTO sales_data VALUES (employee_id, week_id, sales_tue)
    INTO sales_data VALUES (employee_id, week_id, sales_wed)
    INTO sales_data VALUES (employee_id, week_id, sales_thu)
    INTO sales_data VALUES (employee_id, week_id, sales_fri)
SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed, sales_thu, sales_fri
FROM sales;

SELECT *
FROM sales_data;

COMMIT;

DROP TABLE tbl_emp10 PURGE;
DROP TABLE tbl_emp20 PURGE;
DROP TABLE tbl_emp30 PURGE;
DROP TABLE tbl_emp40 PURGE;

-- TRUNCATE 문
DROP TABLE SALES; -- 테이블 자체가 삭제
DELETE FROM sales_data; -- 테이블 안의 모든 레코드 삭제
ROLLBACK;
SELECT * FROM sales_data;
-- 
TRUNCATE TABLE sales_data; -- 테이블 안의 모든 레코드 삭제( 롤백,삭제 + 자동커밋 동시수행(삭제완료)) - 삭제후다시돌릴수 없음
DROP TABLE sales_data PURGE;

[문제1] insa 테이블에서 num, name 컬럼만을 복사해서 
      새로운 tbl_score 테이블 생성
      (  num <= 1005 )
      
CREATE TABLE    tbl_score 
AS
(

   SELECT num, name
   FROM insa
   WHERE num <= 1005
)
-- Table TBL_SCORE이(가) 생성되었습니다.

[문제2] tbl_score 테이블에   kor,eng,mat,tot,avg,grade, rank 컬럼 추가
( 조건   국,영,수,총점은 기본값 0 )
(       grade 등급  char(1 char) )

ALTER TABLE tbl_score
ADD (
          kor NUMBER(3) DEFAULT 0
         ,eng NUMBER(3) DEFAULT 0
         ,mat NUMBER(3) DEFAULT 0
         ,tot NUMBER(3) DEFAULT 0
         ,avg NUMBER(5,2) 
         ,grade CHAR(1 CHAR)
         , rank NUMBER(3)
    );

DESC tbl_score;

CREATE TABLE
ALTER TABLE  컬럼 추가, 제약조건 추가, 수정  등등
DROP TABLE   PURGE;

[문제3] 1001~1005 
  5명 학생의 kor,eng,mat점수를 임의의 점수로 수정(UPDATE)하는 쿼리 작성.
  
  SELECT *
  FROM tbl_score;
  
  UPDATE tbl_score
  SET kor = TRUNC( dbms_random.value(0, 101) )
     , eng= TRUNC( dbms_random.value(0, 101) )
     , mat = TRUNC( dbms_random.value(0, 101) );
  COMMIT;
[문제4] 1005 학생의 k,e,m  -> 1001 학생의 점수로 수정 (UPDATE) 하는 쿼리 작성.

SELECT kor, eng, mat 
FROM tbl_score
WHERE num = 1001;

UPDATE tbl_score
SET (kor, eng, mat) = (SELECT kor, eng, mat 
                        FROM tbl_score
                        WHERE num = 1001)
WHERE num = 1005;
COMMIT;
[문제5] 모든 학생의 총점, 평균을 수정...
     ( 조건 : 평균은 소수점 2자리 )
UPDATE tbl_score
SET tot = kor + eng+mat
  , avg = (kor+eng+mat)/3
-- WHERE X

[문제6] 등급(grade) CHAR(1 char)  'A','B','c', 'D', 'F'
--  90 이상 A
--  80 이상 B
--  0~59   F
SELECT avg , avg/10, TRUNC( avg/10 )
FROM tbl_score;

DECODE ( TRUNC( avg/10 ), 10, 'A', 9, 'A', 8, 'B', 7,'C', 6, 'D', 'F')

UPDATE tbl_score
SET grade = CASE
               WHEN avg >= 90 THEN 'A'
               WHEN avg >= 80 THEN 'B'
               WHEN avg >= 70 THEN 'C'
               WHEN avg >= 60 THEN 'D'
               ELSE 'F'
            END;
COMMIT;
--
INSERT ALL
    WHEN avg >= 90 THEN
         INTO tbl_score (grade) VALUES( 'A' )
    WHEN avg >= 80 THEN
         INTO tbl_score (grade) VALUES( 'B' )
    WHEN avg >= 70 THEN
         INTO tbl_score (grade) VALUES( 'C' )
    WHEN avg >= 60 THEN
         INTO tbl_score (grade) VALUES( 'D' )
    ELSE
         INTO tbl_score (grade) VALUES( 'F' )
SELECT avg FROM tbl_score ; 



[문제7] tbl_score 테이블의 등수 처리.. ( UPDATE) 
UPDATE tbl_score p
-- SET  rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE c.tot > p.tot );
SET rank = (
               SELECT t.r
               FROM (
                   SELECT num, tot, RANK() OVER(ORDER BY tot DESC ) r
                   FROM tbl_score
               ) t
               WHERE t.num =p.num
           );
-- WHERE
COMMIT;
--
SELECT empno, ename, sal
  , ROW_NUMBER() OVER( ORDER BY sal DESC ) rn_rank
  , RANK() OVER( ORDER BY sal DESC ) r_rank
  , DENSE_RANK() OVER( ORDER BY sal DESC ) r_rank
FROM emp;

SELECT * 
FROM tbl_score;
-- [문제8] 모든 학생들의 영어 점수 : 30점 추가...
76
26
21
95
76
UPDATE tbl_score
SET eng = CASE  
           WHEN eng + 30 > 100 THEN  100
           ELSE  eng+30
          END;
ROLLBACK;

SELECT * FROM tbl_score;
19
68
86 X
46
19
ROLLBACK;
-- [문제] 1001~1005 학생 중에 남학생들만 5점씩 증가... 
UPDATE tbl_score t
SET kor = kor + 5
where t.num = (
                select num 
                from insa 
                where MOD(substr(ssn,8,1), 2)=1 and t.num =num
            );
WHERE num = ANY( SELECT num
                FROM insa
                WHERE num <= 1005 AND MOD(SUBSTR(ssn,8,1),2)=1);
WHERE num IN ( SELECT num
                FROM insa
                WHERE num <= 1005 AND MOD(SUBSTR(ssn,8,1),2)=1);
--
(월) : MERGE(병합)/제약조건/  조인/계층적 쿼리
(화) : DB 모델링 + 세미프로젝트
(수) : DB 모델링 + 발표
(목) : PL/SQL

프로젝트 요구/ 금/토/일+
(월)/(화) PL/SQL 수업 X
수/목/금/토/일/월/화  -> 발표 수/목/금   월 
