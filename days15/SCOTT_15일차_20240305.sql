-- SCOTT 14일차
SELECT *
FROM tabs;
-- (화) : PL/SQL
---------------------------------------------------------------------
--1. [%TYPE형 변수]
--2. [%ROWTYPE형 변수]
--3. [RECORD형 변수] --
SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno
WHERE empno = 7369 ;
-- 1. 익명프로시저 직성 + 테스트 ( %TYPE 형 변수 : 하나씩 변경 )
DECLARE
    vdeptno dept.deptno%TYPE ;
    vdname dept.dname%TYPE ;
    vempno emp.empno%TYPE ;
    vename emp.ename%TYPE ;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
        INTO vdeptno, vdname, vempno, vename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369 ;
    
    DBMS_OUTPUT.PUT_LINE( vdeptno || ', ' || vdname
        || ', ' || vempno || ', ' || vename || ', ' || vpay );
--EXCEPTION
END ;

-- 2. 익명프로시저 직성 + 테스트 ( %ROWTYPE 형 변수 : 한꺼번에 변경 )
DECLARE
    vdrow dept%ROWTYPE;
    verow emp%ROWTYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
        INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369 ;
    
    DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname
        || ', ' || verow.empno || ', ' || verow.ename || ', ' || vpay );
--EXCEPTION
END ;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 3. 익명프로시저 직성 + 테스트 ( RECORD 형 변수 : 한번의 선언으로 한 행의 모든 값을 변수에 저장 )
DECLARE
    -- "부서번호,부서명,사원번호,사원명,급여" 새로운 하나의 자료형 선언
    -- ( 사용자 정의 구조체 타입 선언 )
    TYPE EmpDeptType IS RECORD
    (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    -- 변수 선언
    vderow EmpDeptType ;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
        INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno 
    WHERE empno = 7369 ;
    
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );
--EXCEPTION
END ;

-- 4. 익명프로시저 직성 + 테스트 ( RECORD 형 변수 )
-- 커서 사용해야 오류 해결가능.
--ORA-01422: exact fetch returns more than requested number of rows
--*Cause:    The number specified in exact fetch is less than the rows returned.
--*Action:   Rewrite the query or change number of rows requested
DECLARE
    TYPE EmpDeptType IS RECORD
    (
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE,
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        pay NUMBER
    );
    vderow EmpDeptType;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
      --INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno ;
    --WHERE empno = 7369 ;    
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );
--EXCEPTION
END;

-- [ 5) 커서(CURSOR) ]
1) 커서 ? PL/SQL의 실행블럭 안에서 실행되는 SELECT문 의미
2) 커서의 2가지 종류
 ㄱ. 묵시적 커서 : SELECT문의 실행 결과가 1개, FOR 문 SELECT 문
    (자동)
 ㄴ. 명시적 커서 : SELECT문의 실행 결과가 여러 개
    (1) CURSOR 선언 - 실행한 SELECT 문 작성
    (2) OPEN       - 작성된 SELECT 문이 실행되는 과정
    (3) FETCH   - 커서로 부터 여러 개의 레코드 읽어와서 처리과정
        - LOOP 문(반복문) 사용
         [ 커서 속성을 사용 ]
         %ROWCOUNT 속성   : 커서 내부에 행의 개수(결과의 수)
         %FOUND 속성      : 커서 내부에 FETCH 할 자료가 있으면 true, 없으면 false
         %NOTFOUND 속성   : 커서 내부에 FETCH 할 자료가 있으면 false, 없으면 true
         %ISOPEN 속성     : 커서가 OPEN 상태이면 true 반환(묵시적 커서는 항상 false)

    (4) CLOSE

-- 예)
SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno ;
-- [명시적 커서 + 익명프로시저 작성. 테스트]
DECLARE
     TYPE EmpDeptType IS RECORD
    (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    vderow EmpDeptType;
    -- 1) 커서 선언
    CURSOR edcursor IS (
            SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
            FROM dept d JOIN emp e ON d.deptno = e.deptno 
        );
BEGIN
    -- 2) 커서 OPEN
    OPEN edcursor;
    -- 3) FETCH
    -- while(true){ if() break; }
    LOOP
        FETCH edcursor INTO vderow;
        EXIT WHEN edcursor%NOTFOUND;
        DBMS_OUTPUT.PUT(edcursor%ROWCOUNT || ' : ' ) ;
        DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );
                
    END LOOP;
    -- 4) 커서 CLOSE
    CLOSE edcursor;
--EXCEPTION
END;
---------------------------------------

