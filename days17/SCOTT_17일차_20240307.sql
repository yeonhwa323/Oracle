-- SCOTT
-- (목) : PL/SQL 동적쿼리, 패키지

-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명        VARCHAR2(30)  NOT NULL
  ,제조사        VARCHAR2(30)  NOT NULL
  ,소비자가격     NUMBER
  ,재고수량       NUMBER DEFAULT 0
);

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호      NUMBER PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES 상품(상품코드)
  ,입고일자     DATE
  ,입고수량      NUMBER
  ,입고단가      NUMBER
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      NUMBER  PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES 상품(상품코드)
  ,판매일자      DATE
  ,판매수량      NUMBER
  ,판매단가      NUMBER
);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;

SELECT * FROM 상품;
-----------------------------------------------------------
문제1) 입고 테이블에 상품이 입고가 되면 자동으로 상품 테이블의 재고수량이  update 되는 트리거 생성 + 확인
-- ut_insIpgo
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER
    INSERT ON 입고
FOR EACH ROW -- 행 레벨 트리거
BEGIN
    -- 입고 :NEW.상품코드, :NEW.입고수량
    UPDATE 상품
    SET 재고수량 = 재고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
    --COMMIT/ROLLBACK 필요X
--EXCEPTION
END;
-- Trigger UT_INSIPGO이(가) 컴파일되었습니다.

-- 입고 테이블에 데이터 입력
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);
COMMIT ;
-------------------------------------------------------------
SELECT * FROM 입고;
SELECT * FROM 상품;

문제2) 입고 테이블에서 입고가 수정되는 경우    상품테이블의 재고수량 수정. 
-- ut_updIpgo
-- 입고수량 : 25 :OLD.입고수량 / 30 :NEW.입고수량  
CREATE OR REPLACE TRIGGER ut_updIpgo
AFTER
    UPDATE ON 입고
FOR EACH ROW -- 행 레벨 트리거
BEGIN
    -- :NEW.상품코드, :NEW.입고수량
    UPDATE 상품
    SET 재고수량 = 재고수량 -:OLD.입고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
    --COMMIT/ROLLBACK 필요X
--EXCEPTION
END;

UPDATE 입고 
SET 입고수량 = 30 
WHERE 입고번호 = 5;
COMMIT;
------------------------------
--문제3) 입고 테이블에서 입고가 취소되어서 입고 삭제. 상품테이블의 재고수량 수정.
-- ut_delIpgo
CREATE OR REPLACE TRIGGER ut_delIpgo
AFTER
    DELETE ON 입고
FOR EACH ROW 
BEGIN
    -- :NEW.상품코드, :NEW.입고수량
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량
    WHERE 상품코드 = :OLD.상품코드;    
--EXCEPTION
END; 
--
DELETE FROM 입고
WHERE 입고번호 = 5;
COMMIT;
--
SELECT * FROM 입고;
SELECT * FROM 상품;

-- 문제4) 판매테이블에 판매가 되면 (INSERT)
--       상품테이블의 재고수량이 수정
-- ut_insPan
CREATE OR REPLACE TRIGGER ut_insPan
BEFORE
    INSERT ON 판매
FOR EACH ROW -- 행 레벨 트리거
DECLARE
    vqty 상품.재고수량%TYPE;
BEGIN
    SELECT 재고수량 INTO vqty
    FROM 상품
    WHERE  상품코드 = :NEW.상품코드;
    
    IF vqty < :NEW.판매수량 THEN
        RAISE_APPLICATION_ERROR(-20007, '재고수량 부족으로 판매 오류');
    ELSE
        UPDATE 상품
        SET 재고수량 = 재고수량 - :NEW.판매수량
        WHERE 상품코드 = :NEW.상품코드 ;
    END IF;
    --COMMIT/ROLLBACK 필요X
--EXCEPTION
END; 
--
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (2, 'AAAAAA', '2004-11-12', 50, 1000000);
COMMIT;

-- 문제5) 판매번호 1   20   판매수량 5 -> 10
UPDATE 판매
SET 판매수량 = 10
WHERE 판매번호 = 1;
-- 상품 테이블에도 재고수량 수정 트리거
-- AAA          20   - 5    = 15
-- ut_updPan
CREATE OR REPLACE TRIGGER ut_updPan
BEFORE
    INSERT ON 판매
FOR EACH ROW 
DECLARE
    vqty 상품.재고수량%TYPE;
