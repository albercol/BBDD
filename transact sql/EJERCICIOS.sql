--Alberto Collado Mamblona.
-- Ejercicios t-SQL

-----------------------------------------------
--1 CREATING DATA BASE OBJECTS
-----------------------------------------------
/*Sin conectarse a ningun bbdd*/
USE [master]
GO

/*Creamos el Database*/
IF EXISTS(SELECT * FROM sys.databases WHERE name='TestData2022')
BEGIN
	DROP DATABASE TestData2022
END

CREATE DATABASE TestData2022
GO

USE [TestData2022]
GO

/*Cremos la tabla producto*/
CREATE TABLE Products(
	ProductID INT NOT NULL,
	ProductName varchar(25) NOT NULL,
	Price MONEY,
	ProductDescription TEXT NULL
)
GO

--DROP TABLE Products

/*Creamos un triger que pruebe que la insercion se puede realizar y no hay un elemento en la tabla con el mismo id*/
IF OBJECT_ID('triggerProducts', 'TR') IS NOT NULL
	DROP TRIGGER triggerProducts;
GO

CREATE TRIGGER triggerProducts ON Products
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @varid INT
	SELECT @varid = INSERTED.ProductId FROM inserted
	--PRINT ('EL codigo de la empresa es: ' + CAST(@varid as varchar(2)))

	DECLARE @instid INT = -1
	SELECT @instid = p.ProductId FROM Products p  WHERE p.ProductId= @varid
	--PRINT ('EL codigo de la insercion es: ' + CAST(@instid as varchar(2)))

	IF (@varid != @instid)
	BEGIN
		INSERT INTO Products VALUES ((SELECT ins.ProductId FROM INSERTED ins),
									(SELECT ins.ProductName FROM INSERTED ins), 
									(SELECT ins.Price FROM INSERTED ins), 
									(SELECT ins.ProductDescription FROM inserted ins))
		PRINT 'INSERCION REALIZADA CORRECTAMENTE'
	END
	ELSE
	BEGIN
		PRINT 'EL ID YA EXISTE'
	END
		

END		

INSERT INTO Products VALUES (1, 'Clamp', 12.48, 'Workbench')
INSERT INTO Products VALUES (50, 'Screwdriver', 3.17, 'Flat head')
INSERT INTO Products VALUES (75, 'Tire Bar', NULL , 'Tool for changing tires')
INSERT INTO Products VALUES (3000, '3mm Brtacket', 0.52, NULL)

SELECT * FROM Products

/*Hacemos una actualizacion de la tabla, cuando el id sea = 50 */
UPDATE Products 
	SET ProductName = 'Flat Head Screwdrive'
	WHERE ProductId = 50
GO


/*Consultas equivalentes.*/
SELECT * FROM Products

SELECT p.ProductID, p.ProductName, p.Price, p.ProductDescription 
FROM Products p



/*Omitiendo columnas, seleccionando solo ProductName y Price*/
SELECT p.ProductName, p.Price 
FROM Products p

/*Añadiendo condiciones para la consulta con Where*/
SELECT * 
FROM Products p
WHERE p.ProductID > 60

/*Realizar operaciones con los valores de consultas.*/
SELECT p.ProductName, p.Price*1.07 customerPay 
FROM Products p
GO



---------------------------------------------------------
-- 2 CREATING VIEWS AND STORED PROCEDURES
---------------------------------------------------------

/*Creacion de una vista para la muestra de los nombres de los productos*/
CREATE VIEW vw_Names
AS
	SELECT P.ProductName, p.Price 
	FROM Products p
GO

SELECT * FROM vw_Names
GO

/*Procediemiento que muestra los productos de un precion predeterminado por el valor de entrada*/
CREATE PROCEDURE pr_Names @varPriece MONEY
AS
BEGIN
	PRINT 'Los productos inferiores al precio marcado' + CAST(@varPriece as varchar(10))
	SELECT vw.ProductName 
	FROM vw_Names vw
	WHERE vw.Price < @varPriece
END

/*Muestra el nombre de los productos.*/
EXEC pr_Names 9.00
GO

-------------------------------------------------------------------
-- 3 DELETING DATABASE OBJECTS
-------------------------------------------------------------------

/*Conectados a nuestra BBDD*/
USE [TestData2022]
GO

/*Eliminamos el procedimiento*/
DROP PROC pr_Names
GO

/*Eliminamos la vista*/
DROP VIEW vw_Names
GO

/*Eliminamos todos los elementos de la tabla (Sin borrar la tabla)*/
DELETE FROM Products

/*Borramos la tabla de la BBDD, con todos sus contenidos; triggers, etc incluidos*/
DROP TABLE Products

