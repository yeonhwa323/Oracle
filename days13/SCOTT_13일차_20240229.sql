-- SCOTT 12일차
SELECT *
FROM tabs;
--(월) : MERGE(병합) x /제약조건 x / 조인 x / 계층적 쿼리-내일
--(화) : DB 모델링 + 세미프로젝트
--(수) : DB 모델링 + 발표
--(목) : PL/SQL

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


-- 게시판이랑 항목 인서트 하기
-- BOARD_NUMBER, BOARD_TITLE, START_DATE, END_DATE, SURVEY_STATUS(설문진행상태), MANAGERS_NUMBER

CREATE SEQUENCE SEQ_'테이블명' INCREMENT BY '증가값' START WITH '초기값';

CREATE SEQUENCE SEQ_id INCREMENT BY 1 START WITH 1;
--drop sequence SEQ_board ;

SELECT *
FROM all_sequences
WHERE sequence_name = 'SEQ_id' ;

-- 시퀀스 초기화 하는방법
-- 1. 시퀀스 현재 값 확인 
-- SELECT * FROM USER__SEQUENCES WHERE SEQUENCE_NAME = '시퀀스 명';

-- 2. 시퀀스의 INCREMENT를 현재 값만큼 빼도록 설정합니다
-- ALTER SEQUENCE 시퀀스명 INCREMENT BY -현재값;

-- 3. 시퀀스의 INCREMENT를 1로 설정
-- ALTER SEQUENCE 시퀀스명 INCREMENT BY 1;


-- 관리자
INSERT INTO MANAGERS VALUES (1, 'HONGS', '홍길동', 'hhh1234@naver.com', '1234', '111-1111-1111', '2024-01-01', '123456-1234567');
INSERT INTO MANAGERS VALUES (2, 'KIM', '김길동', 'KKK5678@naver.com', '5678', '222-2222-2222', '2023-01-23', '345678-3456789');
INSERT INTO MANAGERS VALUES (3, 'PARK', '박길동', 'bbb2901@naver.com', '12345', '333-3333-3333', '2022-02-13', '654321-1235567');
COMMIT;
ROLLBACK;
SELECT * FROM board;

delete table board;

-- 1번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '좋아하는 여자 연예인은?', '2023-12-26', '2024-01-18', 1, 1);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '박보영' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '한소희' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '홍수주' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '권나라' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '조보아' ) ;

-- 2번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '선호하는 반려동물', '2023-12-26', '2024-01-18', 1, 1);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '강아지' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '고양이' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '거북이' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '토끼' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '물개' ) ;

-- 3번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '요즘 정주행하고 있는 드라마는 ?', '2024-01-23', '2024-02-04', 1, 2);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '웨딩 임파서블' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '살인장난감' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '로얄로더' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '끝내주는 해결사' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '피라미드 게임' ) ;

-- 4번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '최근 본 영화 중 추천하고 싶은 영화는 ?',  '2024-01-26', '2024-02-05', 1, 3);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '듄: 파트2' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '파묘' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '윙카' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '귀멸의 칼날' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '소풍' ) ;

-- 5번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '개봉 예정 영화 중 기대되는 영화는 ?', '2024-01-30', '2024-02-11', 1, 1);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '브레드 이발소' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '아이엠 티라노' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '패스트 라이브즈' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '가여운 것들' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '비트' ) ;

-- 6번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '집들이 선물로 받고싶은 선물은 ?', '2024-02-02', '2024-02-15', 1, 2);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '휴지' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '세제' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '무드등' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '수건세트' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '찻잔/커피잔 세트' ) ;

-- 7번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '이번 지방 선거에서 몇 번 후보를 뽑으시겠습니까 ?', '2024-02-04', '2024-02-17', 1, 2);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '1번후보' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '2번후보' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '3번후보' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '4번후보' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '5번후보' ) ;

-- 8번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '선호하는 디퓨저 향은 ?', '2024-02-25', '2024-03-10', 1, 1);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '블랙베리앤베이' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '블랙체리' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '클린코트' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '일랑일랑' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '화이트머스크' ) ;

-- 9번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '겨울 여행지로 가고싶은 곳은 ?', '2024-02-28', '2024-03-15', 1, 2);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '거제' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '울산' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '속초' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '평창' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '제주' ) ;

-- 10번 게시판 생성
INSERT INTO BOARD VALUES(SEQ_ID.NEXTVAL, '배스킨라빈스 맛 종류 중 선호하는 맛은 ?', '2024-03-05', '2024-03-21', 1, 2);
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 1, '엄마는외계인' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 2, '사랑에빠진딸기' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 3, '초코나무숲' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 4, '아몬드봉봉' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( SEQ_ID.CURRVAL, 5, '황치즈드래곤볼' ) ;
COMMIT;

INSERT INTO member_info
values('1','dog123','카리나','dogh123@naver.com','ss1234','940130-1335794','19-01-20','010-1234-5698','경기도 수원시');
INSERT INTO member_info
values('2','cat123','윈터','cat123@naver.com','sf1234','920321-1134873','20-04-10','010-5479-5468','경기도  광교시');

