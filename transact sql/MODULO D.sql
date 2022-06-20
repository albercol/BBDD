-------------------------------------------------------------------------------------------------------------
--MODULO D
-------------------------------------------------------------------------------------------------------------
 /*TRIGGER*/
DROP TABLE customer

CREATE TABLE customer (
	number BIGINT PRIMARY KEY identity(1,1),
	names NVARCHAR(50) NOT NULL,
	area NVARCHAR(4) NOT NULL, 
	region NVARCHAR(10) NOT NULL,
	revenue INT,
	orders INT
)
GO

/*Dispata la funcion TRIGGER despues (AFTER) de insertar actualizar o eliminar una fila.  */
CREATE TRIGGER triggerCustomerDML ON customer
AFTER INSERT, UPDATE, DELETE
AS
	BEGIN
		PRINT 'Ha sucedido un evento en la tabla customer'
		RETURN
	END
GO

INSERT INTO customer VALUES ('Sample company 2', 'APAC', 'Singapore', 200000, 40)
INSERT INTO customer VALUES ('Sample company 3', 'APAC', 'Australia', 430000, 30)
INSERT INTO customer VALUES ('US Company', 'NA', 'US', 120000, 30)
INSERT INTO customer VALUES ('European Company', 'EALA', 'France', 62000, 20)
INSERT INTO customer VALUES ('European Company 2','EALA', 'Spain', 150000, 40)
INSERT INTO customer VALUES ('European Company 3', 'EALA', 'Spain', 700000, 40)
GO



CREATE TRIGGER ejemploInsercion ON customer
AFTER INSERT 
AS
BEGIN
	DECLARE @nomVar varchar(50)
	SELECT @nomVar = INSERTED.names FROM inserted
	PRINT ('EL nombre de la empresa es: ' + @nomVar)
END

INSERT INTO customer VALUES ('Sample company 2', 'APAC', 'SPAIN',2, 2)



DELETE FROM customer
WHERE number = 7

SELECT * FROM customer

SELECT *
FROM information_schema.tables
WHERE table_type='base table'

SELECT name, recovery_model_desc
FROM sys.databases
GO

SELECT *
FROM information_schema.tables
--WHERE table_type='view'
GO 


CREATE TRIGGER triggerInsteadCustomer ON customer
INSTEAD OF INSERT
AS 
	BEGIN
		--Declaramos una variable de control.
		DECLARE @idCompany int

		--Realizamos una consulta.
		SELECT @idCompany = cust.number
		FROM customer cust
		INNER JOIN INSERTED inst
		ON inst.number = cust.number
		
		if(@idCompany is NULL)
			BEGIN 
				RAISERROR('Error en la insercion',15600,-1,-1)				
				RETURN
			END
		
		INSERT INTO customer values (8,'prueba', 'PRU', 'PORT', 2, 45)

	END
GO

--DROP TRIGGER [dbo].triggerCustomerDMLINTEADOF
--GO

/* Solo se puede crear un trigger de cada tipo. */
CREATE TRIGGER triggerCustomerINSTEADOF ON customer
AFTER INSERT, UPDATE, DELETE
AS
	BEGIN
		DECLARE @nameVar VARCHAR(30)
		DECLARE @num int
		SELECT @nameVar=names FROM INSERTED 
		SELECT COUNT(*) FROM customer
		WHERE names = @nameVar 

		IF(@num > 0)
			BEGIN
				PRINT 'No ha pasado nada de Na!'
				RETURN
			END
		ELSE 
			BEGIN
				INSERT INTO customer VALUES ('Nuevo Nombre jojo', 'PRU', 'PORT', 2, 45)
				PRINT 'Insertado con exito!'
			END
	END
