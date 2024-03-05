-- SYS
SELECT * 
FROM dba_users; 

SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = UPPER('date');