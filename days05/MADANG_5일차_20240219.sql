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
FROM Orders -- 1. �ֹ����̺���
GROUP BY EXTRACT(month FROM orderdate) -- 2. �ֹ� ������ �׷�
Order By 'Orders' DESC;