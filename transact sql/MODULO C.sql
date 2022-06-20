-------------------------------------------------------------------------------------------------------------
-- MODULO C
-------------------------------------------------------------------------------------------------------------

DROP TABLE customer

CREATE TABLE customer(
	number BIGINT NOT NULL,
	names NVARCHAR(50) NOT NULL,
	area NVARCHAR(4) NOT NULL,
	revenue INT
)

INSERT INTO customer VALUES (5678, 'Sample Company 2', 'APAC', 200000)
INSERT INTO customer VALUES (5679, 'Sample Company 3', 'APAC', 430000)
INSERT INTO customer VALUES (5680, 'US Company', 'NA', 120000)
INSERT INTO customer VALUES (5681, 'European Company ', 'EALA', 62000)
INSERT INTO customer VALUES (5682, 'European Company 2', 'EALA', 150000)
INSERT INTO customer VALUES (5683, 'European Company 3', 'EALA', 700000)


/*Muestra la columna number, names, area y revenue ordenada de forma de forma descendente por revenue*/
SELECT number, names, area, revenue FROM customer
ORDER BY revenue desc

/*Muestra las columnas number, names, area, revenue ordenadas de forma ascendente por revenue */
SELECT number, names, area, revenue FROM customer
ORDER BY revenue

/*Muestra las columnas number, names, area ordenadas por nombres*/
SELECT number, names, area FROM customer
ORDER BY names

/*Muestra la agrupacion de area con la cuenta de todas las areas*/
SELECT area, COUNT(*) AS cuenta FROM customer
GROUP BY area
ORDER BY cuenta desc

/*Muestra la suma de las revenue de la tabla customer en cada area*/
SELECT area, SUM(revenue) AS suma_revenue FROM customer
GROUP BY area
ORDER BY suma_revenue desc

/*Muestra la media suma de todos APAC y hace la division por todos los APAC*/
SELECT area, AVG(revenue) AS revenue_avg FROM customer
GROUP BY area

/*Muestra el MIN de la agrupacion*/
SELECT area, MIN(revenue) as revenue_min FROM customer
GROUP BY area
ORDER BY revenue_min desc

SELECT area, MAX(revenue) as revenue_min FROM customer
GROUP BY area
ORDER BY revenue_min



DROP TABLE customer

CREATE TABLE customer (
	number BIGINT PRIMARY KEY IDENTITY(1,1),
	names NVARCHAR(50) NOT NULL,
	area NVARCHAR(4) NOT NULL, 
	region NVARCHAR(10) NOT NULL,
	revenue INT
)

INSERT INTO customer VALUES ('Sample company 2', 'APAC', 'Singapore', 200000)
INSERT INTO customer VALUES ('Sample company 3', 'APAC', 'Australia', 430000)
INSERT INTO customer VALUES ('US Company', 'NA', 'US', 120000)
INSERT INTO customer VALUES ('European Company', 'EALA', 'France', 62000)
INSERT INTO customer VALUES ('European Company 2','EALA', 'Spain', 150000)
INSERT INTO customer VALUES ('European Company 3', 'EALA', 'Spain', 700000)

SELECT area, region, SUM(revenue) AS sum_revenue FROM customer
GROUP BY GROUPING SETS(area, region)

/*DUDA*/
/*
SELECT area, region, SUM(revenue) AS sum_revenue FROM customer
GROUP BY area
UNION ALL
SELECT area, region, SUM(revenue) AS sum_revenue FROM customer
GROUP BY region
*/

/*CUBE*/
SELECT area, region, SUM(revenue) AS sum_revenue FROM customer
GROUP BY CUBE (area, region)
ORDER BY area, region

/*Es equivalanete a: */

/*
() -> Los nulos
area -> Solo columna area
Region -> Solo columna region
(Area, region) -> Ambos 
*/
SELECT area, region, SUM(revenue) AS sum_revenue FROM customer
GROUP BY GROUPING SETS((),area, region, (area, region)) 
ORDER BY area

SELECT area, region, SUM(revenue) AS sum_revenue FROM customer
GROUP BY GROUPING SETS((),area, region, (area, region)) HAVING area = 'EALA'
ORDER BY sum_revenue

/*PIVOT*/
SELECT region, APAC, Nan, EALA FROM (SELECT area, region, revenue FROM customer) AS rawData
PIVOT (SUM(revenue) FOR area IN (APAC, Nan, EALA)) AS pivotRules
ORDER BY APAC, EALA desc
GO

SELECT region
FROM customer
GROUP by region
GO

/*Pivot por region*/
with t as 
(
SELECT area, Australia, france, Spain, US FROM (SELECT region, area, revenue FROM customer ) as rawData
PIVOT (SUM(revenue) FOR region IN (Australia, france, Spain, US)) AS pivotTable 
)
select area, region, revenue From t
UNPIVOT (revenue FOR region in (Australia, france, spain)) as unpvt




/*ROW NUMBER*/
SELECT *
FROM customer
GO

SELECT cus.number, cus.revenue , ROW_NUMBER() over (ORDER by cus.revenue) AS r 
FROM customer cus

/*Ordena por revenue dentro de area.*/
SELECT cus.number, cus.revenue, cus.area, ROW_NUMBER() OVER (PARTITION BY area ORDER BY revenue) AS r
FROM customer cus

SELECT cus.number, cus.revenue, cus.area, DENSE_RANK() OVER (ORDER BY revenue) AS r
FROM customer cus

SELECT cus.number, cus.revenue, cus.area, NTILE(3) OVER (ORDER BY revenue) AS r
FROM customer cus