-- MADANG
SELECT *
FROM tabs;

DESC orders;
--
SELECT *
FROM orders;
--
SELECT EXTRACT(month FROM orderdate) "month", -- 3.
    COUNT(orderdate) "Orders"
FROM Orders -- 1. 주문테이블에서
GROUP BY EXTRACT(month FROM orderdate) -- 2. 주문 월별로 그룹
Order By 'Orders' DESC;