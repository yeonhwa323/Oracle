-- SCOTT 12일차
SELECT *
FROM tabs;
--(월) : MERGE(병합) x /제약조건 x / 조인 x / 계층적 쿼리-내일
--(화) : DB 모델링 + 세미프로젝트
--(수) : DB 모델링 + 발표
--(목) : PL/SQL

-- 투플 = 레코드, 테이블

-- [정규화]
-- https://terms.naver.com/entry.naver?docId=3431238&cid=58430&categoryId=58430&expCategoryId=58430
1. 이상현상

2. 함수 종속성
3. 정규화 
--
ㄱ. 정규화 ? 이상 현상이 발생하지 않도록 하려면, 
            관련 있는 속성들로만 릴레이션을 구성해야 
            하는데 이를 위해 필요한 것이 정규화다.
ㄴ. 함수적 종속성(FD;Functional Dependnecy) ?    속성들 간의 관련성
  함수적 종속 ? 
  emp 테이블
  empno(PK) ename  ename(Y)은 empno(X)에 함수적으로 종속된다. (종속함수)
     X       Y
   결정자   종속자
     X  →   Y
  empno  →  ename
  empno  →  hiredate
  empno  →  job
  empno  →  (ename, job, mgr, hiredate, sal, comm, deptno)
  
  SELECT *
  FROM emp;
     
  (1) 완전 함수적 종속
      여러 개의 속성이 모여서 하나의 기본키(PK)를 이룰 때 == 복합키
      복합키 전체에 어떤 속성이 종속적일 때 "완전 함수적 종속"이라고 한다.
      예)
      (고객ID + 이벤트번호)    ->   당첨여부
      
  (2) 부분 함수적 종속 (복합키)
      완전 함수 종속이 아니면 "부분 함수적 종속"이라고 한다.
      예)
      (고객ID + 이벤트번호)    ->    고객이름 XX 
      고객ID    ->    고객이름(고객ID에만 부분적으로 종속된다)
      
  (3) 이행 함수적 종속
    Y는 X에 함수적 종속이다.
    X -> Y , Y -> Z 일 때 X -> Z 가 함수적 종속이 될 때 "이행 함수적 종속"이라고 한다.
    결정자   종속자       결정자     종속자
      X   ->  Y            Y   ->   Z       일때   X  ->  Z
    empno -> deptno     deptno    dname
    사원번호    사원명     사원명     부서명

3. 정규화 정의와 필요성 - 정규화(normalization)   
   (1) 제1 정규형( 1NF )
   릴레이션에 속한 모든 속성의 도메인이 원자 값(atomic value)으로만
   구성되어 있으면 제1정규형에 속한다.
    
    도메인 ? 속성 하나가 가질 수 있는 모든 값의 집합을 해당 속성의 도메인(domain)이라 한다.
    예) 부서명 컬럼(속성) - 도메인( 영업부, 생산부, 총무부 )

    예) 회원 가입
        취미 선택항목 : [] 여행 [] 사이클 [] 독서
        [회원 테이블]
        회원ID(PK) 회원명.... 취미
                            여행, 사이클, 독서
                            
        테이블 분리(분해)
        [회원 테이블]
        회원ID(PK)
        admin 홍길동
        
        [회원취미 테이블]
        회원ID(FK)  취미번호(FK)
        admin       10
        admin       20
        admin       40
        
        [취미 테이블]
        10 여행
        20 사이클
        30 독서
        40 운동
        
    (2) 제2 정규형( 2NF )
        릴레이션이 제1정규형에 속하고,
        기본키가 아닌 모든 속성이 기본키에 "완전 함수 종속"되면 제2정규형에 속한다.
        "부분 함수 종속"을 제거해서 "완전 함수 종속"으로 되면 우리는 제2 정규형에 속한다라고 한다.
        복합키 -> 속성
        예)
        고객ID  +  이벤트번호   ->  당첨여부 
                    고객ID    ->   등급  XXX
        
    (3) 제3 정규형( 3NF ) 
        릴레이션이 제2정규형에 속하고, 
        기본키가 아닌 모든 속성이 기본키에 이행적 함수 종속이 되지 않으면 제3정규형에 속한다.
            X           Y         Z
            X           Z         Y       
        사원번호(PK)   부서번호   부서명        
        
        사원 T
        
        사원번호 / 부서번호
        
        부서 T
        
        부서번호 / 부서명
        
    (4) 보이스/코드 ( BCNF )    
        릴레이션의 함수 종속 관계에서 모든 결정자가 후보키이면 보이스/코드 정규형에 속한다.
        
        [ X + Y ] 복합키
        [ X + Y ]-> Z   , Z  ->  Y : 복합키인 Y 가 일반키인 Z 에 종속된다.
        
        [T]
        X, Z
        
        Y, Z

    (5) 제4 정규형과 제5 정규형
    
-- 물리적 모델링 : 역정규화 / 인덱스...

-- [ 세미프로젝트 : 설문조사 DB모델링 + SQL작성 ]

select *
from CATEGORY ;

-- CATEGORY 테이블 ( 항목 )
-- CATEGORY_NUMBER / BOARD_NUMBER / CATEGORY_CONTENT
--  항목 넘버   1~5  / 게시판 번호  1~10  /  항목내용
-- [ CATEGORY 테이블 ( 항목 ) ]
-- 좋아하는 여자연예인
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 1, '박보영' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 2, '한소희' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 3, '홍수주' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 4, '권나라' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 5, '조보아' ) ;
-- 선호하는 반려동물
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 1, '강아지' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 2, '고양이' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 3, '거북이' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 4, '토끼' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 5, '물개' ) ;
-- 요즘 정주행하고 있는 드라마는 ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 1, '웨딩 임파서블' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 2, '살인자ㅇ난감' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 3, '로얄로더' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 4, '끝내주는 해결사' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 5, '피라미드 게임' ) ;
-- 최근 본 영화 중 추천하고 싶은 영화는 ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 1, '듄: 파트2' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 2, '파묘' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 3, '윙카' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 4, '귀멸의 칼날' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 5, '소풍' ) ;
-- 개봉 예정 영화 중 기대되는 영화는 ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 1, '브레드 이발소' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 2, '아이엠 티라노' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 3, '패스트 라이브즈' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 4, '가여운 것들' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 5, '비트' ) ;
-- 집들이 선물로 받고싶은 선물은 ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 1, '휴지' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 2, '세제' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 3, '무드등' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 4, '수건세트' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 5, '찻잔/커피잔 세트' ) ;
-- 이번 지방 선거에서 몇 번 후보를 뽑으시겠습니까 ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 1, '1번후보' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 2, '2번후보' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 3, '3번후보' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 4, '4번후보' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 5, '5번후보' ) ;
-- 선호하는 디퓨저 향은 ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 1, '블랙베리앤베이' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 2, '블랙체리' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 3, '클린코트' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 4, '일랑일랑' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 5, '화이트머스크' ) ;
-- 겨울 여행지로 가고싶은 곳은 ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 1, '거제' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 2, '울산' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 3, '속초' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 4, '평창' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 5, '제주' ) ;
-- 배스킨라빈스 맛 종류 중 선호하는 맛은 ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 1, '엄마는외계인' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 2, '사랑에빠진딸기' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 3, '초코나무숲' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 4, '아몬드봉봉' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 5, '황치즈드래곤볼' ) ;