-- ㄱ. [암시적 커서 + 익명프로시저 작성] FOR문 사용
DECLARE
     TYPE EmpDeptType IS RECORD
    (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    vderow EmpDeptType;
    -- 1) 커서 선언
    CURSOR edcursor IS (
            SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
            FROM dept d JOIN emp e ON d.deptno = e.deptno 
        );
BEGIN
    --FOR i IN [REVERSE]1..10
    FOR vderow IN edcursor
    LOOP
        DBMS_OUTPUT.PUT(edcursor%ROWCOUNT || ' : ' ) ;
        DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );              
    END LOOP;
    
--EXCEPTION
END;

-- ㄴ. [암시적 커서 + 익명프로시저 작성] FOR문 사용
--- FOR 문이 반복되는 커서문은 따로 선언하지 않아도된다. DECLARE문 조차 필요없음

BEGIN
    FOR vderow IN (
            SELECT d.deptno, dname, empno, ename, sal+NVL(comm, 0) pay
            FROM dept d JOIN emp e ON d.deptno = e.deptno 
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname
        || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay );              
    END LOOP;
    
--EXCEPTION
END;

-- [ 저장 프로시저(STORED PROCEDURE) ]
CREATE OR REPLACE PROCEDURE 프로시저명
(
)
IS
BEGIN
    실행 블럭
EXCEPTION
    예외 처리 블럭
END;

-- 익명 프로시저
CREATE OR REPLACE PROCEDURE 프로시저명
(
    매개변수(argument, parameter ),
    매개변수(argument, parameter ),
    p
)
IS
    v;
    v;
BEGIN    
EXCEPTION
END;

-- 저장 프로시저를 실행하는 3가지 방법
--1) EXECUTE 문으로 실행.
--2) 익명프로시저에서 호출해서
--3) 또 다른 저장프로시저에서 호출해서 실행

-- 서브쿼리를 사용해서 테이블 생성
CREATE TABLE tbl_emp
AS
(SELECT * FROM emp);
--
SELECT *
FROM tbl_emp ;
-- 저장(stored) 프로시저 :    up_ = userprocedue_ 의미로 생성하겠다
DELETE FROM tbl_emp
WHERE empno = 9999;

--
CREATE OR REPLACE PROCEDURE up_deltblemp
(
    -- pempno NUMBER(4) X -> 자릿값(4) 주지않는다! (기억)
    -- pempno NUMBER    O 
    -- pempno IN tbl_emp.empno%TYPE
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
    --ROLLBACK;
END;
-- Procedure UP_DELTBLEMP이(가) 컴파일되었습니다.
-- [UP_DELTBLEMP 실행 ] - 3가지
--1) execute  문 실행
-- PLS-00306: wrong number or types of arguments in call to 'UP_DELTBLEMP'
EXECUTE UP_DELTBLEMP ; X
EXECUTE UP_DELTBLEMP(7369);
EXECUTE UP_DELTBLEMP(pempno=>7499) ;
SELECT *
FROM tbl_emp;

--2) 익명프로시저에서 호출해서 실행
-- DECLARE
BEGIN
    UP_DELTBLEMP(7566);
END;
--3) 또 다른 저장프로시저에서 호출해서 실행
CREATE OR REPLACE PROCEDURE up_DELTBLEMP_test
AS
BEGIN
    UP_DELTBLEMP(7521);
END up_DELTBLEMP_test ;
-- Procedure UP_DELTBLEMP_TEST이(가) 컴파일되었습니다.
EXEC up_DELTBLEMP_test;

-- 문제1) dept -> tbl_dept 테이블 생성
CREATE TABLE tbl_dept
AS 
(SELECT * FROM dept);
-- 문제2) tbl_dept 테이블에 deptno 컬럼에 PK 제약조건 설정.
ALTER TABLE tbl_dept
ADD CONSTRAINT PK_TBLDEPT_DEPTNO PRIMARY KEY(deptno);
-- Table TBL_DEPT이(가) 변경되었습니다.

-- 문제3) 명시적 커서 + tbl_dept 테이블을 SELECT 저장 프로시저 생성
-- 실행
-- up_seltbldept
-- 매개변수 x, 변수는 명시적 커서 선언
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
   vdrow tbl_dept%ROWTYPE;
   CURSOR dcursor IS (
                         SELECT deptno, dname, loc
                         FROM tbl_dept
                       );
BEGIN 
   OPEN dcursor; 
   LOOP
     FETCH dcursor INTO vdrow; 
     EXIT WHEN dcursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( dcursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
      || ', ' ||  vdrow.loc);  
   END LOOP; 
   CLOSE dcursor;
--EXCEPTION
END;

EXEC UP_SELTBLDEPT;

