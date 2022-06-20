/*
  Alberto Collado Mambloa
  Beatriz Villegas Sánchez    
*/
/*1. Elabora un listado (sin repeticiones) con los apellidos de los clientes de la empresa que hayan
hecho algún pedido online (order_mode online) junto con el apellido del empleado que
gestiona su cuenta. Muestra en el listado primero el apellido del empleado que gestiono la
cuenta y luego el apellido del cliente, y haz que el listado se encuentre ordenado por apellido
de empleado primero y luego por apellido del cliente. Usa reuniones para ello.*/

SELECT emp.last_name, cust.cust_last_name 
FROM  PR5_ORDERS orders JOIN PR5_CUSTOMERS cust ON orders.customer_id = cust.customer_id
    JOIN PR3_EMPLOYEES emp ON cust.account_mgr_id = emp.employee_id
WHERE orders.order_mode = 'online'
GROUP BY emp.last_name, cust.cust_last_name
ORDER BY emp.last_name, cust.cust_last_name ASC;

/*2. Listado de categorías con más de 2 productos obsoletos (PRODUCT_STATUS obsolete).
Lista la categoría y el número de productos obsoletos.*/

SELECT pinfo.category_id, COUNT(*)
FROM PR5_PRODUCT_INFORMATION pinfo
WHERE pinfo.product_status = 'obsolete'
GROUP BY pinfo.category_id
HAVING COUNT(*) > 2;


/*3. Se quiere generar un “ranking” de los productos más vendidos en el último semestre del año
1990. Para ello nos piden mostrar el nombre de producto y el número de unidades vendidas
para cada producto vendido en el último semestre del año 1990 (ordenado por número de
unidades vendidas de forma descendente).*/

SELECT pinfo.product_name, item.quantity
FROM PR5_PRODUCT_INFORMATION pinfo JOIN PR5_ORDER_ITEMS item ON pinfo.product_id = item.PRODUCT_ID JOIN PR5_ORDERS orders
    ON orders.order_id = item.order_id
WHERE orders.order_date between '01/06/90' AND '31/12/90'
GROUP BY  pinfo.product_name, item.quantity
ORDER BY item.quantity DESC;

/*4. Muestra los puestos en la empresa que tienen un salario mínimo superior al salario medio de
los empleados de la compañía. El listado debe incluir el puesto y su salario mínimo, y estar
ordenado ascendentemente por salario mínimo.*/

SELECT jobs.JOB_TITLE, jobs.MIN_SALARY
FROM PR3_JOBS jobs, PR3_JOBS jobAVG
GROUP BY jobs.JOB_TITLE, jobs.MIN_SALARY
HAVING AVG(jobAVG.min_salary) < jobs.MIN_SALARY
ORDER BY jobs.MIN_SALARY ASC;

/*5. Mostrar el Public Relations Representativecódigo, nombre y precio mínimo de  productos de la categoría 14 que no aparecen 
en ningún pedido. Usa para ello una subconsulta no correlacionada.*/

SELECT pinfo.supplier_id, pinfo.product_name, pinfo.min_price
FROM PR5_PRODUCT_INFORMATION pinfo
WHERE pinfo.category_id = 14
GROUP BY pinfo.supplier_id, pinfo.product_name, pinfo.min_price
MINUS
SELECT pinfo.supplier_id, pinfo.product_name, pinfo.min_price
FROM PR5_PRODUCT_INFORMATION pinfo JOIN PR5_ORDER_ITEMS item ON pinfo.PRODUCT_ID = item.PRODUCT_ID
WHERE pinfo.category_id = 14
GROUP BY pinfo.supplier_id, pinfo.product_name, pinfo.min_price;


/*6. Mostrar el código de cliente, nombre y apellidos de aquellos clientes alemanes
(NLS_TERRITORY GERMANY) que no han realizado ningún pedido. Usa para ello una consulta
correlacionada.*/

SELECT cust.customer_id , cust.cust_first_name, cust.cust_last_name
FROM PR5_CUSTOMERS cust LEFT OUTER JOIN (SELECT customer_id FROM PR5_ORDERS) ORDERS
        ON cust.customer_id = ORDERS.customer_id 
WHERE cust.nls_territory = 'GERMANY' AND ORDERS.customer_id IS NULL;

/*7. Mostrar el código de cliente, nombre y apellidos (sin repetición) de aquellos clientes que han
realizado al menos un pedido de tipo (order_mode) online y otro direct.*/

SELECT c.customer_id, c.cust_first_name, c.cust_last_name
FROM  PR5_CUSTOMERS c JOIN PR5_ORDERS o ON c.customer_id = o.CUSTOMER_ID  
WHERE (SELECT c1.customer_id 
      FROM PR5_CUSTOMERS c1 JOIN PR5_ORDERS o1 ON c1.customer_id = o1.customer_id
      WHERE o1.order_mode = 'direct') = 
      (SELECT c2.customer_id 
      FROM PR5_CUSTOMERS c2 JOIN PR5_ORDERS o2 ON c2.customer_id = o2.customer_id
      WHERE o2.order_mode = 'online')
GROUP BY c.customer_id, c.cust_first_name, c.cust_last_name;
/*
SELECT cust.customer_id, cust.cust_first_name, cust.cust_last_name
FROM PR5_CUSTOMERS cust JOIN PR5_ORDERS orders ON cust.customer_id = orders.customer_id
WHERE orders.order_mode = 'online'  AND orders.order_mode = 'direct'
    AND (SELECT COUNT(order_mode) FROM PR5_ORDERS WHERE order_mode = 'online') >= 1 
    AND (SELECT COUNT(order_mode) FROM PR5_ORDERS WHERE order_mode = 'direct') >= 1 
GROUP BY cust.customer_id, cust.cust_first_name, cust.cust_last_name
ORDER BY cust.customer_id;
*/

/*8. Mostrar el nombre y apellidos de aquellos clientes que, habiendo realizado algún pedido,
nunca han realizado pedidos de tipo direct.*/

SELECT cust.cust_first_name, cust.cust_last_name
FROM PR5_CUSTOMERS cust JOIN PR5_ORDERS orders ON cust.customer_id = orders.customer_id
GROUP BY cust.cust_first_name, cust.cust_last_name
MINUS
SELECT cust.cust_first_name, cust.cust_last_name
FROM PR5_CUSTOMERS cust JOIN PR5_ORDERS orders ON cust.customer_id = orders.customer_id
WHERE orders.order_mode = 'direct'
GROUP BY cust.cust_first_name, cust.cust_last_name;

/*9. Se quiere generar un listado de los productos que generan mayor beneficio. Mostrar el código
de producto, su precio mínimo, su precio de venta al público y el porcentaje de incremento
de precio. En el listado deben aparecer solo aquellos cuyo precio de venta al público ha
superado en  un 30 % al precio mínimo.*/

SELECT p.product_id, p.min_price, item.unit_price
FROM ;
/*10. Mostrar el apellido de los empleados que ganen un 35% más del salario medio de su puesto.
El listado debe incluir el salario del empleado y su puesto.*/

SELECT emp.last_name, emp.salary, jobs.job_title
FROM PR3_EMPLOYEES emp JOIN PR3_JOBS jobs ON emp.job_id = jobs.JOB_ID
WHERE emp.salary >= ((SELECT AVG(salary) FROM PR3_EMPLOYEES) + 0.35*(SELECT AVG(salary) FROM PR3_EMPLOYEES))
GROUP BY emp.last_name, emp.salary, jobs.job_title;
