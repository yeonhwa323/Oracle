-- SCOTT 10일차
SELECT *
FROM tabs;
--(월) : MERGE(병합) x /제약조건 x / 조인 x / 계층적 쿼리-내일
(화) : DB 모델링 + 세미프로젝트
(수) : DB 모델링 + 발표
(목) : PL/SQL

프로젝트 요구/ 금/토/일+
(월)/(화) PL/SQL 수업 X
수/목/금/토/일/월/화  -> 발표 수/목/금   월 

CREATE TABLE tbl_emp(
    id number primary key, 
    name varchar2(10) not null,
    salary  number,
    bonus number default 100
);
-- Table TBL_EMP이(가) 생성되었습니다.
INSERT INTO tbl_emp(id,name,salary) values(1001,'jijoe',150);
INSERT INTO tbl_emp(id,name,salary) values(1002,'cho',130);
INSERT INTO tbl_emp(id,name,salary) values(1003,'kim',140);
COMMIT;
--
DESC tbl_emp;
--
SELECT * 
FROM tbl_emp;
--
CREATE TABLE tbl_bonus
(
    id number
    , bonus number default 100
);
-- Table TBL_BONUS이(가) 생성되었습니다.
INSERT INTO tbl_bonus(id) (select e.id from tbl_emp e);
--
SELECT * FROM tbl_bonus;
--
1001	100
1002	100
1003	100
--
INSERT INTO tbl_bonus VALUES ( 1004,50 );
COMMIT;
--
1001	100
1002	100
1003	100
1004	50
--
-- 병합
MERGE INTO tbl_bonus b
USING ( SELECT id, salary FROM tbl_emp ) e
ON (b.id = e.id )
WHEN MATCHED THEN
    UPDATE  SET b.bonus = b.bonus + e.salary * 0.01
    -- WHERE
WHEN NOT MATCHED THEN
    INSERT INTO (b.id, b.bonus) VALUES (  e.id, e.salary * 0.01 )
;

-- 병합 2)
CREATE TABLE tbl_merge1
(
     id number primary key
     , name varchar2(20)
     , pay number
     , sudang number
);
-- Table TBL_MERGE1이(가) 생성되었습니다.
CREATE TABLE tbl_merge2
(
     id number primary key
     , sudang number
);
-- Table TBL_MERGE2이(가) 생성되었습니다.
--
INSERT INTO tbl_merge1 ( id, name, pay, sudang) values ( 1, 'a', 100, 10);
INSERT INTO tbl_merge1 ( id, name, pay, sudang) values ( 2, 'b', 150, 20);
INSERT INTO tbl_merge1 ( id, name, pay, sudang) values ( 3, 'c', 130, 0);

INSERT INTO tbl_merge2 ( id, sudang) values ( 2,5);
INSERT INTO tbl_merge2 ( id, sudang) values ( 3,10);
INSERT INTO tbl_merge2 ( id, sudang) values ( 4,20);

COMMIT;

SELECT *
FROM tbl_merge1;
FROM tbl_merge2;
-- 병합 : tbl_merge1(소스) -> tbl_merge2(타겟) 병합
--          1               insert
--          2               update

-- merge
MERGE INTO tbl_merge2 t2
--USING ( tbl_merge1 ) t1
USING ( SELECT id, sudang FROM tbl_merge1 ) t1
ON (t2.id = t1.id )
WHEN MATCHED THEN
    UPDATE  SET t2.sudang = t2.sudang + t1.sudang
WHEN NOT MATCHED THEN
    INSERT (t2.id, t2.sudang ) values (t1.id, t1.sudang);
COMMIT;
--
SELECT *
FROM tbl_merge2:
    
DROP TABLE tbl_merge1 PURGE;   
DROP TABLE tbl_merge2 PURGE;   
    