-- 문제4) 새로운 부서를 추가하는 저장 프로시저
--  deptno      시퀀스
--  dname, loc
select *
from user_sequences;
-- 4-1) seq_deptno 시퀀스 생성  50/10/NOCYCLE/NO캐시/90
CREATE SEQUENCE seq_deptno
INCREMENT BY 10
START WITH 50
MAXVALUE 90
NOCYCLE
NOCACHE;
-- Sequence SEQ_DEPTNO이(가) 생성되었습니다.
CREATE OR REPLACE PROCEDURE UP_INSTBLDEPT
(
    pdname IN tbl_dept.dname%TYPE := null
    , ploc IN tbl_dept.loc%TYPE DEFAULT NULL
)
IS
    --vdeptno tbl_dept.deptno%TYPE;
BEGIN
--    SELECT MAX(deptno)+1 INTO vdeptno
--    FROM tbl_dept;
--    vdeptno := vdeptno + 10;
    
--    INSERT INTO tbl_dept(deptno, dname, loc )
--    values(vdeptno, pdname, ploc);

    INSERT INTO tbl_dept (deptno, dname, loc)
    values (seq_deptno.nextval,pdname,ploc);
    commit;
--EXCEPTION
END;
-- Procedure UP_INSTBLDEPT이(가) 컴파일되었습니다.   

--EXEC UP_SELTBLDEPT;
EXEC UP_INSTBLDEPT('QC', 'SEOUL');
EXEC UP_INSTBLDEPT(ploc=>'SEOUL', pdname=>'QC');

EXEC UP_INSTBLDEPT(pdname=>'QC2');
EXEC UP_INSTBLDEPT(ploc=>'SEOUL');
EXEC UP_INSTBLDEPT;
--
SELECT *
FROM tbl_dept;

-- 문제) up_seltbldept, up_instbldept
--  [ up_updtbldept ]
EXEC up_updtbldept(50, 'X', 'Y');   --dname, loc
EXEC up_updtbldept(pdeptno=>50, pdname=>'QC3'); --loc
EXEC up_updtbldept(pdeptno=>50, ploc=>'SEOUL'); --dname

-- ㄱ.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
  vdname tbl_dept.dname%TYPE;
  vloc   tbl_dept.loc%TYPE;
BEGIN
    -- 수정 전의 원래 dname, loc
    SELECT dname, loc INTO vdname, vloc
    FROM tbl_dept
    WHERE deptno = pdeptno;
    
    IF pdname IS NULL AND ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = vdname, loc = vloc
       WHERE deptno = pdeptno;
    ELSIF pdname IS NULL THEN
       UPDATE tbl_dept
       SET dname = vdname, loc = ploc
       WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = pdname, loc = vloc
       WHERE deptno = pdeptno;    
    ELSE
      UPDATE tbl_dept
       SET dname = pdname, loc = ploc
       WHERE deptno = pdeptno; 
    END IF;    
    COMMIT;
-- EXCEPTION
END;

-- ㄴ.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
BEGIN
    IF pdname IS NULL AND ploc IS NULL THEN
    ELSIF pdname IS NULL THEN
       UPDATE tbl_dept
       SET loc = ploc
       WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = pdname
       WHERE deptno = pdeptno;    
    ELSE
       UPDATE tbl_dept
       SET dname = pdname, loc = ploc
       WHERE deptno = pdeptno; 
    END IF;    
    COMMIT;
-- EXCEPTION
END;

-- ㄷ.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
BEGIN
    
       UPDATE tbl_dept
       SET dname  = NVL(pdname,dname)
            , loc = CASE
                        WHEN ploc IS NULL THEN loc
                        ELSE ploc
                    END
       WHERE deptno = pdeptno; 
  
    COMMIT;
-- EXCEPTION
END;
-- Procedure UP_UPDTBLDEPT이(가) 컴파일되었습니다.

-- 풀이 ㄱ) UP_SELTBLDEPT 모든 부서 조회...+명시적 커서
SELECT * FROM tbl_emp ; 부서번호를 매개변수
-- 해당되는 부서원들만 조회하는 저장 프로시저 작성.
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
   verow tbl_emp%ROWTYPE;
   CURSOR ecursor IS (
                         SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL(pdeptno, 10)
                       );
