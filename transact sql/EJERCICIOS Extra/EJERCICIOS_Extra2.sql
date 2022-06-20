/*EJERCICIOS EXTRA*/
USE [master]

DROP DATABASE IF EXISTS ventas;
CREATE DATABASE ventas COLLATE Latin1_General_100_CI_AI_SC
GO

USE [ventas]

CREATE TABLE cliente (
  id INT IDENTITY(1,1) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  ciudad VARCHAR(100),
  categoría INT
);

CREATE TABLE comercial (
  id INT IDENTITY(1,1) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  comisión FLOAT
);

CREATE TABLE pedido (
  id INT IDENTITY(1,1) PRIMARY KEY,
  total FLOAT NOT NULL,
  fecha DATE,
  id_cliente INT NOT NULL,
  id_comercial INT NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id),
  FOREIGN KEY (id_comercial) REFERENCES comercial(id)
);

INSERT INTO cliente VALUES('Aarón', 'Rivero', 'Gómez', 'Almería', 100);
INSERT INTO cliente VALUES('Adela', 'Salas', 'Díaz', 'Granada', 200);
INSERT INTO cliente VALUES('Adolfo', 'Rubio', 'Flores', 'Sevilla', NULL);
INSERT INTO cliente VALUES('Adrián', 'Suárez', NULL, 'Jaén', 300);
INSERT INTO cliente VALUES('Marcos', 'Loyola', 'Méndez', 'Almería', 200);
INSERT INTO cliente VALUES('María', 'Santana', 'Moreno', 'Cádiz', 100);
INSERT INTO cliente VALUES('Pilar', 'Ruiz', NULL, 'Sevilla', 300);
INSERT INTO cliente VALUES('Pepe', 'Ruiz', 'Santana', 'Huelva', 200);
INSERT INTO cliente VALUES('Guillermo', 'López', 'Gómez', 'Granada', 225);
INSERT INTO cliente VALUES('Daniel', 'Santana', 'Loyola', 'Sevilla', 125);

INSERT INTO comercial VALUES('Daniel', 'Sáez', 'Vega', 0.15);
INSERT INTO comercial VALUES('Juan', 'Gómez', 'López', 0.13);
INSERT INTO comercial VALUES('Diego','Flores', 'Salas', 0.11);
INSERT INTO comercial VALUES('Marta','Herrera', 'Gil', 0.14);
INSERT INTO comercial VALUES('Antonio','Carretero', 'Ortega', 0.12);
INSERT INTO comercial VALUES('Manuel','Domínguez', 'Hernández', 0.13);
INSERT INTO comercial VALUES('Antonio','Vega', 'Hernández', 0.11);
INSERT INTO comercial VALUES('Alfredo','Ruiz', 'Flores', 0.05);

INSERT INTO pedido VALUES(150.5, '2017-10-05', 5, 2);
INSERT INTO pedido VALUES(270.65, '2016-09-10', 1, 5);
INSERT INTO pedido VALUES(65.26, '2017-10-05', 2, 1);
INSERT INTO pedido VALUES(110.5, '2016-08-17', 8, 3);
INSERT INTO pedido VALUES(948.5, '2017-09-10', 5, 2);
INSERT INTO pedido VALUES(2400.6, '2016-07-27', 7, 1);
INSERT INTO pedido VALUES(5760, '2015-09-10', 2, 1);
INSERT INTO pedido VALUES(1983.43, '2017-10-10', 4, 6);
INSERT INTO pedido VALUES(2480.4, '2016-10-10', 8, 3);
INSERT INTO pedido VALUES(250.45, '2015-06-27', 8, 2);
INSERT INTO pedido VALUES(75.29, '2016-08-17', 3, 7);
INSERT INTO pedido VALUES(3045.6, '2017-04-25', 2, 1);
INSERT INTO pedido VALUES(545.75, '2019-01-25', 6, 1);
INSERT INTO pedido VALUES(145.82, '2017-02-02', 6, 1);
INSERT INTO pedido VALUES(370.85, '2019-03-11', 1, 5);
INSERT INTO pedido VALUES(2389.23, '2019-03-11', 1, 5);


