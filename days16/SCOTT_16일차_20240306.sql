-- SCOTT  
--(  ) :  PL/SQL

--     1)   ?, ? ,  ,  ,  ,    ,   ,   ,           ?  tbl_score    ?      
--       (num, name, kor, eng, mat, tot, avg, rank, grade ) 
--     2)   ?    ??       
CREATE TABLE tbl_score
(
     num   NUMBER(4) PRIMARY KEY
   , name  VARCHAR2(20)
   , kor   NUMBER(3)  
   , eng   NUMBER(3)
   , mat   NUMBER(3)  
   , tot   NUMBER(3)
   , avg   NUMBER(5,2)
   , rank  NUMBER(4) 
   , grade CHAR(1 CHAR)
);
-- Table TBL_SCORE  (  )      ?    ? .

--     3) seq_tblscore            
CREATE SEQUENCE seq_tblscore;
--
SELECT *
FROM user_sequences;

--     4)  ¬Ý   ?  ?          ¥í        
--EXEC up_insertscore(1001, '? øª', 89,44,55 );
--EXEC up_insertscore(1002, '     ', 49,55,95 );
--EXEC up_insertscore(1003, ' ?  ', 90,94,95 );
SELECT * 
FROM tbl_score;

CREATE OR REPLACE PROCEDURE up_insertscore
(
     pnum   NUMBER 
   , pname  VARCHAR2 
   , pkor   NUMBER 
   , peng   NUMBER 
   , pmat   tbl_score.mat%TYPE 
)
IS
   vtot NUMBER(3);
   vavg NUMBER(5,2);
   vgrade CHAR(1 CHAR);
BEGIN
  vtot := pkor + peng + pmat;
  vavg := vtot / 3;
  -- vrank      o   X
  IF vavg >= 90 THEN
     vgrade := 'A';
  ELSIF vavg >= 80 THEN
     vgrade := 'B';
  ELSIF vavg >= 70 THEN
     vgrade := 'C';
  ELSIF vavg >= 60 THEN
     vgrade := 'D';   
  ELSE
    vgrade := 'F';
  END IF;
  
  INSERT INTO tbl_score (num, name, kor, eng,mat,tot,avg,rank,grade) 
  VALUES ( pnum, pname, pkor, peng, pmat, vtot, vavg,1, vgrade);
  
  --  ?©ö         ¬Ý            o   ?  UPDATE 
  UPDATE tbl_score a
  SET  rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot );
  
  COMMIT;
--EXCEPTION
  -- ROLLBACK;
END;

-- Procedure UP_INSERTSCORE  (  )      ??    ? .

--     5)  ¬Ý       ?          ¥í        
--EXEC up_updateScore( 1001, 100, 100, 100 );
--EXEC up_updateScore( 1001, pkor =>34 );
--EXEC up_updateScore( 1001, pkor =>34, pmat => 90 );
--EXEC up_updateScore( 1001, peng =>45, pmat => 90 );
SELECT * 
FROM tbl_score;

CREATE OR REPLACE PROCEDURE up_updateScore
(
     pnum   NUMBER  
   , pkor   NUMBER := NULL
   , peng   NUMBER := NULL 
   , pmat   tbl_score.mat%TYPE  := NULL
)
IS
   vtot NUMBER(3);
   vavg NUMBER(5,2);
   vgrade CHAR(1 CHAR);
   
   vkor   tbl_score.kor%TYPE;
   veng   tbl_score.eng%TYPE;
   vmat  tbl_score.mat%TYPE;
BEGIN
   SELECT kor, eng, mat INTO vkor, veng, vmat
   FROM tbl_score
   WHERE num = pnum;

  vtot := NVL(pkor,vkor) + NVL(peng,veng) + NVL(pmat,vmat);
  vavg := vtot / 3;
  -- vrank      o   X
  IF vavg >= 90 THEN
     vgrade := 'A';
  ELSIF vavg >= 80 THEN
     vgrade := 'B';
  ELSIF vavg >= 70 THEN
     vgrade := 'C';
  ELSIF vavg >= 60 THEN
     vgrade := 'D';   
  ELSE
    vgrade := 'F';
  END IF;
  
  UPDATE tbl_score
  SET kor=NVL(pkor,vkor), eng=NVL(peng,veng),mat=NVL(pmat,vmat)
     ,tot=vtot, avg=vavg, grade=vgrade
  WHERE num = pnum;
  
  --  ?©ö         ¬Ý            o   ?  UPDATE 
  UPDATE tbl_score a
  SET  rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot );
  -- up_updaterank
  
  COMMIT;
