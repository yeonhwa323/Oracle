-- SCOTT 12����
SELECT *
FROM tabs;
--(��) : MERGE(����) x /�������� x / ���� x / ������ ����-����
--(ȭ) : DB �𵨸� + ����������Ʈ
--(��) : DB �𵨸� + ��ǥ
--(��) : PL/SQL

-- ���� = ���ڵ�, ���̺�

-- [����ȭ]
-- https://terms.naver.com/entry.naver?docId=3431238&cid=58430&categoryId=58430&expCategoryId=58430
1. �̻�����

2. �Լ� ���Ӽ�
3. ����ȭ 
--
��. ����ȭ ? �̻� ������ �߻����� �ʵ��� �Ϸ���, 
            ���� �ִ� �Ӽ���θ� �����̼��� �����ؾ� 
            �ϴµ� �̸� ���� �ʿ��� ���� ����ȭ��.
��. �Լ��� ���Ӽ�(FD;Functional Dependnecy) ?    �Ӽ��� ���� ���ü�
  �Լ��� ���� ? 
  emp ���̺�
  empno(PK) ename  ename(Y)�� empno(X)�� �Լ������� ���ӵȴ�. (�����Լ�)
     X       Y
   ������   ������
     X  ��   Y
  empno  ��  ename
  empno  ��  hiredate
  empno  ��  job
  empno  ��  (ename, job, mgr, hiredate, sal, comm, deptno)
  
  SELECT *
  FROM emp;
     
  (1) ���� �Լ��� ����
      ���� ���� �Ӽ��� �𿩼� �ϳ��� �⺻Ű(PK)�� �̷� �� == ����Ű
      ����Ű ��ü�� � �Ӽ��� �������� �� "���� �Լ��� ����"�̶�� �Ѵ�.
      ��)
      (��ID + �̺�Ʈ��ȣ)    ->   ��÷����
      
  (2) �κ� �Լ��� ���� (����Ű)
      ���� �Լ� ������ �ƴϸ� "�κ� �Լ��� ����"�̶�� �Ѵ�.
      ��)
      (��ID + �̺�Ʈ��ȣ)    ->    ���̸� XX 
      ��ID    ->    ���̸�(��ID���� �κ������� ���ӵȴ�)
      
  (3) ���� �Լ��� ����
    Y�� X�� �Լ��� �����̴�.
    X -> Y , Y -> Z �� �� X -> Z �� �Լ��� ������ �� �� "���� �Լ��� ����"�̶�� �Ѵ�.
    ������   ������       ������     ������
      X   ->  Y            Y   ->   Z       �϶�   X  ->  Z
    empno -> deptno     deptno    dname
    �����ȣ    �����     �����     �μ���

3. ����ȭ ���ǿ� �ʿ伺 - ����ȭ(normalization)   
   (1) ��1 ������( 1NF )
   �����̼ǿ� ���� ��� �Ӽ��� �������� ���� ��(atomic value)���θ�
   �����Ǿ� ������ ��1�������� ���Ѵ�.
    
    ������ ? �Ӽ� �ϳ��� ���� �� �ִ� ��� ���� ������ �ش� �Ӽ��� ������(domain)�̶� �Ѵ�.
    ��) �μ��� �÷�(�Ӽ�) - ������( ������, �����, �ѹ��� )

    ��) ȸ�� ����
        ��� �����׸� : [] ���� [] ����Ŭ [] ����
        [ȸ�� ���̺�]
        ȸ��ID(PK) ȸ����.... ���
                            ����, ����Ŭ, ����
                            
        ���̺� �и�(����)
        [ȸ�� ���̺�]
        ȸ��ID(PK)
        admin ȫ�浿
        
        [ȸ����� ���̺�]
        ȸ��ID(FK)  ��̹�ȣ(FK)
        admin       10
        admin       20
        admin       40
        
        [��� ���̺�]
        10 ����
        20 ����Ŭ
        30 ����
        40 �
        
    (2) ��2 ������( 2NF )
        �����̼��� ��1�������� ���ϰ�,
        �⺻Ű�� �ƴ� ��� �Ӽ��� �⺻Ű�� "���� �Լ� ����"�Ǹ� ��2�������� ���Ѵ�.
        "�κ� �Լ� ����"�� �����ؼ� "���� �Լ� ����"���� �Ǹ� �츮�� ��2 �������� ���Ѵٶ�� �Ѵ�.
        ����Ű -> �Ӽ�
        ��)
        ��ID  +  �̺�Ʈ��ȣ   ->  ��÷���� 
                    ��ID    ->   ���  XXX
        
    (3) ��3 ������( 3NF ) 
        �����̼��� ��2�������� ���ϰ�, 
        �⺻Ű�� �ƴ� ��� �Ӽ��� �⺻Ű�� ������ �Լ� ������ ���� ������ ��3�������� ���Ѵ�.
            X           Y         Z
            X           Z         Y       
        �����ȣ(PK)   �μ���ȣ   �μ���        
        
        ��� T
        
        �����ȣ / �μ���ȣ
        
        �μ� T
        
        �μ���ȣ / �μ���
        
    (4) ���̽�/�ڵ� ( BCNF )    
        �����̼��� �Լ� ���� ���迡�� ��� �����ڰ� �ĺ�Ű�̸� ���̽�/�ڵ� �������� ���Ѵ�.
        
        [ X + Y ] ����Ű
        [ X + Y ]-> Z   , Z  ->  Y : ����Ű�� Y �� �Ϲ�Ű�� Z �� ���ӵȴ�.
        
        [T]
        X, Z
        
        Y, Z

    (5) ��4 �������� ��5 ������
    
