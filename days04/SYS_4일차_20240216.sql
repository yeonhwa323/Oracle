-- SYS
SELECT * 
FROM dba_users; 

SELECT *
FROM dba_tables
WHERE owner = UPPER('scott');
--
SELECT *
FROM scott.emp;

SELECT *
FROM arirang;
FROM scott.emp;
--SYNONYM ARIRANG��(��) �����Ǿ����ϴ�.
CREATE PUBLIC SYNONYM arirang
FOR  scott.emp;
-- SYNONYM ARIRANG��(��) �����Ǿ����ϴ�.
DROP PUBLIC SYNONYM arirang;

-- �ó�� ��ȸ
SELECT *
FROM all_synonyms
WHERE synonym_name LIKE 'ARI%';
-- PUBLIC	ARIRANG	SCOTT	EMP	