DROP TABLE tbl_bonus PURGE;   
DROP TABLE tbl_emp PURGE;        
----------------------------------------------
-- [ Constraints(제약조건) ]
-- scott 이 소유하고 있는 테이블 조회
SELECT * 
FROM user_tables;
-- scott 이 소유하고 있는 emp 테이블에 설정된 제약조건만 조회
SELECT * 
FROM user_constraints
WHERE table_name = UPPER('emp');
-- 제약조건은 테이블에 I/U/D 할때의 규칙으로 사용
--             data integrity(데이터 무결성) 을 위해
INSERT INTO dept values ( 10, 'QC', 'SEOUL' ); -- 개체 무결성(Entity Integrity)에 위배..

-- 참조무결성(Relational Integrity )
-- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found ( 90 - 존재x )
UPDATE emp 
SET deptno = 90
WHERE empno = 7369;

-- 도메인 무결성
DESC emp;

INSERT INTO emp ( empno ) VALUES ( 9999 );
-- ORA-01400: cannot insert NULL into ("SCOTT"."EMP"."EMPNO")
insert into emp ( ename ) values ( 'admin');
SELECt * FROM emp;
ROLLBACK;

tbl_score
    kor     0~100 정수 제약조건
    
insert into tbl_score   kor     values(111); X

-- 제약조건을 생성하는 시기에 따라
    ㄱ. CREATE TABLE 문   : 테이블 생성 + 제약조건 추가/삭제
        1) IN-LINE 제약조건     ( == 컬럼 레벨 )    제약조건 설정 방법
            ㄴ NOT NULL 제약조건 설정
            
        2) OUT-OF-LINE 제약조건 ( == 테이블 레벨 )   제약조건 설정 방법
            ㄴ 두 개 이상의 컬럼에 하나의 제약조건을 설정할 때..
        
    [사원 급여 지급 테이블]
    PK(primary key) - 하나의 레코드를 구별하기 위한 키
    급여지급날짜 + 회원ID => PK (복합키)  // 성능을 위해 (순번) 과 같은 역정규화 사용
    (역정규화) 
    순번  급여지급날짜  회원ID  급여액  ....기타컬럼
    1    20240125    7369    300만원
    2    20240125    7666    300만원
    3    20240125    8223    300만원
    4        :
    15    20240225    7369    300만원
    16    20240225    7666    300만원
    17    20240225    8223    300만원
    :

    U/D
   WHERE 급여지급날짜='20240125' AND   회원ID = 8223
   WHERE 순번 =  3;
        
    ㄴ. ALTER TABLE 문    : 테이블 수정 + 제약조건 추가/삭제
    
select *
from emp
where ename='KING';
    
update emp
set deptno = null
where empno = 7839;
commit;

-- 실습 ) CREATE TABLE 문에서 COLUM LEVEL 방식으로 제약조건 설정하는 예
DROP TABLE tbl_constraint1;
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY -- 제약조건명은 명시하지 않아도
                                            -- SYS_xxxxx 자동으로 코드값 부여됨.
    empno NUMBER(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL
    -- dept 테이블의 deptno (PK) ========> deptno 컬럼으로 참조
    -- 외래키==포린키==참조키 ex) deptno
    , deptno NUMBER(2) CONSTRAINT FK_tblconstraint1_deptno REFERENCES dept(deptno)
    , email VARCHAR2(150) CONSTRAINT UK_tblconstraint1_email UNIQUE
    , kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100) -- WHERE조건절에 들어가는 내용 넣는다.
    , city NUMBER(20) CONSTRAINT CK_tblconstraint1_city CHECK(city IN ('서울', '대구', '대전'))
);
-- Table TBL_CONSTRAINT1이(가) 생성되었습니다.
select *
from user_constraints
where table_name LIKE '%CONSTR' ;

-- 제약조건 비활성화/활성화 --
-- city 서울 대구 대전 체크제약조건
ALTER TABLE TBL_CONSTRAINT1
DISABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY [CASCADE]; -- 제약조건 비활성화.
ENABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY; -- 제약조건 활성화