/*Borramos la bbdd*/
--Primero tenemos que ir a master para poder borrarla
USE [master]
GO
--Borramos la bbdd ¡¡NO DEJA BORRARLA!!
-- De forma manual si ha dejado
DROP DATABASE TestData2022



-------------------------------------------------------------------
-- 4 DELETING DATABASE OBJECTS
-------------------------------------------------------------------

/*Declaracion de variables para multiplicacion*/
DECLARE @result BIGINT
DECLARE @factor1 INT = 15874
DECLARE @factor2 SMALLINT = @factor1-100
SELECT @result = @factor1 * @factor2 
SELECT @result ResMUL


/*
Crear una tabla de variables, 
Para insertar en la variable tabla se inserta como en una tabla normal.
Hay que ejecutar todo el bloque
*/
DECLARE @tabla TABLE(
	f1 INT,
	f2 INT,
	ret INT
)
INSERT INTO @tabla VALUES (43, 133, 0), (230,125,0), (854, 143, 0)
SELECT t.f1, t.f2, t.ret
FROM @tabla t
WHERE f1 < 100


---------------------------------------------------------------------------
-- 5 STORED PROCEDURES WITH VARIABLES
---------------------------------------------------------------------------

/*Creamos un triger que pruebe que la insercion se puede realizar y no hay un elemento en la tabla con el mismo id*/
IF OBJECT_ID('splntMultiplier') IS NOT NULL
	DROP PROCEDURE splntMultiplier;
GO
CREATE PROCEDURE splntMultiplier (@p1 INT, @p2 INT,@r BIGINT OUTPUT)
AS
BEGIN
	IF @p1 = 0 OR @p2 = 0
		SELECT @r = 0;
	ELSE
		BEGIN TRY
			SELECT @r = @p1 * @p2
		END TRY

	BEGIN CATCH
		SELECT @r = @p1 * CAST(@p2 as BIGINT)
	END CATCH

	SELECT @r resultado
END
GO

DECLARE @result BIGINT
EXEC splntMultiplier 0, 0, @result OUTPUT
EXEC splntMultiplier 100, 300, @result OUTPUT
EXEC splntMultiplier 10000000, 30000000, @result OUTPUT


---------------------------------------------------------------------------
-- 6 USER-DEFINED FUNCTIONS
---------------------------------------------------------------------------

IF OBJECT_ID('udfMultiplyValues') IS NOT NULL
	DROP FUNCTION udfMultiplyValues
GO

