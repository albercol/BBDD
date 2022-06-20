USE [master]
GO

/*Creamos el Database*/
IF EXISTS(SELECT * FROM sys.databases WHERE name='TestData2022')
BEGIN
	DROP DATABASE [EjerciciosDiego]
END

CREATE DATABASE [EjerciciosDiego]
GO

USE [EjerciciosDiego]
GO

/*A) Creamos la tabla pais*/
CREATE TABLE pais(
	pk_id INT NOT NULL,
	iso_num INT NOT NULL,
	iso2 VARCHAR(3) NOT NULL, 
	nombre VARCHAR(50) NOT NULL
)
GO
--DROP TABLE pais

/*B) Creamos una tabla fabricante*/
CREATE TABLE fabricante(
	codigo INT IDENTITY(1,1),
	nombre VARCHAR(50) NOT NULL,
	id_pais VARCHAR(3)
)
GO


/*C) Creamos una tabla producto*/
CREATE TABLE producto(
	codigo INT IDENTITY(1,1),
	nombre VARCHAR(50),
	precio MONEY,
	codigo_fabricante INT
)

--DROP TABLE producto
--DROP TABLE fabricante
--DROP TABLE pais

--DBCC CHECKIDENT(producto, RESEED, 0)
--DBCC CHECKIDENT(fabricante, RESEED, 0)
--DBCC CHECKIDENT(pais, RESEED, 0)
/*
CREATE TABLE producto (
	codigo INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(100) NOT NULL,
	precio FLOAT NOT NULL,
	codigo_fabricante INT NOT NULL
)
*/

/*D) Insertamos en la tabla fabricante*/
INSERT INTO fabricante VALUES ('Asus', NULL)
INSERT INTO fabricante VALUES ('Lenovo', NULL)

SELECT * FROM fabricante

/*E) Insertamos en la tabla de producto*/
DECLARE @cod1 INT
SELECT @cod1 = f.codigo FROM fabricante f WHERE f.nombre = 'Asus'
INSERT INTO producto VALUES ('Monitor 24 LED Full HD', 202.1, @cod1)

DECLARE @cod2 INT
SELECT @cod2 = f.codigo FROM fabricante f WHERE f.nombre = 'Lenovo'
INSERT INTO producto VALUES ('Portátil Yoga 520', 559, @cod2)

SELECT * FROM producto


/*
ALTER TABLE 
ADD nombre VARCHAR(30) NOT NULL
*/
--------------------------------------------------------------
-- 1ª PARTE
--------------------------------------------------------------
--1. Lista los nombres y los precios de todos los productos de la tabla producto
SELECT p.nombre, p.precio 
FROM  producto p

--2. Lista todas las columnas de la tabla producto.
SELECT * FROM producto


--3. Lista los nombres de los fabricantes ordenados de forma ascendente.
SELECT f.nombre 
FROM fabricante f
ORDER BY f.nombre asc

--4. Lista todos los productos que tengan un precio entre 80€ y 300€
SELECT *
FROM producto p
WHERE p.precio > 80 AND p.precio < 300

--5. Lista el nombre del fabricante con el nombre de su producto
SELECT f.nombre, p.nombre
FROM fabricante f
INNER JOIN producto p
ON f.codigo  = p.codigo_fabricante

SELECT f.nombre, p.nombre
FROM fabricante f
LEFT JOIN producto p
ON f.codigo  = p.codigo_fabricante

--6. Lista los nombres de los fabricante que no tienen producto asociado
SELECT f.nombre
FROM fabricante f
WHERE NOT EXISTS (SELECT * FROM producto p 
	WHERE f.codigo = p.codigo_fabricante );

--7. Devuelve todos los productos del fabricante Lenovo  ---------------------------> !!!!! LA instruccion IN ejecuta una lista de valores.
SELECT p.codigo, p.nombre 
FROM producto p
WHERE p.codigo_fabricante = (SELECT f.codigo FROM fabricante f WHERE f.nombre = 'Lenovo')



---------------------------------------------------------------
-- 2ª PARTE
---------------------------------------------------------------

--1. Lista el nombre de todos los fabricantes en una columna, y en otra columna obtenga en mayúsculas los dos primeros caracteres del nombre del fabricante.
SELECT  f.nombre, UPPER(left(f.nombre,2))
FROM fabricante f

--2. Devuelve una lista con las 5 primeras filas de la tabla fabricante.
SELECT TOP 5 *
FROM fabricante

--3. Lista los nombres y los precios de todos los productos de la tabla producto, redondeando el valor del precio
SELECT p.nombre, FLOOR(p.precio) precio
FROM producto p

SELECT p.nombre, ROUND(p.precio, 0) precio
FROM producto p