--EXCEPTION
  -- ROLLBACK;
END;

--     6)  ¬Ý       ?          ¥í        
-- EXEC UP_DELETESCORE( 1002 ); 
SELECT * 
FROM tbl_score;

CREATE OR REPLACE PROCEDURE up_deleteScore
(
     pnum   NUMBER  
)
IS
BEGIN
  DELETE FROM tbl_score
  WHERE num = pnum; 
  --  ?©ö         ¬Ý            o   ?  UPDATE 
  UPDATE tbl_score a
  SET  rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot );
  
  COMMIT;
--EXCEPTION
  -- ROLLBACK;
END;

--     7)      ¬Ý      ?          ¥í        (       ¨¨       )
-- EXEC UP_SELECTSCORE;
CREATE OR REPLACE PROCEDURE up_selectScore
IS
  --1) ¨¨       
  CURSOR vcursor IS (SELECT * FROM tbl_score);
  vrow tbl_score%ROWTYPE;
BEGIN
  --2) OPEN  ¨¨            ..
  OPEN vcursor;
  --3) FETCH  ¨¨   INTO 
  LOOP  
    FETCH vcursor INTO vrow;
    EXIT WHEN vcursor%NOTFOUND; --   ? ?    0 ?  true
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ', ' || vrow.name || ', ' || vrow.kor
           || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot
           || vrow.avg || ', ' || vrow.grade || ', ' || vrow.rank
        );
  END LOOP;
  --4) CLOSE
  CLOSE vcursor;
--EXCEPTION
  -- ROLLBACK;
END;


EXEC UP_SELECTSCORE;

--     7-2)     ¬Ý      ?          ¥í        (  ?    ¨¨       (==FOR     ) )
CREATE OR REPLACE PROCEDURE up_selectScore
IS
BEGIN
  FOR vrow IN  (SELECT * FROM tbl_score)
  LOOP  
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ', ' || vrow.name || ', ' || vrow.kor
           || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot
           || vrow.avg || ', ' || vrow.grade || ', ' || vrow.rank
        );
  END LOOP;
--EXCEPTION
  -- ROLLBACK;
END;


--     8)  ¬Ý   ?  ?          ¥í        
-- EXEC UP_SEARCHSCORE(1003);
CREATE OR REPLACE PROCEDURE up_searchScore
(
   pnum NUMBER  --  ?     ¬Ý   ?( ?    )
)
IS
  --1) ¨¨       
  CURSOR vcursor(cnum NUMBER) IS (SELECT * FROM tbl_score WHERE num = cnum);
  vrow tbl_score%ROWTYPE;
BEGIN
  --2) OPEN  ¨¨            ..
  OPEN vcursor(pnum);
  --3) FETCH  ¨¨   INTO 
  LOOP  
    FETCH vcursor INTO vrow;
    EXIT WHEN vcursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ', ' || vrow.name || ', ' || vrow.kor
           || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot
           || vrow.avg || ', ' || vrow.grade || ', ' || vrow.rank
        );
  END LOOP;
  --4) CLOSE
  CLOSE vcursor;
--EXCEPTION
  -- ROLLBACK;
END;
-- 1          (   ? ) ,  ?    ¨¨        
CREATE OR REPLACE PROCEDURE up_searchScore
(
   pnum NUMBER  --  ?     ¬Ý   ?( ?    )
)
IS 
  vrow tbl_score%ROWTYPE;
BEGIN
   SELECT *  INTO vrow
   FROM tbl_score 
   WHERE num = pnum;
   
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ', ' || vrow.name || ', ' || vrow.kor
           || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot
           || vrow.avg || ', ' || vrow.grade || ', ' || vrow.rank
        );
   
--EXCEPTION
  -- ROLLBACK;
END;

-- (JDBC, JSP)  ? 
-- ()  ?   ?   SELECT                       ¨¨      ?         ?¢¥ .
CREATE OR REPLACE PROCEDURE up_selectinsa
(
   pinsacursor SYS_REFCURSOR -- ¨¨    ?     9i      REF CURSORS,
)
IS
   vname insa.name%TYPE;
   vcity insa.city%TYPE;
   vbasicpay insa.basicpay%TYPE;
BEGIN
  LOOP
    FETCH pinsacursor INTO vname, vcity, vbasicpay;
    EXIT WHEN pinsacursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(vname || ', ' || vcity || ', ' || vbasicpay);
  END LOOP;
  CLOSE pinsacursor;
--EXCEPTION
END;
-- Procedure UP_SELECTINSA  (  )      ??    ? .
-- 11.02         
CREATE OR REPLACE PROCEDURE up_selectinsa_test
IS
   vinsacursor SYS_REFCURSOR;