-- ������ �𵨸� : ������ȭ / �ε���...

-- [ ����������Ʈ : �������� DB�𵨸� + SQL�ۼ� ]

select *
from CATEGORY ;

-- CATEGORY ���̺� ( �׸� )
-- CATEGORY_NUMBER / BOARD_NUMBER / CATEGORY_CONTENT
--  �׸� �ѹ�   1~5  / �Խ��� ��ȣ  1~10  /  �׸񳻿�
-- [ CATEGORY ���̺� ( �׸� ) ]
-- �����ϴ� ���ڿ�����
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 1, '�ں���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 2, '�Ѽ���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 3, 'ȫ����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 4, '�ǳ���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 1, 5, '������' ) ;
-- ��ȣ�ϴ� �ݷ�����
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 1, '������' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 2, '�����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 3, '�ź���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 4, '�䳢' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 2, 5, '����' ) ;
-- ���� �������ϰ� �ִ� ��󸶴� ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 1, '���� ���ļ���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 2, '�����ڤ�����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 3, '�ξ�δ�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 4, '�����ִ� �ذ��' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 3, 5, '�Ƕ�̵� ����' ) ;
-- �ֱ� �� ��ȭ �� ��õ�ϰ� ���� ��ȭ�� ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 1, '��: ��Ʈ2' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 2, '�Ĺ�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 3, '��ī' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 4, '�͸��� Į��' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 4, 5, '��ǳ' ) ;
-- ���� ���� ��ȭ �� ���Ǵ� ��ȭ�� ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 1, '�극�� �̹߼�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 2, '���̿� Ƽ���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 3, '�н�Ʈ ���̺���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 4, '������ �͵�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 5, 5, '��Ʈ' ) ;
-- ������ ������ �ް���� ������ ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 1, '����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 2, '����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 3, '�����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 4, '���Ǽ�Ʈ' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 6, 5, '����/Ŀ���� ��Ʈ' ) ;
-- �̹� ���� ���ſ��� �� �� �ĺ��� �����ðڽ��ϱ� ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 1, '1���ĺ�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 2, '2���ĺ�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 3, '3���ĺ�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 4, '4���ĺ�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 7, 5, '5���ĺ�' ) ;
-- ��ȣ�ϴ� ��ǻ�� ���� ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 1, '�������غ���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 2, '��ü��' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 3, 'Ŭ����Ʈ' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 4, '�϶��϶�' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 8, 5, 'ȭ��Ʈ�ӽ�ũ' ) ;
-- �ܿ� �������� ������� ���� ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 1, '����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 2, '���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 3, '����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 4, '��â' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 9, 5, '����' ) ;
-- �轺Ų��� �� ���� �� ��ȣ�ϴ� ���� ?
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 1, '�����¿ܰ���' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 2, '�������������' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 3, '���ڳ�����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 4, '�Ƹ�����' ) ;
INSERT INTO CATEGORY( BOARD_NUMBER, CATEGORY_NUMBER, CATEGORY_CONTENT) VALUES ( 10, 5, 'Ȳġ��巡�ﺼ' ) ;