-- 제약조건 삭제
1) PK 제약조건 삭제
ALTER TABLE TBL_CONSTRAINT1
DROP PRIMARY KEY;
--CASCADE : 두 테이블을 연결해서 PK를 가지고 있는 쪽의 값을 삭제하면 FK로 연결된 값이 동시에 삭제되게 하는 옵션이다
ALTER TABLE TBL_CONSTRAINT1
DROP CONSTRAINT ' PK_tblconstraint1_empno ' ;
CASCADE 옵션 추가 : FOREIGN KEY

2) CK
ALTER TABLE TBL_CONSTRAINT1
DROP CONSTRAINT 'CK_tblconstraint1_CITY' ;

3) UK
ALTER TABLE TBL_CONSTRAINT1
DROP CONSTRAINT 'UK_tblconstraint1_EMAIL' ;
--
ALTER TABLE TBL_CONSTRAINT1
DROP UNIQUE(email);

-- 실습 ) CREATE TABLE 문에서 TABLE LEVEL 방식으로 제약조건 설정하는 예
CREATE TABLE tbl_constraint2
(
      empno NUMBER(4) NOT NULL -- 컬럼 레벨 추가
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) 
    , email VARCHAR2(150) 
    , kor NUMBER(3) 
    , city NUMBER(20) 
    
    --, CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY ( empno, ename ) 복합키
    , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY ( empno )
    , CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT UK_tblconstraint2_email UNIQUE ( email )
    , CONSTRAINT CK_tblconstraint2_kor CHECK(kor BETWEEN 0 AND 100)                 -- 제약조건 kor BETWEEN 0 AND 100와 같이 kor 부여되어있기때문에 따로 설정안해도됨
    , CONSTRAINT CK_tblconstraint2_city CHECK(city IN ('서울', '대구', '대전'))    
);
-- Table TBL_CONSTRAINT2이(가) 생성되었습니다.

drop table tbl_constraint2 purge;
drop table tbl_constraint1 purge;

-- 실습3) alter table 문에서 제약조건 설정하는 예
 CREATE TABLE tbl_constraint3
 (
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
 );
-- Table TBL_CONSTRAINT3이(가) 생성되었습니다.
형식)
ALTER TABLE 테이블명
	ADD [CONSTRAINT 제약조건명] 제약조건타입 (컬럼명);
    
1) empno 컬럼에 PK 제약조건 추가...
ALTER TABLE tbl_constaint3
ADD CONSTRAINT PK_tblconstraint3_empno PRIMARY KEY(empno);
 
2) deptno 컬럼에 FK 제약조건 추가
ALTER TABLE Tbl_Constaint3
ADD CONSTRAINT FK_tblconstraint3_deptno FOREIGN KEY (deptno) REFERENCES deptno(deptno) ;

--
DROP TABLE tbl_constraint3;

DELETE FROM dept
where deptno = 10;

create table emp
(
    -- deptno number(2) C 제약 [F K(deptno)] R d(deptno) ON DELETE CASCADE
    ,  deptno number(2) C 제약 [F K(deptno)] R d(deptno) ON DELETE SET NULL
);
null
null
null
--> ON DELETE CASCADE / ON DELETE SET NULL  실습
1) emp -> tbl_emp 생성
2) dept -> tbl_dept 생성

DROP TABLE tbl_dept;
DROP TABLE tbl_emp;

create table tbl_emp
AS
( SELECT * FROM emp );
-- Table TBL_EMP이(가) 생성되었습니다.

create table tbl_dept
AS
( SELECT * FROM dept );
-- Table TBL_DEPT이(가) 생성되었습니다.
-- tbl_dept PK 제약조건 추가
-- tbl_emp PK 제약조건 추가
-- 제약조건 설정
ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tbldept_deptno PRIMARY KEY(deptno);
-- Table TBL_DEPT이(가) 변경되었습니다.
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblemp_empno PRIMARY KEY(empno);
-- Table TBL_EMP이(가) 변경되었습니다.