BEGIN
   -- OPEN   ~ FOR   
   OPEN vinsacursor FOR  SELECT name, city, basicpay FROM insa;
   --     ?     ¥í    ?  
   UP_SELECTINSA(vinsacursor); 
   -- CLOSE vinsacursor;
--EXCEPTION
END;
-- Procedure UP_SELECTINSA_TEST  (  )      ??    ? .

EXEC UP_SELECTINSA_TEST;

-- ?            .. 
DROP TABLE tbl_exam1 PURGE;
CREATE TABLE tbl_exam1
(
   id NUMBER PRIMARY KEY
   , name VARCHAR2(20)
);
-- Table TBL_EXAM1  (  )      ?    ? .
DROP TABLE tbl_exam2 PURGE;
CREATE TABLE tbl_exam2
(
   memo VARCHAR2(100)
   , ilja DATE DEFAULT SYSDATE
);
-- Table TBL_EXAM2  (  )      ?    ? .
INSERT INTO tbl_exam1 VALUES ( 1, 'hong');
INSERT INTO tbl_exam2 (memo) VALUES ( 'hong       ?  ?   .');

INSERT INTO tbl_exam1 VALUES ( 2, 'admin');

UPDATE tbl_exam1
SET name = 'admin'
WHERE id = 2;

DELETE FROM tbl_exam1
WHERE id = 1;

COMMIT;
ROLLBACK;
SELECT * FROM tbl_exam1;
SELECT * FROM tbl_exam2;

-- ?         
-- 1)  ?        ?   : tbl_exam1
-- 2)  ?  ? ?( INSERT, UPDATE, DELETE) : INSERT
-- 3)  ?     ,  ?      :  AFTER
-- 4)    ?      ?           X
     ?  
   CREATE [OR REPLACE] TRIGGER ?   ?  [BEFORE ? AFTER]
     trigger_event ON    ?  
     [FOR EACH ROW [WHEN TRIGGER     ]]
   DECLARE
         
   BEGIN
     PL/SQL  ? 
   END;
-- up, uf, ut_
CREATE OR REPLACE TRIGGER ut_log 
AFTER
INSERT OR UPDATE OR DELETE ON tbl_exam1  
FOR EACH ROW 
BEGIN 
   IF INSERTING THEN
      INSERT INTO tbl_exam2 (memo) VALUES ( :NEW.name || '  ? ..');
   ELSIF UPDATING THEN
      INSERT INTO tbl_exam2 (memo) VALUES ( :OLD.name || '->'  || :NEW.name || '     ..');
   ELSIF DELETING THEN
      INSERT INTO tbl_exam2 (memo) VALUES ( :OLD.name || '     ..'); 
   END IF;
-- EXCEPTION  
END;
-- Trigger UT_LOG  (  )      ??    ? .
-- ORA-04082: NEW or OLD references not allowed in table level triggers
-- Trigger UT_LOG  (  )      ??    ? .

-- 12:02   ?    (BEFORE) ?         .
--   )  tbl_exam1        ?  DML        ?  ©£    ( 13  ~18   )  ?   ?      o   X
-- up, uf, ut_
CREATE OR REPLACE TRIGGER ut_log_before 
BEFORE
INSERT OR UPDATE OR DELETE ON tbl_exam1   
BEGIN 
   IF   TO_CHAR(SYSDATE, 'hh24') < 12 OR TO_CHAR(SYSDATE, 'hh24') > 18 
      OR  TO_CHAR(SYSDATE, 'DY') IN ('  ','  ')  THEN
      --  ?   throw    :           ?   ? 
      RAISE_APPLICATION_ERROR(-20001, ' ?  ©£     ??? DML ?  o            .' );
   END IF;
-- EXCEPTION  
END;
-- Trigger UT_LOG_BEFORE  (  )      ??    ? .
INSERT INTO tbl_exam1 VALUES ( 3, 'park' );
COMMIT;

DROP TRIGGER ut_log;
DROP TRIGGER ut_log_before;