BEGIN
    SELECT 재고수량 INTO vqty -- 15
    FROM 상품
    WHERE  상품코드 = :NEW.상품코드;
    -- 15 + 5
    IF (vqty + :OLD.판매수량) < :NEW.판매수량 THEN
        RAISE_APPLICATION_ERROR(-20007, '재고수량 부족으로 판매 오류');
    ELSE
        UPDATE 상품
        SET 재고수량 = 재고수량 + :OLD.판매수량 - :NEW.판매수량
        WHERE 상품코드 = :NEW.상품코드 ;
    END IF;
    --COMMIT/ROLLBACK 필요X
--EXCEPTION
END;
--
select * from 상품 ;
select * from 판매 ;

-- 문제) 판매번호 1   (AAAAA  10) 판매 취소 (DELETE)
--      상품테이블에 재고수량 수정
--ut_delPan
CREATE OR REPLACE TRIGGER ut_delPan
AFTER
    DELETE ON 판매
FOR EACH ROW 
BEGIN

        UPDATE 상품
        SET 재고수량 = 재고수량 + :OLD.판매수량 
        WHERE 상품코드 = :OLD.상품코드 ;

--EXCEPTION
END;

DELETE FROM 판매
WHERE 판매번호 = 1;
--------------------------------------------------------------
-- 패키지
--   ㄴ 자주 사용되는 여러 procedure, function들을 하나의 package묶어서 관리에 편리토록 함 (자바의 package 와 유사)
-- DBMS 출력
--DBMS_OUTPUT.PUT();
--DBMS_OUTPUT.PUT_LINE();

-- 패키지의 명세서 부분
CREATE OR REPLACE PACKAGE employee_pkg 
AS 
    PROCEDURE up_print_ename
    (
        pempno NUMBER
    ); 
    PROCEDURE up_print_sal(pempno NUMBER); 
    FUNCTION uf_age
    (
        prrn VARCHAR2
        , ptype IN NUMBER -- 1(세는 나이)  0(만나이)
    )
    RETURN NUMBER;
END employee_pkg; 
-- Package EMPLOYEE_PKG이(가) 컴파일되었습니다.

-- 패키지의 명세서 부분
CREATE OR REPLACE PACKAGE employee_pkg 
AS 
     PROCEDURE up_printename
     (
       p_empno NUMBER
      ); 
     PROCEDURE up_printsal(p_empno NUMBER); 
     FUNCTION uf_age
     (
       prrn IN VARCHAR2 
      ,ptype IN NUMBER 
     )
     RETURN NUMBER;
END employee_pkg;
-- Package EMPLOYEE_PKG이(가) 컴파일되었습니다.
CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS 
   
      procedure UP_PRINTENAME(p_empno number) is 
        l_ename emp.ename%type; 
      begin 
        select ename 
          into l_ename 
          from emp 
          where empno = p_empno; 
       dbms_output.put_line(l_ename); 
     exception 
       when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end UP_PRINTENAME; 
  
   procedure UP_PRINTSAL(p_empno number) is 
     l_sal emp.sal%type; 
   begin 
     select sal 
       into l_sal 
       from emp 
       where empno = p_empno; 
     dbms_output.put_line(l_sal); 
   exception 
     when NO_DATA_FOUND then 
       dbms_output.put_line('Invalid employee number'); 
   end UP_PRINTSAL; 
   
   FUNCTION uf_age
(
   prrn IN VARCHAR2 
  ,ptype IN NUMBER --  1(세는 나이)  0(만나이)
)
RETURN NUMBER
IS
   ㄱ NUMBER(4);  -- 올해년도
   ㄴ NUMBER(4);  -- 생일년도
   ㄷ NUMBER(1);  -- 생일 지남 여부    -1 , 0 , 1
   vcounting_age NUMBER(3); -- 세는 나이 
   vamerican_age NUMBER(3); -- 만 나이 
