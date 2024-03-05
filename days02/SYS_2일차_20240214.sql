-- SYS
SELECT *
FROM dba_users;
--
ALTER USER hr IDENTIFIED BY lion
ACCOUNT UNLOCK;
--
SELECT a.spid, b.name, c.server, c.type
FROM v$process a, v$bgprocess b, v$session c
WHERE b.PADDR(+) = a.ADDR AND a.ADDR = c.PADDR
    AND b.NAME is NULL;
-- 테이블스페이스 조회(확인) -- p509
--SELECT tablespace_name, file_name 
SELECT *
FROM dba_data_files;

SELECT tablespace_name,status 
FROM dba_tablespaces;