/*Creamos funcion multiplicacion*/
CREATE FUNCTION udMultiplyValues (@p1 INT, @p2 INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @r BIGINT
	SET @r = @p1*@p2
	RETURN @r
END
GO

/*Ejecutamos la funcion en un Try/catch pos si alguno de los valores se pasa del INT*/
BEGIN TRY
	DECLARE @res BIGINT 
	SET @res = dbo.udMultiplyValues(1000, 300000000)
	SELECT @res retunr
END TRY
BEGIN CATCH
	DECLARE @mensajeError varchar(4000) = ERROR_MESSAGE()
	PRINT @mensajeError
END CATCH




IF OBJECT_ID('udDivValues') IS NOT NULL
	DROP FUNCTION udDivValues
GO
/*Creo funcion division*/
CREATE FUNCTION udDivValues (@p1 INT, @p2 INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @r BIGINT
	SET @r = @p1/@p2
	RETURN @r
END
GO

/*Ejecutamos la funcion division con try/catch por si Div por 0 */
BEGIN TRY
	DECLARE @res2 BIGINT 
	SET @res2 = dbo.udDivValues(1000, 0)
	SELECT @res2 retunr
END TRY
BEGIN CATCH
		DECLARE @mensajeError varchar(4000) = ERROR_MESSAGE()
		PRINT @mensajeError
END CATCH
GO

---------------------------------------------------------------------------
-- 7 AGGREGATION FUNCTIONS
---------------------------------------------------------------------------

USE [AdventureWorks2017]
GO

SELECT * FROM Sales.SalesOrderHeader

/*a) Contamos las filas que tiene la tabla*/
SELECT COUNT(*) 
FROM Sales.SalesOrderHeader

/*b) El valor maximo de la columna TotalDue*/
SELECT MAX(a.TotalDue) 
FROM Sales.SalesOrderHeader a

/*c) La media de la columna Freidht */
SELECT AVG(a.Freight) 
FROM Sales.SalesOrderHeader a

/*d) Los distintos clientes de la tabla*/
SELECT COUNT(DISTINCT a.CustomerID) 
FROM Sales.SalesOrderHeader a

/*e) Total de la columna totalDue en noviembre de 2012 (solo hay del 2011-2014 )*/
select  MIN(YEAR(a.OrderDate)), MAX(YEAR(a.OrderDate))
FROM Sales.SalesOrderHeader a

SELECT SUM(a.TotalDue)
FROM Sales.SalesOrderHeader a
WHERE MONTH(OrderDate)=11 AND YEAR(OrderDate) = 2012


/*Query para seleccionar las "SalesOrderNumber" con mayor "totalDue" de la tabla */
--SELECT * FROM Sales.SalesOrderHeader
--SELECT * FROM Sales.SalesTerritory
SELECT a.SalesOrderNumber 
FROM Sales.SalesOrderHeader a
WHERE a.TotalDue IN (SELECT MAX(a.TotalDue) FROM Sales.SalesOrderHeader a)
GO

/*Combinacion de tablas SalesOrderHeader con SalesTerritory por la columna TerritoryID*/
SELECT SUM(a.TotalDue), b.TerritoryID
FROM Sales.SalesOrderHeader a
INNER JOIN Sales.SalesTerritory b
ON a.TerritoryID = b.TerritoryID
WHERE b.[Group] = 'Europe'
GROUP BY b.TerritoryID
GO

/*Combinacion de tablas mediante el uso de GROUPIN SETS (OJO A GROUP -> Palabra reservada)*/
SELECT SUM(a.TotalDue), b.CountryRegionCode 
FROM Sales.SalesOrderHeader a
INNER JOIN Sales.SalesTerritory b
ON a.TerritoryID = b.TerritoryID
WHERE b.[Group] = 'Europe'
GROUP BY GROUPING SETS((b.[Group], b.CountryRegionCode), ())
GO

SELECT * FROM Sales.SalesTerritory
GO

---------------------------------------------------------------------------
-- 8 USING JOINS AND PIVOTS
---------------------------------------------------------------------------

WITH t AS (
	SELECT  c.[Name] [Name], ReasonType ReasonType, TotalDue TotalDue
	FROM Sales.SalesOrderHeader as a
	INNER JOIN Sales.SalesOrderHeaderSalesReason as b
	ON a.SalesOrderID = b.SalesOrderID
	INNER JOIN Sales.SalesReason as c
	ON b.SalesReasonID = c.SalesReasonID
)
SELECT [NAME], Marketing, Other, Promotion FROM t
PIVOT (SUM(TotalDue) FOR ReasonType IN (Marketing, Other, Promotion)) As P
GO

---------------------------------------------------------------------------
-- 9 TRIGGERS
---------------------------------------------------------------------------

IF OBJECT_ID('Sales.SalesReasonHistory') IS NOT NULL
	DROP TABLE Sales.SalesReasonHistory
GO

/*Creamos la tabla en la rama "Sales"*/
CREATE TABLE Sales.SalesReasonHistory (
	SalesReasonID INT NOT NULL,
	[Name] dbo.Name NOT NULL,
	ReasonType dbo.Name NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	ValidFrom DATETIME
)
GO

--Creacion de tabla y eliminacion de constraints
-----------------------------------------------------------------
/*
SELECT * INTO Sales.SalesReasonHistory 
	FROM Sales.SalesReason
GO
*/
/*Aseguramos que se a creado la tabla correctamente. (Otra forma de copiar tablas) */
select * FROM Sales.SalesReasonHistory

--DELETE FROM Sales.SalesReasonHistory
--DROP TABLE Sales.SalesReasonHistory


/*Buscamos informacion de las posibles constraints, ()*/
select * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_NAME = 'SalesReason'

select * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_NAME = 'SalesReasonHistory'

/*
ALTER TABLE Sales.SalesReasonHistory
ADD PRIMARY KEY (SalesReasonID)

ALTER TABLE Sales.SalesReasonHistory
DROP CONSTRAINT PK__SalesRea__9546D09BACCFD1D8
*/
--------------------------------------------------------------------

/*Creamos un triger*/
IF OBJECT_ID('TriggerLogSalesReason', 'TR') IS NOT NULL
	DROP TRIGGER TriggerLogSalesReason;
GO

CREATE TRIGGER TriggerLogSalesReason ON Sales.SalesReason
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO Sales.SalesReasonHistory
	SELECT ins.SalesReasonID, ins.[Name], ins.ReasonType, ins.ModifiedDate, GETDATE()
	FROM inserted ins

	SELECT dl.SalesReasonID, dl.[Name], dl.ReasonType, dl.ModifiedDate, '99991231'
	FROM deleted dl
END