--4. Lista nombre del producto junto el código del fabricante separado por un guión y ponlo en una sóla columna
SELECT CONCAT(p.nombre, '  -  ' ,p.codigo_fabricante) NomProductoYCodFabricante
FROM producto p

--5. Lista todos los productos que tengan un precio entre 80€ y 300€
SELECT *
FROM producto p
WHERE p.precio > 80 AND p.precio < 300

SELECT *
FROM producto p
WHERE p.precio BETWEEN 80 AND 300

--6. Lista el nombre y el precio de los productos en céntimos. Cree un alias para la columna que contiene el precio que se llame céntimos
SELECT p.nombre, p.precio*100 céntimos
FROM producto p

--7. Lista los nombres de los fabricantes cuyo nombre empiece por la letra S.
SELECT f.nombre
FROM fabricante f
WHERE f.nombre LIKE 's%'

--8. Lista los nombres de los fabricantes cuyo nombre sea de 4 caracteres. (cualquiera)
SELECT f.nombre 
FROM fabricante f
WHERE 4 = LEN(f.nombre)

--9. Devuelve una lista con el nombre de todos los productos que contienen la cadena Portátil en el nombre
SELECT p.nombre
FROM producto p
WHERE p.nombre LIKE '%Portátil%'

--10. Devuelve una lista con el nombre de todos los productos que contienen la cadena Monitor en el nombre o tienen un precio inferior a 215 €. Ordenado por el precio más barato y en segundo lugar nombre alfabeticamente
SELECT p.nombre, p.precio
FROM producto p
WHERE p.nombre LIKE '%Monitor%' AND p.precio < 215
ORDER BY p.precio asc, p.nombre desc

--11. Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).
SELECT f.nombre
FROM fabricante f
WHERE f.codigo IN (SELECT p.codigo_fabricante FROM producto p );


---------------------------------------------------------------
-- 3ª PARTE
---------------------------------------------------------------
--1. Calcula el número total de productos que hay en la tabla productos.
SELECT COUNT(p.codigo) total_productos
FROM producto p

--2. Calcula la media del precio de todos los productos.
SELECT AVG(p.precio) Media_precio
FROM producto p

--3. Lista el nombre y el precio del producto más barato

SELECT p.nombre, p.precio
FROM producto p
WHERE p.precio = (SELECT MIN(p.precio) FROM producto p)
GO
--OR
SELECT precio, nombre
FROM (SELECT ROW_NUMBER() OVER (ORDER BY p.precio asc) as num_fila, p.nombre, p.precio
FROM producto p) tabla
WHERE num_fila=1
GO

--4. Calcula la suma del precio de todos los productos del fabricante Asus.
SELECT SUM(p.precio) precio_total_Asus
FROM producto p
WHERE p.codigo_fabricante = (SELECT f.codigo FROM fabricante f WHERE f.nombre LIKE '%Asus%')
--Tambien se puede hacer con INNER JOIN asi no se haria con subqueris.

--5. Calcula el número de valores distintos de nombres de fabricante aparecen en la tabla productos
SELECT COUNT(DISTINCT p.codigo_fabricante) fabricantes_distintos
FROM producto p

--6. Devuelve un listado con los nombres de los fabricantes que tienen 2 o más productos.

SELECT f.nombre
FROM fabricante f
LEFT JOIN producto p
ON f.codigo = p.codigo_fabricante
GROUP BY f.nombre
HAVING COUNT(p.codigo_fabricante) >= 2

--7. Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con un precio superior o igual a 220 €. No es necesario mostrar el nombre de los fabricantes que no tienen productos que cumplan la condición.

SELECT f.nombre, COUNT(p.codigo_fabricante), p.precio
FROM fabricante f
INNER JOIN producto p
ON f.codigo = p.codigo_fabricante
WHERE p.precio >= 220
GROUP BY f.nombre, p.precio

SELECT f.nombre, COUNT(p.codigo_fabricante)
FROM fabricante f
INNER JOIN producto p
ON f.codigo = p.codigo_fabricante
WHERE p.precio >= 220
GROUP BY f.nombre

--8. Asigna como país China a los fabricantes Lenovo, Gigabyte, Huawei, Xiaomi.
UPDATE fabricante 
SET fabricante.id_pais = (SELECT pa.iso_num FROM  pais pa WHERE pa.nombre = 'China')
WHERE fabricante.nombre IN ('Lenovo', 'Gigabyte', 'Huawei', 'Xiaomi')

select * FROM pais

--9. Lista de que países son cada uno de los productos. ¿tiene sentido?

SELECT pa.nombre, p.nombre
FROM pais pa
INNER JOIN fabricante f
ON pa.iso_num = f.id_pais
INNER JOIN producto p
ON p.codigo_fabricante = f.codigo