--1.	Devuelve un listado con el identificador, nombre y los apellidos de todos los clientes que han realizado algún pedido. El listado debe estar ordenado alfabéticamente y se deben eliminar los elementos repetidos.
SELECT DISTINCT c.id, c.nombre, c.apellido1, c.apellido2
FROM cliente c
INNER JOIN pedido p
ON c.id = p.id_cliente
ORDER BY c.nombre, c.apellido1, c.apellido2

--2.	Devuelve un listado que muestre todos los pedidos que ha realizado cada cliente. El resultado debe mostrar todos los datos de los pedidos y del cliente. El listado debe mostrar los datos de los clientes ordenados alfabéticamente.
SELECT *
FROM cliente c
INNER JOIN pedido p
ON c.id = p.id_cliente
ORDER BY c.nombre, c.apellido1, c.apellido2

--3.	Devuelve un listado que muestre todos los pedidos en los que ha participado un comercial. El resultado debe mostrar todos los datos de los pedidos y de los comerciales. El listado debe mostrar los datos de los comerciales ordenados alfabéticamente.
SELECT * 
FROM pedido p
INNER JOIN comercial c
ON p.id_comercial = c.id
ORDER BY c.nombre, c.apellido1, c.apellido2

--4.	Devuelve un listado que muestre todos los clientes, con todos los pedidos que han realizado y con los datos de los comerciales asociados a cada pedido.
SELECT *
FROM cliente c
INNER JOIN pedido p
ON c.id = p.id_cliente
INNER JOIN comercial co
ON p.id_comercial = co.id

--5.	Devuelve un listado de todos los clientes que realizaron un pedido durante el año 2017, cuya cantidad esté entre 300 € y 1000 €.
SELECT *
FROM cliente c
INNER JOIN pedido p
ON c.id = p.id_cliente
WHERE YEAR(p.fecha) = 2017 AND p.total BETWEEN 300 AND 1000

--6.	Devuelve el nombre y los apellidos de todos los comerciales que ha participado en algún pedido realizado por María Santana Moreno.
SELECT DISTINCT c.nombre, c.apellido1, c.apellido2
FROM comercial c
INNER JOIN pedido p
ON c.id = p.id_comercial
INNER JOIN cliente cl
ON cl.id = p.id_cliente
WHERE p.id_cliente = (SELECT cl.id FROM cliente cl WHERE cl.nombre = 'María' AND cl.apellido1 = 'Santana' AND cl.apellido2 = 'Moreno') 


--7.	Devuelve el nombre de todos los clientes que han realizado algún pedido con el comercial Daniel Sáez Vega.
SELECT DISTINCT cl.nombre, cl.apellido1, cl.apellido2
FROM cliente cl
INNER JOIN pedido p
ON cl.id = p.id_cliente
INNER JOIN comercial c
ON c.id = p.id_comercial
WHERE p.id_comercial = (SELECT c.id FROM comercial c WHERE c.nombre = 'Daniel' AND c.apellido1 = 'Sáez' AND c.apellido2 = 'Vega') 

--8.	Devuelve un listado con todos los clientes junto con los datos de los pedidos que han realizado. Este listado también debe incluir los clientes que no han realizado ningún pedido. El listado debe estar ordenado alfabéticamente por el primer apellido, segundo apellido y nombre de los clientes.
SELECT *
FROM cliente cl
LEFT JOIN pedido p
ON cl.id = p.id_cliente
ORDER BY cl.nombre, cl.apellido1, cl.apellido2