BEGIN
   -- 만나이 = 올해년도 - 생일년도    생일지남여부X  -1 결정.
   --       =  세는나이 -1  
   -- 세는나이 = 올해년도 - 생일년도 +1 ;
   ㄱ := TO_CHAR(SYSDATE, 'YYYY');
   ㄴ := CASE 
          WHEN SUBSTR(prrn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(prrn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(prrn,1,2);
   ㄷ :=  SIGN(TO_DATE(SUBSTR(prrn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (생일X)

   vcounting_age := ㄱ - ㄴ +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ㄷ, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ㄷ
                                         WHEN 1 THEN -1
                                         ELSE 0
                                        END;

   IF ptype = 1 THEN
      RETURN vcounting_age;
   ELSE 
      RETURN (vamerican_age);
   END IF;
--EXCEPTION
END uf_age;
  
END employee_pkg; 
--
select name, ssn
    , employee_pkg.uf_age(ssn,1) age
from insa;

--------------------------------------------------------------
-- 동적 SQL ****
--------------------------------------------------------------
동적 배열
int [] m ; -- 배열의 크기 X
int size = 10;
m = new int[size];
-- 동적 SQL(쿼리)
예) 일반적인 게시판에서 검색
    1) 제목으로 검색 WHERE title LIKE '%검색어%'
    2) 작성자       WHERE writer LIKE '%검색어%'
    3) 내용         WHERE content LIKE '%검색어%'
    4) 제목 & 내용  WHERE title LIKE '%검색어%' OR content LIKE '%검색어%'
    
-- 실행 시점에 SQL이 미 결정 상태
-- 1) 동적 쿼리(SQL)를 사용하는 3가지 경우
        ㄱ. 컴파일 시에 SQL문장이 확정되지 않은 경우( 가장 많이 사용하는 경우 )
        예) WHERE 조건절...
        ㄴ. PL/SQL 블럭 안에서 DDL문을 사용하는 경우
        CREATE, ALTER, DROP 문
        예) 지정한 칼럼으로 동적으로 게시판 테이블 생성.
            필요시 마다 여러 개의 게시판 테이블 생성.
        ㄷ. PL/SQL 블럭 안에서
        ALTER SYSTEM/SESSION 명령어를 사용할 경우
-- 2) PL/SQL 동적 쿼리를 사용하는 2가지 방법.
    ㄱ. DBMS_SQL 패키지 설명X - 따로 필요시 책보기
    ㄴ. EXECUTE IMMEDIATE 문  설명O
     형식)
        EXEC[UTE] IMMEDIATE 동적쿼리문
        [INTO 변수명,변수명...]
        [USING [IN/OUT/IN OUT] 파라미터,파라미터...]
-- 3) 예
-- 익명 프로시저 문법.

DECLARE
    vsql VARCHAR2(1000);
    
    vdeptno     emp.deptno%TYPE;
    vempno    emp.empno%TYPE;
    vename    emp.ename%TYPE;
    vjob      emp.job%TYPE;
    
BEGIN
    vsql := 'SELECT deptno, empno, ename, job';
    vsql := vsql || 'FROM emp';
    vsql := vsql || 'WHERE empno = 7369';

    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob;

    DBMS_OUTPUT.PUT_LINE (vdeptno|| ', ' || vempno || ', ' || vename|| ', ' || vjob );
--EXCEPTION
END ;

-- 저장 프로시저 2
CREATE OR REPLACE PROCEDURE up_ndsemp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000);
    
    vdeptno     emp.deptno%TYPE;
    vempno    emp.empno%TYPE;
    vename    emp.ename%TYPE;
    vjob      emp.job%TYPE;
    
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || 'FROM emp ';
   -- vsql := vsql || 'WHERE empno = pempno'; X
   -- vsql := vsql || 'WHERE empno = ' || pempno;
    vsql := vsql || 'WHERE empno = ' || pempno;

    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob
            USING IN pempno ;

    DBMS_OUTPUT.PUT_LINE (vdeptno|| ', ' || vempno || ', ' || vename|| ', ' || vjob );
--EXCEPTION
END ;
--Procedure UP_NDSEMP이(가) 컴파일되었습니다.

CREATE OR REPLACE PROCEDURE up_ndsemp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000);
    
    vdeptno     emp.deptno%TYPE;
    vempno    emp.empno%TYPE;
    vename    emp.ename%TYPE;
    vjob      emp.job%TYPE;
    
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || 'FROM emp ';
   -- vsql := vsql || 'WHERE empno = pempno'; X
   vsql := vsql || 'WHERE empno = : pempno';

    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob;

    DBMS_OUTPUT.PUT_LINE (vdeptno|| ', ' || vempno || ', ' || vename|| ', ' || vjob );
--EXCEPTION
END ;

EXEC UP_NDSEMP( 7369 );