DROP TABLE tbl_dept PURGE;
DROP TABLE tbl_emp PURGE;
DROP TABLE tbl_exam1 PURGE;
DROP TABLE tbl_exam2 PURGE;
DROP TABLE tbl_score PURGE;
-- ?         ) 
CREATE TABLE tbl_score
(
   hak     VARCHAR2(10) PRIMARY KEY
   , name  VARCHAR2(20)
   , kor   NUMBER(3)
   , eng   NUMBER(3)
   , mat   NUMBER(3)
);
-- Table TBL_SCORE  (  )      ?    ? .
CREATE TABLE tbl_scorecontent
(
     hak     VARCHAR2(10) PRIMARY KEY
   , tot NUMBER(3)
   , avg   NUMBER(5,2)
   , rank   NUMBER(3)
   , grade   CHAR(1)
   
   , CONSTRAINT FK_tblSCORECONENT_HAK FOREIGN KEY(hak) REFERENCES tbl_score(hak)
);
-- Table TBL_SCORECONTENT  (  )      ?    ? .
EXEC up_insertscore( '1','? øª', 89,23,55 ); 
EXEC up_insertscore( '2','  øª', 99,93,95 ); 
EXEC up_insertscore( '3',' ?øª', 80,33,43 ); 

SELECT * FROM tbl_score;
SELECT * FROM tbl_scorecontent;

CREATE OR REPLACE PROCEDURE up_insertscore
(
     phak   VARCHAR2 
   , pname  VARCHAR2 
   , pkor   NUMBER 
   , peng   NUMBER 
   , pmat   tbl_score.mat%TYPE 
)
IS
BEGIN 
  INSERT INTO tbl_score (hak, name, kor, eng,mat) 
  VALUES ( phak, pname, pkor, peng, pmat);
  COMMIT;
--EXCEPTION
  -- ROLLBACK;
END;

-- 
DROP  TRIGGER ut_insertscore;
CREATE OR REPLACE TRIGGER ut_insertscore
AFTER 
INSERT ON tbl_score
FOR EACH ROW --         ?      :OLD  :NEW 
DECLARE
  vtot NUMBER(3);
  vavg NUMBER(5,2);
  vgrade CHAR(1);
BEGIN 
  vtot := :NEW.kor + :NEW.eng + :NEW.mat;
  vavg := vtot /  3;
  
  IF vavg >= 90 THEN
     vgrade := 'A';
  ELSIF vavg >= 80 THEN
     vgrade := 'B';
  ELSIF vavg >= 70 THEN
     vgrade := 'C';
  ELSIF vavg >= 60 THEN
     vgrade := 'D';   
  ELSE
    vgrade := 'F';
  END IF;
  
  INSERT INTO tbl_scorecontent (hak,tot,avg,rank,grade) 
  VALUES ( :NEW.hak, vtot, vavg,1 , vgrade); 
  
-- EXCEPTION
END;

-- Trigger UT_INSERTSCORE  (  )      ??    ? .

--     ) 
--EXEC up_updateScore( '1', 100, 100, 100 );
--EXEC up_updateScore( '1', pkor =>34 );
--EXEC up_updateScore( '1', pkor =>34, pmat => 90 );
--EXEC up_updateScore( '1', peng =>45, pmat => 90 )

SELECT * FROM tbl_score;
SELECT * FROM tbl_scorecontent;
ROLLBACK;

CREATE OR REPLACE PROCEDURE up_updateScore
(
     phak   VARCHAR2 
   , pkor   NUMBER := NULL
   , peng   NUMBER := NULL 
   , pmat   tbl_score.mat%TYPE  := NULL
)
IS
BEGIN  
  UPDATE tbl_score
  SET kor=NVL(pkor,kor), eng=NVL(peng,eng),mat=NVL(pmat,mat) 
  WHERE hak = phak;  
  COMMIT;
--EXCEPTION
  -- ROLLBACK;
END;

-- ut_updatescore;  ?          
CREATE OR REPLACE TRIGGER ut_updatescore
AFTER 
UPDATE ON tbl_score
FOR EACH ROW --         ?      :OLD  :NEW 
DECLARE
  vtot NUMBER(3);
  vavg NUMBER(5,2);
  vgrade CHAR(1);
BEGIN 
  vtot := NVL(:NEW.kor, :OLD.kor) + NVL(:NEW.eng, :OLD.eng) + NVL(:NEW.mat, :OLD.mat);
  vavg := vtot /  3;
  
  IF vavg >= 90 THEN
     vgrade := 'A';
  ELSIF vavg >= 80 THEN
     vgrade := 'B';
  ELSIF vavg >= 70 THEN
     vgrade := 'C';
  ELSIF vavg >= 60 THEN
     vgrade := 'D';   
  ELSE
    vgrade := 'F';
  END IF;
  
  UPDATE tbl_scorecontent 
  SET tot = vtot,avg = vavg ,rank=1,grade=vgrade  
  WHERE hak = :NEW.hak; 
-- EXCEPTION
END;

-- 1) 
--DELETE FROM emp
--WHErE deptno = 10;
-- 2)
--DELETE FROM dept
--WHErE deptno = 10;