BEGIN 
   OPEN ecursor; 
   LOOP
     FETCH ecursor INTO verow; 
     EXIT WHEN ecursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( ecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP; 
   CLOSE ecursor;
--EXCEPTION
END;
-- Procedure UP_SELTBLEMP이(가) 컴파일되었습니다.
EXEC UP_SELTBLEMP;
EXEC UP_SELTBLEMP(30);

-- 풀이 ㄴ) UP_SELTBLDEPT 모든 부서 조회...+명시적 커서
-- 해당되는 부서원들만 조회하는 저장 프로시저 작성.
-- [ 커서 파라미터를 이용하는 방법 ]
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
   verow tbl_emp%ROWTYPE;
   CURSOR ecursor( cdeptno tbl_emp.deptno%TYPE ) IS (
                         SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL( cdeptno, 10)
                       );
BEGIN 
   OPEN ecursor( pdeptno ); 
   LOOP
     FETCH ecursor INTO verow; 
     EXIT WHEN ecursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( ecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP; 
   CLOSE ecursor;
--EXCEPTION
END;

-- 풀이 ㄷ) UP_SELTBLDEPT 모든 부서 조회...+명시적 커서
-- 해당되는 부서원들만 조회하는 저장 프로시저 작성.
-- [ FOR 문 이용하는 수정 ]
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS 
BEGIN 
    FOR verow IN (       SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL( pdeptno, 10)
                       )
    LOOP
    DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);
    END LOOP;
--EXCEPTION
END;

-- 문제) tbl_dept 테이블의 레코드 삭제하는 up_deltbldept 저장
--          프로시저를 작성, 50, 60, 70, 80 삭제
--          ( 삭제할 부서번호를 매개변수로 받아야 된다. )
EXEC up_deltbldept(50);
EXEC up_deltbldept(60);
EXEC up_deltbldept(70);
EXEC up_deltbldept(80);
EXEC up_deltbldept(90);
SELECT * FROM tbl_dept;

CREATE OR REPLACE PROCEDURE up_deltbldept
(
    pdeptno NUMBER
)
IS
BEGIN
    DELETE FROM tbl_dept
    where deptno = pdeptno ;
    commit ;
--EXCEPTION
END;

-- [ 저장 프로시저 ]
-- 입력용 매개변수 IN 
-- 출력용 매개변수 OUT
-- 입/출력용 매개변수 IN OUT
SELECT  num, name, ssn -- 770221-1****** -- OUT
FROM insa
WHERE num = 1001; -- IN
--
CREATE OR REPLACE PROCEDURE up_selinsa --********오류
(
     pname OUT insa.name%TYPE
    , pssn OUT VARCHAR2
)
IS
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    SELECT  name, ssn into vname, vssn
    FROM insa
    ;
    
    pname := vname;
    prrn := SUBSTR(vssn, 1, 8) || '******' ;

--EXCEPTION
END;
DECLARE
    vname insa.name%TYPE;
    vrrn  VARCHAR2(14);
BEGIN
    UP_SELINSA(1001, vname, vrrn);
    DBMS_OUTPUT.PUT_LINE(vname || ' , ' || vrrn );
--EXCEPTION
END;

-- IN/OUT 입출력용 파라미터(매개변수)
-- 예) 주민등록번호 14자리를 입력용 매개변수로...
--     앞자리 6자리를       출력용 매개변수로 사용.
CREATE OR REPLACE PROCEDURE up_rrn
(
    prrn IN OUT VARCHAR2 -- VARCHAR2(크기)->파라미터에선 설정X
)
IS
BEGIN
    prrn := SUBSTR(prrn, 1, 6);
--EXCEPTION
END;
-- Procedure UP_RRN이(가) 컴파일되었습니다.
DECLARE
    vrrn VARCHAR2(14) := '761230-1700001';
BEGIN
    UP_RRN(vrrn);
    DBMS_OUTPUT.PUT_LINE( vrrn );
END;

-- 저장 함수(Stored Function)
-- 자바 메서드
public static void method1() { -- 저장 프로시저(오라클)
    return 1000;               -- 저장 함수
}
-- 리턴값의 유무에 따라 프로시저 / 함수 구분
-- 저장 함수(Stored Function)
[형식]
CREATE OR REPLACE PROCEDURE 저장프로시저명
(
    p 파라미터,
    p 파라미터,
)
RETURN 리턴자료형
IS
    v 변수명;
    v 변수명;
BEGIN

        RETURN (리턴값);
EXCEPTION
END;
-- 예제1) 저장 함수 ( 주민등록번호를 매개변수 남자/여자 문자열 반환하는 함수 )
SELECT num, name, ssn
    , DECODE( MOD(SUBSTR(ssn, -7, 1),2),1,'남자','여자') gender  --주민등록번호를 사용해서 성별 출력
 --   , SCOTT.UF_GENDER(ssn) gender
    , UF_GENDER( ssn ) GENDER
    , SCOTT.UF_AGE(ssn, 0) 만나이
    , SCOTT.UF_AGE(ssn, 1) 세는나이
