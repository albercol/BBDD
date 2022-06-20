-------------------------------------------------------------------------------------------------------------
-- EJEMPLOS:
-------------------------------------------------------------------------------------------------------------


/*Cremaos la tabla producto*/
CREATE TABLE Products (
	ProductId int PRIMARY KEY,
	ProductName varchar(25) NOT NULL,
	Price money NULL,
	ProductDescription text NULL
)

/*Insertamos los productos en la tabla creada anteriormente*/
INSERT Products (ProductId, ProductName, Price, ProductDescription) 
	VALUES (1, 'Clamp', 12.48, 'workbench clamp.')
INSERT Products (ProductId, ProductName, Price, ProductDescription)
	VALUES (50, 'Screwdrivers', 3.17, 'Flat head')
INSERT Products (ProductId, ProductName, Price, ProductDescription)
	VALUES (75, 'Tire Bar', NULL, 'Tool for changin tires.')
INSERT Products (ProductId, ProductName, Price)
	VALUES (3000, '3mm Brtacket', 0.52)

/*Actualizamos producto de la tabla*/
UPDATE Products
	SET ProductName = 'Flat Head Screwdrive'
	WHERE ProductId = 50
GO

/*Creamos una vista (Se trata como una tabla)*/
CREATE VIEW vw_Names 
	AS 
	SELECT ProductName, Price FROM Products;
GO

/*Hacemos una vista de la nueva tabla creada*/
SELECT *
	FROM vw_Names;
GO

/*Creamos un procedimiento "Funcion" (@VarPrice es el elemento de entrada.) */
CREATE PROCEDURE pr_Names @VarPrice money
	AS
	BEGIN
		-- Muestra texto para el usuario.
		PRINT 'Products less than' + CAST(@VarPrice AS varchar(10));
		--Despues muestra los productos menores de ese precio.
		SELECT ProductName, Price
		FROM vw_Names
		WHERE Price < @VarPrice;
	END
GO 

/*Ejecutamos el procedimiento*/
EXECUTE pr_Names 10.00;

/*Eliminamos la vista*/
DROP View vw_Names;
GO


IF OBJECT_ID('insertLessthan_Prices') IS NOT NULL
DROP PROCEDURE insertLessthan_Prices
GO

/*Insertar elemento en la tabla cuando cumpla una condicion*/
CREATE PROCEDURE insertLessthan_Prices (@VarPrice money, @id varchar(30), @nom varchar(30))
	AS
	BEGIN
		-- Muestra texto para el usuario.
		PRINT 'Products less than' + CAST(@VarPrice AS varchar(10));
		--SI EL PRECIO ES MENOR QUE 10 lo muestra
		IF @VarPrice < 10.00
			INSERT Products (ProductId, ProductName, Price) VALUES (@id, @nom, @VarPrice);
		ELSE 
			PRINT 'No se inserto el producto'
			SELECT ProductName, Price
				FROM Products
		
		
	END
GO

EXECUTE insertLessthan_Prices 9.00, 27, 'Pen'; /*Duda: Los print no lo hace*/

/*Elimina el objeto procedure*/
DROP PROC insertLessthan_Prices;


DELETE Products
	WHERE ProductName = 'Pen'

SELECT ProductName, Price
		FROM Products

SELECT *
		FROM Products

UPDATE Products
	SET ProductDescription = 'Tool to write'
	WHERE ProductId = 27



---------------------------------------------------------------------------------------------
--CREAMOS PROCEDIEMIENTO
---------------------------------------------------------------------------------------------

/*Primero eliminamos cualquier procedimiento que pueda quedar.*/
IF OBJECT_ID('splntMultiplier') IS NOT NULL
DROP PROCEDURE splntMultiplier
GO

/*Creamos el procedimiento con la variable ret de salida.*/
CREATE PROCEDURE splntMultiplier (@p1 INT, @p2 INT, @ret BIGINT OUTPUT)
AS
BEGIN

	/*Primero comprobamos que ninguno de los datos de entrada sea 0*/
	IF (@p1 = 0 OR @p2 = 0)
		BEGIN
			SELECT @ret = 0;
		END
	ELSE
		BEGIN TRY
			SELECT @ret = @p1 * @p2;
		END TRY
 BEGIN CATCH
	SELECT @ret = @p1 * CONVERT(BIGINT, @p2);
 END CATCH
 SELECT @ret


END
GO

/*La variable result solo funciona al ejecutar el bloque entero*/
DECLARE @result BIGINT;
EXECUTE splntMultiplier 0, 0, @result OUTPUT;
EXECUTE splntMultiplier 100, 300, @result OUTPUT;
EXECUTE splntMultiplier 10000000, 30000000, @result OUTPUT;



----------------------------------------------------------------------------------
--CREACION DE FUNCION
----------------------------------------------------------------------------------
/*Eliminamos cualquier funcion con el mismo nombre que se haya podido crear.*/
IF OBJECT_ID('udfMultiplyValues') IS NOT NULL
DROP FUNCTION udfMultiplyValues;
GO

CREATE FUNCTION udfMultiplyValues (@p1 INT, @p2 INT)
RETURNS BIGINT
	AS
	BEGIN
		DECLARE @return AS BIGINT
		SET @return = @p1 * @p2;
		RETURN @return
	END

GO

/*Ojo!! añadir dbo.nombrefuncion(Datos de entrada)*/
SELECT dbo.udfMultiplyValues (100, 200);
GO



-----------------------------------------------------------------------------------------------------
--CREAR PROCEDIMIENTO
-----------------------------------------------------------------------------------------------------
/*Eliminamos cualquier procedimiento con el mismo nombre que se haya podido crear.*/
IF OBJECT_ID('udfMultiplyValues') IS NOT NULL
DROP PROCEDURE count100;
GO

CREATE PROCEDURE count100 (@i int)
AS
BEGIN
	PRINT 'Cuenta hasta 100 desde ' + CAST(@i AS varchar(3));
	DECLARE @count AS int = 0
	WHILE @count < 100
	BEGIN
		SET @count +=1;
		PRINT CAST(@i AS varchar(3));
		set @i +=1;
	END
	PRINT 'Fin';
END
GO

EXECUTE count100 0;
GO


CREATE TABLE cursos (
	CourseId varchar(30) NOT NULL,
	YearStart int,
	Earning bigint
)

--DROP TABLE cursos;

INSERT cursos VALUES ('.NET', 2012, 10000)
INSERT cursos VALUES ('.Java', 2012, 20000)
INSERT cursos VALUES ('.NET', 2012, 5000)
INSERT cursos VALUES ('.NET', 2013, 48000)
INSERT cursos VALUES ('.Java', 2013, 30000)

SELECT * FROM cursos
PIVOT(SUM(Earning)
FOR YearStart IN ([2012], [2013]))
AS PVTTable
GO


DECLARE @var1 VARCHAR(50),
		@var2 INT 