--9.	Devuelve un listado con todos los comerciales junto con los datos de los pedidos que han realizado. Este listado también debe incluir los comerciales que no han realizado ningún pedido. El listado debe estar ordenado alfabéticamente por el primer apellido, segundo apellido y nombre de los comerciales.
SELECT *
FROM comercial c
LEFT JOIN pedido p
ON c.id = p.id_comercial
ORDER BY c.nombre, c.apellido1, c.apellido2

--10.	Devuelve un listado que solamente muestre los clientes que no han realizado ningún pedido.
SELECT *
FROM cliente cl
LEFT JOIN pedido p
ON cl.id = p.id_cliente
WHERE p.id_cliente IS NULL


--11.	Devuelve un listado que solamente muestre los comerciales que no han realizado ningún pedido.
SELECT *
FROM comercial c
LEFT JOIN pedido p
ON c.id = p.id_comercial
WHERE p.id_comercial IS NULL


--12.	Devuelve un listado con los clientes que no han realizado ningún pedido y de los comerciales que no han participado en ningún pedido. Ordene el listado alfabéticamente por los apellidos y el nombre. En en listado deberá diferenciar de algún modo los clientes y los comerciales.
SELECT cl.id, cl.nombre, cl.apellido1, cl.apellido2
FROM cliente cl
LEFT JOIN pedido p
ON cl.id = p.id_cliente
WHERE p.id_cliente IS NULL
UNION
SELECT c.id, c.nombre, c.apellido1, c.apellido2
FROM comercial c
LEFT JOIN pedido p
ON c.id = p.id_comercial
WHERE p.id_comercial IS NULL

--13.	Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada uno de los clientes. Es decir, el mismo cliente puede haber realizado varios pedidos de diferentes cantidades el mismo día. Se pide que se calcule cuál es el pedido de máximo valor para cada uno de los días en los que un cliente ha realizado un pedido. Muestra el identificador del cliente, nombre, apellidos, la fecha y el valor de la cantidad.
SELECT c.id, c.nombre, c.apellido1,c.apellido2, p.fecha, MAX(p.total) MaxVal
FROM pedido p
INNER JOIN cliente c
ON p.id_cliente = c.id
GROUP BY c.id, c.nombre, c.apellido1,c.apellido2, p.fecha


--14.	Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada uno de los clientes, teniendo en cuenta que sólo queremos mostrar aquellos pedidos que superen la cantidad de 2000 €.
SELECT c.id, c.nombre, c.apellido1,c.apellido2, p.fecha, MAX(p.total) MaxVal
FROM pedido p
INNER JOIN cliente c
ON p.id_cliente = c.id
GROUP BY c.id, c.nombre, c.apellido1,c.apellido2, p.fecha
HAVING MAX(p.total) > 2000 

--15.	Calcula el máximo valor de los pedidos realizados para cada uno de los comerciales durante la fecha 2016-08-17. Muestra el identificador del comercial, nombre, apellidos y total.
SELECT c.id, c.nombre, c.apellido1,c.apellido2, MAX(p.total) MaxVal
FROM pedido p
INNER JOIN comercial c
ON p.id_comercial = c.id
GROUP BY c.id, c.nombre, c.apellido1, c.apellido2, p.fecha
HAVING p.fecha = '2016-08-17'

select * from pedido
--16.	Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de pedidos que ha realizado cada uno de clientes. Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido. Estos clientes también deben aparecer en el listado indicando que el número de pedidos realizados es 0.
SELECT cl.id, cl.nombre, cl.apellido1, cl.apellido2, COUNT(p.id_cliente) pedidos_Realizados
FROM cliente cl
LEFT JOIN pedido p
ON cl.id = p.id_cliente
GROUP BY cl.id,cl.nombre, cl.apellido1, cl.apellido2
ORDER BY pedidos_Realizados desc

--17.	Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de pedidos que ha realizado cada uno de clientes durante el año 2017.
SELECT cl.id, cl.nombre, cl.apellido1, cl.apellido2, COUNT(p.id_cliente) pedidos_Realizados
FROM cliente cl
LEFT JOIN pedido p
ON cl.id = p.id_cliente
GROUP BY cl.id,cl.nombre, cl.apellido1, cl.apellido2, p.fecha
HAVING YEAR(p.fecha) = 2017
ORDER BY pedidos_Realizados desc