-- 문제 ) tbl_emp 테이블에 deptno 컬럼에 FK 설정 + ON DELETE CASCADE 옵션을 추가.
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblemp_deptno FOREIGN KEY ( deptno )
                                REFERENCES tbl_dept(deptno) 
                                ON DELETE SET NULL;
                               -- ON DELETE CASCADE;
-- Table TBL_EMP이(가) 변경되었습니다.

SELECT *
FROM tbl_dept;
select *
from tbl_emp;
--
delete from dept
where deptno = 30;
--
delete from tbl_dept
where deptno = 30;

-- JOIN (조인) --
-- exerd 검색

-- 책 테이블
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title    VARCHAR2(100)   NOT NULL  -- 책 제목
      ,c_name   VARCHAR2(100)   NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;

-- 단가테이블( 책의 가격 )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (식별관계 ***)
      ,price  NUMBER(7)    NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA이(가) 생성되었습니다.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- 책을 지은 저자테이블
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;

-- 고객(서점) 테이블 
-- 판매 ( 출판사 <-> 서점 )
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- 판매 테이블 ( 어떤 서점에게 어떤 책을 며칠에 몇 권 판매했는지 )
 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   
-- * 오전 개념알기 *        
-- 제약조건
-- 제약조건 생성 방법 : create - in/out line방식 / arter table

-- 오후 수업 ~
-- JOIN 
-- 1) equi join

-- [문제] 책ID, 책제목, 출판사(c_name), 단가 컬럼 출력
-- book : b_id(PK), title, c_name
-- danga : b_id(PK, FK), [price]
--  ㄱ. 오라클에선 natural join  이라고 부른다.
    SELECT book.b_id, title, c_name, price
    FROM book, danga
    WHERE book.b_id = danga.b_id; -- 조인조건   = ,
--  ㄴ.
    SELECT book.b_id, title, c_name, price
    FROM book b, danga d
    WHERE b.b_id = d.b_id; -- 조인조건   = ,
--  ㄷ. JOIN ~ ON 구문
    SELECT b.b_id, title, c_name, price
    FROM book b join danga d ON b.b_id = d.b_id; -- 조인조건   = ,
--  ㄹ. USING 절 사용 : book.b_id(객체명.컬럼명) x,   b.b_id(별칭명.컬럼명) x
    SELECT b.b_id, title, c_name, price
    FROM book JOIN danga USING( b_id );
--  ㅁ.
    ELECT b.b_id, title, c_name, price
    FROM book NATURAL JOIN danga ;
-- [문제] 책ID, 책제목, 판매수량, 단가, 서점명, 판매금액(=판매수량*단가) 출력
-- ㄱ. 위의 ㄱ,ㄴ 방법으로 풀기
-- book : b_id, title, c_name
-- au_book : id, b_id, name
-- danga : b_id, price
-- panmai : id, g_id, b_id, p_date, p_su
-- gogaek : g_id, g_name, g_tel
--------------------------------------------
-- book : b_id, title
-- panmai : p_su 
-- danga : price
-- gogaek : g_name 조인

select b.b_id, title, price, g_name, p_su
    , p_su*price 판매금액
from book b, panmai p, gogaek g, danga d
where b.b_id = p.b_id AND g.g_id = p.g_id AND b.b_id = d.b_id;

-- ㄴ. JOIN~ON절 구문사용
select b.b_id, title, price, g_name, p_su
    , p_su*price 판매금액
from book b inner join panmai p on b.b_id = p.b_id
            inner join gogaek g on g.g_id = p.g_id
            inner join danga d on b.b_id = d.b_id;

-- ㄷ. USING절 사용해서 풀기
select b_id, title, price, g_name, p_su
    , p_su*price 판매금액