-- [    ]  
--  ORA-02292: integrity constraint (SCOTT.FK_TBLSCORECONENT_HAK) violated 
---         child record found
EXEC up_deletescore(  '2'  );  -- tbl_score    ?  DELETE

-- ut_deletescore ?      ?     tbl_scorecontent  '2'    ??     
SELECT * FROM tbl_score;
SELECT * FROM tbl_scorecontent;
--
CREATE OR REPLACE TRIGGER ut_deletescore
BEFORE
DELETE ON tbl_score
FOR EACH ROW
--DECLARE
BEGIN
   DELETE FROM tbl_scorecontent
   WHERE hak = :OLD.hak; -- DELETE ?       :NEW (X)
-- EXCEPTION
END;
-- 
CREATE OR REPLACE PROCEDURE up_deletescore
(
   phak tbl_score.hak%TYPE
)
IS 
BEGIN
   DELETE FROM tbl_score
   WHERE hak = phak;
   -- COMMIT;
--EXCEPTION
END;

--        ©¤ - ?          ( 30~40   )
SELECT ename, sal
FROM emp
WHERE sal = 6000;  -- 0
WHERE sal = 800;   -- 1
WHERE sal = 1250;  -- 2
-- EXCEPTION(    ,    )
CREATE OR REPLACE PROCEDURE up_emplist
(
   psal emp.sal%TYPE
)
IS
  vename emp.ename%TYPE;
  vsal emp.sal%TYPE;
BEGIN
   SELECT ename, sal INTO vename, vsal
   FROM emp
   WHERE sal = psal;
   DBMS_OUTPUT.PUT_LINE( vename || ', ' || vsal );
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
   WHEN TOO_MANY_ROWS THEN
     RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
   WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;
-- Procedure UP_EMPLIST  (  )      ??    ? .
-- ORA-01422: exact fetch returns more than requested number of rows
EXEC UP_EMPLIST(6000);
EXEC UP_EMPLIST(1250);
EXEC UP_EMPLIST(800);

-- 3:05  ?     ?              o      
INSERT INTO emp ( empno, ename, deptno )
VALUES ( 9999, 'admin', 90 );
ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found

--
CREATE OR REPLACE PROCEDURE up_insertemp
(
   pempno emp.empno%TYPE
   , pename emp.ename%TYPE
   , pdeptno emp.deptno%TYPE
)
IS  
    PARENT_KEY_NOT_FOUND  EXCEPTION;
    PRAGMA EXCEPTION_INIT( PARENT_KEY_NOT_FOUND, -02291); --              ?        ? o     ?    
BEGIN
   INSERT INTO emp ( empno, ename, deptno )
   VALUES ( pempno, pename, pdeptno );
EXCEPTION
   WHEN PARENT_KEY_NOT_FOUND THEN
     RAISE_APPLICATION_ERROR(-20011, '> QUERY FK     ...');
   WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
   WHEN TOO_MANY_ROWS THEN
     RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
   WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;

EXEC UP_INSERTEMP( 9999, 'admin', 90 );

-- [                  o      ]
-- ?                            =       0 ~ 100     
--
--int kor ;
--kor = 200;   throw new ScoreOutOfBoundException()
--class ScoreOutOfBoundException extends Exception
--{
--}

SELECT COUNT(*) 
FROM emp
WHERE sal BETWEEN  ?  AND ? ;

--     COUNT(*) == 0  ? Äî                      u    ?   ?  ..
CREATE OR REPLACE PROCEDURE up_myexception
(
   psal NUMBER
)
IS
  vcount NUMBER;
  --              u     
  ZERO_EMP_COUNT EXCEPTION;
BEGIN
   SELECT COUNT(*)  INTO vcount
   FROM emp
   WHERE sal BETWEEN  psal-100  AND psal+ 100 ;
   
   IF  vcount = 0 THEN
      -- throw new         ?   ?    ();
      RAISE  ZERO_EMP_COUNT;
   ELSE
     DBMS_OUTPUT.PUT_LINE( '>       : ' || vcount );  
   END IF;
   
EXCEPTION
   WHEN ZERO_EMP_COUNT THEN
     RAISE_APPLICATION_ERROR(-20022, '> QUERY EMP COUNT 0(ZERO)...');
   WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
   WHEN TOO_MANY_ROWS THEN
     RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
   WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END ;

EXEC UP_MYEXCEPTION(6000);
EXEC UP_MYEXCEPTION(900);

--  ?©£      (?    ,     )
--   ?  
--         

--   ??(1 ©£ )