--18.	Devuelve un listado que muestre el identificador de cliente, nombre, primer apellido y el valor de la máxima cantidad del pedido realizado por cada uno de los clientes. El resultado debe mostrar aquellos clientes que no han realizado ningún pedido indicando que la máxima cantidad de sus pedidos realizados es 0. Puede hacer uso de la función IFNULL.
SELECT cl.id, cl.nombre, cl.apellido1, cl.apellido2, ISNULL(MAX(p.total), 0) Max_Val /*OJO FUNCION IFNULL*/
FROM cliente cl
LEFT JOIN pedido p
ON cl.id = p.id_cliente
GROUP BY cl.id,cl.nombre, cl.apellido1, cl.apellido2

--19.	Devuelve cuál ha sido el pedido de máximo valor que se ha realizado cada año.


--20.	Devuelve el número total de pedidos que se han realizado cada año.


--21.	Devuelve un listado con todos los pedidos que ha realizado Adela Salas Díaz. (Sin utilizar INNER JOIN).


--22.	Devuelve el número de pedidos en los que ha participado el comercial Daniel Sáez Vega. (Sin utilizar INNER JOIN)


--23.	Devuelve los datos del cliente que realizó el pedido más caro en el año 2019. (Sin utilizar INNER JOIN)


--24.	Devuelve la fecha y la cantidad del pedido de menor valor realizado por el cliente Pepe Ruiz Santana.
SELECT p.fecha, MIN(p.total) Min_Price
FROM pedido p
INNER JOIN cliente c
ON p.id_cliente = c.id
WHERE c.nombre = 'Pepe' AND c.apellido1 = 'Ruiz' AND c.apellido2 = 'Santana'
GROUP BY p.fecha
--OR
SELECT p.fecha, MIN(p.total) Min_Price
FROM pedido p
INNER JOIN cliente c
ON p.id_cliente = c.id
WHERE p.id_cliente = (SELECT c.id FROM cliente c WHERE c.nombre = 'Pepe' AND c.apellido1='Ruiz' AND c.apellido2 = 'Santana')
GROUP BY p.fecha




--25.	Devuelve un listado con los datos de los clientes y los pedidos, de todos los clientes que han realizado un pedido durante el año 2017 con un valor mayor o igual al valor medio de los pedidos realizados durante ese mismo año.
SELECT c.id, c.nombre, c.apellido1,c.apellido2
FROM pedido p
INNER JOIN cliente c
ON p.id_cliente = c.id
GROUP BY c.id, c.nombre, c.apellido1,c.apellido2, p.fecha, p.total
HAVING YEAR(p.fecha) = 2017 AND p.total > (SELECT AVG(p.total) FROM pedido p WHERE YEAR(p.fecha) = 2017)

-- OR

SELECT *
FROM pedido p
INNER JOIN cliente c
ON p.id_cliente = c.id
--GROUP BY c.id, c.nombre, c.apellido1,c.apellido2, p.fecha, p.total
WHERE YEAR(p.fecha) = 2017 AND p.total > (SELECT AVG(p.total) FROM pedido p WHERE YEAR(p.fecha) = 2017)



--26.	Devuelve un listado de los clientes que no han realizado ningún pedido. (Utilizando IN o NOT IN).
SELECT c.id, c.nombre, c.apellido1, c.apellido2
FROM cliente c
WHERE c.id NOT IN (SELECT p.id_cliente FROM pedido p );

--27.	Devuelve un listado de los comerciales que no han realizado ningún pedido. (Utilizando IN o NOT IN).
SELECT c.id, c.nombre, c.apellido1, c.apellido2
FROM comercial c
WHERE c.id NOT IN (SELECT p.id_comercial FROM pedido p );