-- 예제2. dept 테이블에 새로운 부서 추가하는 저장 프로시저( 동적 쿼리 사용 )
SELECT *
FROM dept ;
--
CREATE OR REPLACE PROCEDURE up_ndsInsDept
(
    pdname  dept.dname%TYPE := NULL
    , ploc  dept.loc%TYPE := NULL
)
IS
    vsql  VARCHAR2(1000);
    vdeptno  dept.deptno%TYPE;
BEGIN
    SELECT MAX( deptno ) +10 INTO vdeptno
    FROM dept;

    vsql := 'INSERT INTO dept( deptno, dname, loc )';
    vsql := vsql || 'values (:vdeptno, :pdname, :ploc )';
    
    EXECUTE IMMEDIATE vsql
    -- into
    USING vdeptno, pdname, ploc;
    
    commit;
    dbms_output.put_line('INSERT 성공!!!');
           
END;

EXEC UP_NDSINSDEPT('QC', 'SEOUL');

DELETE FROM dept WHERE deptno = 50;
COMMIT;

-- 동적SQL - DDL문 사용 예제

DECLARE
    vtablename VARCHAR2(100);
    vsql VARCHAR2(1000);
BEGIN
    vtablename := 'tbl_board';
    
    vsql := 'CREATE TABLE ' || vtablename ;
    -- vsql := 'CREATE TABLE : vtablename ' ; - using문 사용
    vsql := vsql || '(' ;
    vsql := vsql || ' id NUMBER PRIMARY KEY' ;
    vsql := vsql || ' , name VARCHAR2(20)' ;
    vsql := vsql || ')' ;
    
    EXECUTE IMMEDIATE vsql;
    -- INTO -> 한개의 레코드일 경우
    -- using vtablename;
    
END;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM tabs;

-- OPEN ~ FOR 문 : 동적 쿼리 실행 -> 실행결과물(여러 개의 레코드) + 커서 처리..
CREATE OR REPLACE PROCEDURE up_ndsSelEmp
(
    pdeptno  emp.deptno%TYPE
)
IS
    vsql  VARCHAR2(2000);
    vcur  SYS_REFCURSOR;    -- 커서 타입으로 변수 선언 9i REF CURSOR
    vrow  emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' where deptno = :pdeptno ';
    
    -- EXECUTE IMMEDIATE stmt INTO X USING 파라미터...
    -- OPEN ~ FOR 문
    OPEN vcur FOR vsql USING pdeptno ;
    LOOP
        FETCH vcur INTO vrow ;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vrow.empno || ' ' || vrow.ename );
    END LOOP;
    CLOSE vcur;
END;
--Procedure UP_NDSSELEMP이(가) 컴파일되었습니다.
EXEC UP_NDSSELEMP(30);
EXEC UP_NDSSELEMP(20);
-- emp 테이블에서 검색 기능 구현
-- 1) 검색조건 : 1 부서번호, 2 사원명, 3 잡
-- 2) 검색어   : 
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
    psearchCondition NUMBER --1. 부서번호, 2.사원명, 3.잡
    , psearchWord   VARCHAR2
)
IS
    vsql  VARCHAR2(2000);
    vcur  SYS_REFCURSOR;    -- 커서 타입으로 변수 선언 9i REF CURSOR
    vrow  emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    
    IF psearchCondition = 1 THEN -- 부서번호로 검색
     vsql := vsql || ' where deptno = :pdeptno ';
    ELSIF psearchCondition = 2 THEN -- 사원명
    vsql := vsql || ' where REGEXP_LIKE(ename, :psearWord)'; 
    ELSIF psearchCondition = 3 THEN -- 잡
    vsql := vsql || '  where REGEXP_LIKE(job, :psearWord, ''i'')';
    END IF;
    
    
    -- EXECUTE IMMEDIATE stmt INTO X USING 파라미터...
    -- OPEN ~ FOR 문
    OPEN vcur FOR vsql USING psearchWord ;
    LOOP
        FETCH vcur INTO vrow ;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vrow.empno || ' ' || vrow.ename || '' || vrow.job );
    END LOOP;
    CLOSE vcur;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, '>EMP DATA NOT FOUND...');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, '>OTHER ERROR...');
END;

EXEC UP_NDSSEARCHEMP(1, '20');
EXEC UP_NDSSEARCHEMP(2, 'L');
EXEC UP_NDSSEARCHEMP(3, 's');







