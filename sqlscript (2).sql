REM   Script: MEIIRMAN_ALUA_CS2007_redocter
REM   dfjb

SELECT order_id, order_datetime, full_name 
FROM co.orders, co.customers 
WHERE orders.customer_id = customers.customer_id 
AND orders.order_status = 'REFUNDED' 
AND orders.order_datetime BETWEEN TO_DATE('01/10/2018','DD/MM/YYYY') AND TO_DATE('31/10/2018', 'DD/MM/YYYY')  
ORDER BY order_id DESC;

SELECT o.order_id, c.full_name AS full_name 
FROM co.customers c  
JOIN co.orders o 
ON (c.customer_id = o.customer_id) 
JOIN co.order_items i 
ON (o.order_id = i.order_id) 
JOIN co.products p 
ON (p.product_id = i.product_id) 
WHERE p.product_name = 'Boy''s Sweater (Green)'  
INTERSECT 
SELECT o.order_id, c.full_name AS "full name" 
FROM co.customers c  
JOIN co.orders o 
ON (c.customer_id = o.customer_id) 
JOIN co.order_items i 
ON (o.order_id = i.order_id) 
JOIN co.products p 
ON (p.product_id = i.product_id) 
WHERE p.product_name = 'Men''s Shorts (Black)';

SELECT order_id, ROUND(SUM(unit_price*QUANTITY)) total_price 
FROM co.order_items i  
WHERE order_id IN ( 
SELECT order_id o 
FROM co.order_items i     
INNER JOIN co.products p 
USING (product_id) 
WHERE p.product_name = 'Men''s Pyjamas (Blue)' 
INTERSECT 
SELECT order_id  
FROM co.order_items i   
INNER JOIN co.products p 
USING (product_id) 
WHERE p.product_name = 'Girl''s Jeans (Grey)') 
GROUP BY order_id;

SELECT order_id, COUNT(*) order_id, SUM(quantity*unit_price) AS total_price  
FROM co.orders  
NATURAL JOIN co.order_items  
WHERE order_id IN ( SELECT order_id  
FROM co.order_items WHERE product_id = (SELECT product_id  
FROM co.products WHERE product_name = 'Boy''s Socks (Black)')   
INTERSECT   
SELECT order_id  
FROM co.order_items  
WHERE product_id = (SELECT product_id  
FROM co.products  
WHERE product_name = 'Boy''s Jeans (Black)')   
MINUS    
SELECT order_id  
FROM co.order_items WHERE product_id = (SELECT product_id  
FROM co.products  
WHERE product_name = 'Girl''s Pyjamas (Black)'))  
GROUP BY order_id  
HAVING COUNT(*)=3;

SELECT store_name, COUNT(DISTINCT(order_id)) AS TOTAL_ORDERS, ROUND(SUM(unit_price* QUANTITY)) AS "TOTAL PRICE", SUM(QUANTITY) AS "TOTAL PROD" 
FROM co.stores JOIN co.orders USING (store_id) 
JOIN co.order_items USING (order_id) 
WHERE order_status = 'CANCELLED' 
GROUP BY store_name 
ORDER BY total_orders;

SELECT store_name, COUNT(DISTINCT(order_id)) AS TOTAL_ORDERS, ROUND(SUM(unit_price* QUANTITY)) AS "TOTAL PRICE", ROUND(SUM(QUANTITY)) AS "TOTAL PROD" 
FROM co.stores JOIN co.orders USING (store_id) 
JOIN co.order_items USING (order_id) 
WHERE order_status = 'CANCELLED' 
GROUP BY store_name 
ORDER BY total_orders;

