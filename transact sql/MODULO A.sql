-----------------------------------------------------------------------------------------------------------------
--MODULO A
-----------------------------------------------------------------------------------------------------------------

CREATE TABLE employee(
	employeeId int PRIMARY KEY identity(1,1)
	, employeeName varchar(30)
)

CREATE TABLE addressEmployee (
	id int PRIMARY KEY identity(1,1)
	,employeeId int FOREIGN KEY REFERENCES employee(employeeId) /* Para crear una foreing key*/
	,direccion varchar(30)
	,pais VARCHAR(30)
)

CREATE TABLE employee2(
	Nombre varchar(30),
	Apellido1 varchar(30),
	Apellido2 varchar(30),
	ubicacion varchar (30),
	primary key (nombre, apellido1, apellido2)
)
select *
from employee2

DBCC CHECKIDENT ('addressEmployee', RESEED, 0);  /* Si se define en 0 la semilla, empezara en 1 */
DBCC CHECKIDENT ('employee', RESEED, 0);

DELETE FROM addressEmployee
WHERE id = 1

INSERT INTO employee (employeeName) values ('Fer')
INSERT INTO employee (employeeName) values ('Alicia')
INSERT INTO employee (employeeName) values ('Perico')
INSERT INTO employee (employeeName) values ('Chen')
INSERT INTO addressEmployee (employeeId, direccion, pais) values (1, 'Calle', 'España')
INSERT INTO addressEmployee (employeeId, direccion, pais) values (2, 'Calle', 'peñalara')
INSERT INTO addressEmployee (employeeId, direccion, pais) values (3, 'Av', 'Perico Delgado')
INSERT INTO addressEmployee (employeeId, direccion, pais) values (4, 'Calle', 'Santa Engracia')


SELECT *
FROM employee

SELECT *
FROM addressEmployee


--DELETE FROM addressEmployee
--DELETE FROM employee


--DROP TABLE employee2;
--DROP TABLE addressEmployee;
--DROP TABLE employee;
--GO

/*Este ejemplo esta "Mal" porque no estas creando una tabla al uso, estas consultando dos tablas*/
SELECT emp.employeeName, addr.pais
FROM employee emp, addressEmployee addr
WHERE emp.employeeId = addr.id
GO

/*Para modificarlo Añadir el ALTER*/
CREATE VIEW direccionEmpleado
AS
	SELECT emp.EmployeeName, addr.pais
	FROM employee emp inner join addressEmployee addr 
	ON emp.employeeid = addr.employeeid
GO

select *
FROM direccionEmpleado


/*LEFT JOIN, se juntan las dos tablas (a la de la izquierda)*/
SELECT emp.EmployeeName, addr.pais
FROM employee emp
LEFT JOIN addressEmployee addr ON
emp.employeeid = addr.employeeid
WHERE addr.pais IS NOT NULL 


/*
INNER JOIN
LEFT JOIN
RIGTH JOIN
*/

SELECT emp.employeeId, addr.pais
FROM employee emp INNER JOIN addressEmployee addr
ON emp.employeeId = addr.employeeId