FROM insa;
-- up_저장프로시저명
-- uf_저장함수명
CREATE OR REPLACE FUNCTION uf_gender
(
    prrn IN VARCHAR2
)
RETURN VARCHAR2    --리턴자료형
IS
    vgender VARCHAR2(6);
BEGIN
    IF MOD( SUBSTR(prrn,-7,1), 2) = 1 THEN vgender := '남자';
    ELSE
        vgender := '여자';
    END IF;

    RETURN (vgender) ;
--EXCEPTION
END;
-- Function UF_GENDER이(가) 컴파일되었습니다.
*.sql content:age
*.sql C:\E\Sist\Class\Workspace\OracleClass\ content:AGE 

-- 
CREATE OR REPLACE FUNCTION uf_age
(
    prrn VARCHAR2
    , ptype IN NUMBER -- 1(세는 나이)  0(만나이)
)
RETURN NUMBER
IS 
    ㄱ NUMBER(4); -- 올해년도
    ㄴ NUMBER(4); -- 생일년도
    ㄷ NUMBER(4); -- 생일 지남 여부  -1,0,1
    vcounting_age NUMBER(3); -- 세는나이
    vamerican_age NUMBER(3); -- 만나이
BEGIN
    -- 만나이 = 올해년도 - 생일년도     생일지남여부X -1 결정.
    --       = 세는나이 -1
    -- 세는나이 = 올해년도 - 생일년도 +1 ;
    ㄱ := TO_DATE(SYSDATE, 'YYYY') ;
    ㄴ := CASE
          WHEN SUBSTR(prrn, 8, 1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(prrn, 8, 1) IN (3,4,7,8) THEN 2000
          ELSE 1800
         END + SUBSTR(prrn, 1, 2);
    ㄷ := SIGN(TO_DATE(SUBSTR(prrn,3,4), 'MMDD') - TRUNC(SYSDATE)) ; -- 1(생일안지남) 0(오늘생일) -1(생일지남)
    
    vcounting_age := ㄱ - ㄴ +1; -- 세는나이
    vamerican_age := vcounting_age -1 + CASE ㄷ
                                        WHEN 1 THEN -1
                                        ELSE 0
                                        END ;
    IF ptype =1 THEN
        return vcounting_age;
    ELSE
        return vamerican_age;
    END IF;
    
--EXCEPTION
END; -- *******************오류

-- 예) 주민등록번호->1998.01.20(화) 형식의 문자열로 반환하는 저장함수 작성.테스트
SELECT name, ssn
    , SCOTT.UF_BIRTH( ssn ) --'1998.01.20(화)'
FROM insa;
--
CREATE OR REPLACE FUNCTION uf_birth
(
    prrn VARCHAR2 
)
RETURN VARCHAR2
IS
    vcentry NUMBER(2);   --19, 20, 18
    vbirth VARCHAR2(20); --'1998.01.20(화)'
BEGIN
    -- 770221-1022432
    vbirth := SUBSTR(prrn, 1, 6); --
    vcentry := CASE
                WHEN SUBSTR(prrn, -7, 1) IN (1,2,5,6) THEN 19
                WHEN SUBSTR(prrn, -7, 1) IN (3,4,7,8) THEN 20
                ELSE 18
               END;
    vbirth := vcentry || vbirth;    -- '19770221'
    vbirth := TO_CHAR( TO_DATE( vbirth, 'YYYYMMDD' ), 'YYYY.MM.DD(DY)');
    RETURN vbirth;
--EXCEPTION
END;
-- Function UF_BIRTH이(가) 컴파일되었습니다.

-- [문제] 
SELECT POWER(2,3), POWER(2,-3)
      , SCOTT.UF_POWER(2,3), SCOTT.UF_POWER(2,-3)
FROM dual;
--
public static double pow(int n, int m) {
    double result = 1;
    // if( m<0)  exp =  -1 * m;
    int exp = Math.abs(m);
    for (int i = 0; i < exp ; i++) {
        result *= n;
    }
    return m<0 ? 1/result: result;
}
--
CREATE OR REPLACE FUNCTION uf_power
(  
  pn NUMBER
  , pm NUMBER
)
RETURN NUMBER
IS
  vresult NUMBER := 1;
  vexp NUMBER;
BEGIN   
    vexp := ABS(pm); 
    FOR i IN 1 .. vexp
    LOOP
       vresult := vresult * pn;
    END LOOP; 
    IF pm<0 THEN
      RETURN 1/vresult; 
    ELSE
      RETURN vresult;
    END IF;  
--EXCEPTION
END;










