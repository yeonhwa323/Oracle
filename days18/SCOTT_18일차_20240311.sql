-- SCOTT 18����
-- (��) : Ʈ�����, ��ȣȭ, �����ٷ�
-- Ʈ����� ó��  ( A + B ) ���� ��ü 
-- ��) ������ü
---------------- A      X  -> ���            ����
---------------- B      Y  <- �Ա�            ����

-- DML��(I,U,D)    +  LOCK(���)       -> �ݵ�� ������� (COMMIT, ROLLBACK)

-- SCOTT
-- 750204
SELECT USERENV('SESSIONID')
FROM dual;
--
SELECT *
FROM emp
WHERE ename = 'MILLER';
-- job CLERK
UPDATE emp
SET job = 'MANAGER'
WHERE ename = 'MILLER';
--1 �� ��(��) ������Ʈ�Ǿ����ϴ�.
ROLLBACK;

-- VIEW
-- PL/SQL : �����Լ�, �������ν���, Ʈ����, ��Ű�� 
C O R P
IS
BEGIN
   I
   U
   D
   S
   
   COMMIT;
E
 WHEN THEN
   ROLLBACK;
E;
   























