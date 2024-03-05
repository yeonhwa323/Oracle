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
                    
-- EXIST 질의 4-16
-- AVG(), SUM(), MAX(), MIN() 집계함수, 그룹함수
SELECT SUM(saleprice), AVG (saleprice),MAX (saleprice), MIN(saleprice)
FROM orders;

-- 모든 고객들의 총 판매금액 ( 118000 )
SELECT SUM(saleprice)
FROM orders;
-- 대한민국 고객 체크 ? address 컬럼에 "대한민국"문자열 포함.
SELECT *
FROM customer
WHERE address LIKE '%대한민국%'; -- custid 2,3,5

-- 대한민국 고객들의 총 판매금액 조회
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
                    
                    