from book join panmai using (b_id)
            join gogaek using (g_id)
            join danga using (b_id) ;

-- book : b_id, title
-- panmai : p_su 
-- danga : price
-- gogaek : g_name 

-- NONE EQUI JOIN
-- 일정한 관계 x
-- BETWEEN ~ AND 연산자 사용
SELECT ename, sal, grade, losal || ' ~ ' || hisal
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
--
SELECT ename, sal, grade, losal || ' ~ ' || hisal
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal ;

-- 
SELECT *
FROM emp;
select *
from dept;
-- emp / dept join [ INNER JOIN ]
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno ; -- EQUI JOIN
--      NULL -> 10/20/30/40 중 해당X
-- 11행 KING 사원 X
SELECT *
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno ;

-- [OUTER JOIN]
-- ㄱ. LEFT OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno;
--
SELECT d.deptno, ename, hiredate
FROM dept d, emp e 
WHERE d.deptno = e.deptno(+);

-- ㄴ. RIGHT OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d RIGHT OUTER JOIN emp e ON d.deptno = e.deptno;
--
SELECT d.deptno, ename, hiredate
FROM dept d, emp e 
WHERE d.deptno (+)= e.deptno;

-- ㄷ. FULL OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d FULL OUTER JOIN emp e ON d.deptno = e.deptno;
-- X -> 양쪽에 (+)사용할 수 없음
SELECT d.deptno, ename, hiredate
FROM dept d, emp e 
WHERE d.deptno(+) = e.deptno(+);

-- SELF JOIN
-- 사원번호, 사원명, 입사일자, 직속상사사원번호, 직속상사의 사원명
SELECT a.empno, a.ename, a.hiredate, a.mgr, b.ename
FROM emp a, emp b
where a.mgr = b.empno ;
--
SELECT a.empno, a.ename, a.hiredate, a.mgr, b.ename
FROM emp a join emp b on a.mgr = b.empno ;

-- CROSS JOIN : 데카르트 곱 [emp 12 * dept 4 = 48 행]
SELECT e.*, d.*
FROM emp e, dept d ;

SELECT e.*, d.*
FROM emp e CROSS JOIN dept d ;

-- book : b_id, title, c_name
-- au_book : id, b_id, name
-- danga : b_id, price
-- panmai : id, g_id, b_id, p_date, p_su
-- gogaek : g_id, g_name, g_tel

-- 문제1) 책ID, 책제목, 판매수량, 단가, 서점명(고객), 판매금액(판매수량*단가) 출력 
select b_id, title, p_su, price, g_name
    , p_su*price 판매금액
from book b join panmai p ON b.b_id = p.b_id
            join gogaek g ON p.g_id = g.g_id
            join danga d ON b.b_id = d.b_id ;         

-- 문제2) 출판된 책들이 각각 총 몇권이 판매되었는지 조회     
--      (    책ID, 책제목, 총판매권수, 단가 컬럼 출력   )
book : b_id, title
danga : price
panmai : p_su
-- [1]
select b.b_id, title, price, SUM(p_su) 총판매권수
from book b JOIN panmai p ON b.b_id = p.b_id 
            JOIN danga d ON b.b_id = d.b_id 
group by b.b_id, title, price -- 나머지 조건들 같아야 sum함수 사용가능
order by b.b_id;
-- [2]
SELECT DISTINCT b.b_id 책ID, title 제목, price 단가 
   --, p_su 판매수량
, (SELECT SUM(p_su) FROM panmai WHERE b_id = b.b_id) 총판매권수
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id;

-- 문제3) 판매권수가 가장 많은 책 정보 조회 
WITH t
AS 
  (
  SELECT b.b_id, title , price, SUM( p_su )  총판매권수
 FROM  book b JOIN  panmai p ON b.b_id = p.b_id
              JOIN danga d ON  b.b_id = d.b_id
 GROUP BY   b.b_id, title , price
 ORDER BY  b.b_id
 ), 
 s AS (
 SELECT t.*
   , RANK() OVER( ORDER BY  총판매권수 DESC ) 판매순위
 FROM t
 )
 SELECT s.*
 FROM s
 WHERE 판매순위 = 1;