INSERT INTO member_info
values('3','gifaffe123','닝닝','gifaffe123@naver.com','se1234','780824-1478526','13-04-30','010-4564-4567','경기도 오산시');

INSERT INTO member_info
values('4','lion123','지젤','lion123@naver.com','sq1234','660201-1574125','10-08-30','010-7895-3454','경기도 화성시');

INSERT INTO member_info
values('5','rabbit123','오혜원','rabbit123@naver.com','st1234','850421-1359841','17-02-27','010-7891-7893','서울특별시 강남구');

INSERT INTO member_info
values('6','tiger123','설윤','tiger123@naver.com','sj1234','870812-2045631','08-04-30','010-7894-3456','충청북도 대전광역시');

INSERT INTO member_info
values('7','elephant123','릴리','elephant123','sl1234','730530-3458647','05-02-12','010-2134-7891','충청남도 천안시');

INSERT INTO member_info
values('8','lizard123','안유진','lizard123@naver.com','os1234','660512-2015486','12-01-12','010-6457-2314','충청남도 아산시');

INSERT INTO member_info
values('9','fire123','장원영','fire123@naver.com','sp1234','870122-2178963','22-04-30','010-3457-4567','전북특별자치도 전주시');

INSERT INTO member_info
values('10','cool123','김채원','cool123@naver.com','sb1234','840103-2766841','18-01-20','010-1234-9123','전북특별자치도 익산시');
COMMIT;

INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 1, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 1, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 1, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 1, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 1, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 1, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 1, 3);


SELECT *
FROM board;
SELECT *
FROM category;
SELECT *
FROM vote;
select *
from member_info ;

ALTER TABLE 
-- 날짜 바꾸기
UPDATE board
SET start_date = '24-04-01',
    end_date = '24-04-10'
WHERE board_number = 3;

UPDATE board
SET board_title = '가장 싫어하는 여자 연예인'
WHERE board_number = 1;

SELECT *
FROM board b JOIN category c ON b.board_number = c.board_number
WHERE b.board_number = 3;
---------------------------

select *
from board b join category c on b.board_number = c.board_number 
             join vote v on b.board_number = v.board_number ;

SELECT category_number
    , vote
    , total_vote
    , RPAD(' ', vote + 1, '▒') || '  ' || ROUND(vote/total_vote * 100,2) || '%'
FROM(
    SELECT category_number 
        , COUNT(category_number) vote
        , (SELECT COUNT(*) FROM vote) total_vote
    FROM vote
    GROUP BY category_number
    ORDER BY category_number
    );
  
-- 1번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 1, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 1, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 1, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 1, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 1, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 1, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 1, 3);

-- 2번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 2, 5);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 2, 5);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 2, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 2, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 2, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 2, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 2, 1);

-- 3번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 3, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 3, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 3, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 3, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 3, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 3, 5);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 3, 5);

-- 4번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 4, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 4, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 4, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 4, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 4, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 4, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 4, 4);

-- 5번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 5, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 5, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 5, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 5, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 5, 5);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 5, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 5, 1);

-- 6번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 6, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 6, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 6, 5);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 6, 5);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 6, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 6, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 6, 3);

-- 7번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 7, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 7, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 7, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 7, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 7, 5);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 7, 5);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 7, 5);

-- 8번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 8, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 8, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 8, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 8, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 8, 2);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 8, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 8, 5);

-- 9번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 9, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 9, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 9, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 9, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 9, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 9, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 9, 4);

-- 10번 게시판 투표
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(1, 10, 3);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(2, 10, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(3, 10, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(4, 10, 1);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(5, 10, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(6, 10, 4);
INSERT INTO vote (MEMBER_NUMBER, BOARD_NUMBER, CATEGORY_NUMBER) VALUES(7, 10, 5); 

SELECT DISTINCT b.board_title, b.start_date, b.end_date
,CASE
    WHEN ROUND(SYSDATE - b.start_date) >= 0 AND ROUND(b.end_date - SYSDATE) <=0 THEN 1
    ELSE 0
END status
,m.managers_name
,v.graph, v.vote_percent, v.category_number
FROM board b JOIN managers m ON b.managers_number = m.managers_number
             CROSS JOIN vote_percent v
WHERE b.board_number = 1;

 select * from vote;
 
CREATE OR REPLACE VIEW test
AS
(
    SELECT 게시판
        , 항목
        , vote
        , RPAD(' ', vote + 1, '▒') || '  ' || ROUND(vote/total_vote * 1000, 2) || '%' AS "결과/퍼센트"
        , total_vote
    FROM(
        SELECT board_number 게시판
            , category_number 항목
            , (SELECT COUNT(*) FROM vote) total_vote
            , COUNT(board_number) vote
        FROM vote
        GROUP BY category_number, board_number
        )
    
)ORDER BY 게시판, 항목;    

select *
from test ;



































