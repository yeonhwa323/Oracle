-- MADANG
SELECT *
FROM tabs;

SELECT  saleprice
FROM orders
WHERE custid = 3;

SELECT MAX(saleprice)
FROM orders
WHERE custid = 3;

SELECT orderid,custid, saleprice
FROM orders
WHERE saleprice > ALL (SELECT saleprice
                    FROM orders
                    WHERE custid = 3);
                    
WHERE saleprice > (SELECT MAX(saleprice)
                    FROM orders
                    WHERE custid = 3);
                    
-- EXIST ���� 4-16
-- AVG(), SUM(), MAX(), MIN() �����Լ�, �׷��Լ�
SELECT SUM(saleprice), AVG (saleprice),MAX (saleprice), MIN(saleprice)
FROM orders;

-- ��� ������ �� �Ǹűݾ� ( 118000 )
SELECT SUM(saleprice)
FROM orders;
-- ���ѹα� �� üũ ? address �÷��� "���ѹα�"���ڿ� ����.
SELECT *
FROM customer
WHERE address LIKE '%���ѹα�%'; -- custid 2,3,5

-- ���ѹα� ������ �� �Ǹűݾ� ��ȸ
--custid, saleprice--
SELECT SUM(saleprice) 
FROM orders
WHERE custid IN (2,3,5);

--
SELECT saleprice
FROM orders;
6000
21000
8000
6000
20000
12000
13000
12000
7000
13000          
                    
                    