-- 1) TOP-N 분석 방법

SELECT t.*
FROM ( 
        SELECT b.b_id, title, price, SUM( p_su  ) 총판매권수
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id 
        GROUP BY b.b_id, title, price
        ORDER BY 총판매권수 DESC
) t
WHERE ROWNUM BETWEEN 3 AND 5; -- 주의
WHERE ROWNUM <= 3;
WHERE ROWNUM = 1;

-- 2) RANK 순위 함수 ..

WITH t AS (
    SELECT b.b_id, title, price, SUM( p_su  ) 총판매권수
       , RANK() OVER( ORDER BY SUM( p_su  ) DESC ) 판매순위
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id 
    GROUP BY b.b_id, title, price
)
SELECT *
FROM t
WHErE 판매순위 BETWEEN 3 AND 5;
WHErE 판매순위 <= 3;
WHErE 판매순위 = 1;

-- 문제4) 올해 판매권수가 가장 많은 책(수량을 기준으로)
--      (  책ID, 책제목, 수량 )
SELECT ROWNUM 순위, t.*
FROM ( 
    SELECT  p.b_id, title , SUM( p_su  ) 판매수량
    FROM panmai p, book b
    WHERE TO_CHAR(p_date, 'YYYY') = 2024 AND b.b_id = p.b_id
    GROUP BY p.b_id, title
    ORDER BY 판매수량 DeSC
 ) t 

-- 문제5) book 테이블에서 판매가 된 적이 없는 책의 정보 조회
-- 책 종류 : 9가지 종류
 -- (ANTI JOIN : NOT IN 구문)
 SELECT b.b_id, title, price
 FROM book b JOIN danga d ON b.b_id = d.b_id
 WHERE b.b_id NOT IN ( SELECT DISTINCT b_id  FROM panmai );

-- minus 차집합 SET(집합) 연산자

-- 문제6) book 테이블에서 판매가 된 적이 있는 책의 정보 조회
--      ( b_id, title, price  컬럼 출력 )
select distinct b.b_id, title, price
FROM book b, panmai p, danga d
where b.b_id = p.b_id AND b.b_id = d.b_id ;

-- EXISTS -- SEMI JOIN
select b.b_id, title, price
from book b JOIN danga d ON b.b_id = d.b_id
where b.b_id in ( select distinct b_id from panmai);

-- 문제7) 고객별 판매 금액 출력 (고객코드, 고객명, 판매금액)
 SELECT g.g_id, g_name,  SUM(p_su) 
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY g.g_id, g_name ;

-- 문제8) 년도, 월별 판매 현황 구하기
 SELECT  TO_CHAR( p_date, 'YYYY') p_year, TO_CHAR( p_date, 'MM' ) p_month,   SUM(p_su)
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY  TO_CHAR( p_date, 'YYYY') , TO_CHAR( p_date, 'MM')
 ORDER BY p_year, p_month;

-- 문제9) 서점별 년도별 판매현황 구하기
panmai : p_su, p_date
gogaek : g_id, g_name

select p_date
from panmai;

select g_name, TO_CHAR(p_date, 'YYYY') p_year , sum(p_su)
from panmai p JOIN gogaek g ON p.g_id = g.g_id
group by g_name, TO_CHAR(p_date, 'YYYY')
order by g_name, p_year ;
-- 서점별 구하기 : cube 사용 ( 합계, 소계 보여주는 함수 )

-- 문제10) 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )
    
    select b.b_id, title, price, sum(p_su) 총판매권수
        , sum(p_su * price) 총판매금액
    FROM book b jOin danga d on b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id
    group by b.b_id, title, price
        having sum(p_su) * price >= 15000
    order by b.b_id;



















