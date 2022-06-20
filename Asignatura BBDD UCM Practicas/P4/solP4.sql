/*Alberto Collado Mambloa
  Beatriz Villegas Sánchez
*/

/*1. Listado con el nombre y apellido de los empleados que trabajan en el departamento Finance. Ordenados por apellido.*/
SELECT emp.first_name, emp.last_name
FROM pr3_employees emp JOIN pr3_departments dept ON emp.department_id = dept.department_id 
WHERE dept.department_name = 'Finance'
ORDER BY emp.last_name ASC;

/*2. Nombre y apellido de los empleados que tienen personal a su cargo, es decir, que son jefes de algún empleado. Sin repetición.*/
SELECT distinct emp.first_name , emp.last_name 
FROM pr3_employees emp JOIN pr3_employees jefe ON emp.employee_id = jefe.manager_id;


/*3. Listado de los apellidos de los empleados que ganan más que su jefe, incluyendo también 
     el apellido de su jefe y los salarios de ambos.*/
SELECT emp.last_name , emp.salary, jefe.last_name, jefe.salary
FROM pr3_employees emp JOIN pr3_employees jefe ON emp.employee_id = jefe.manager_id
WHERE emp.salary > jefe.salary;

/*4. Listado con el nombre y apellido de los empleados que han trabajado en el departamento
Sales.*/
SELECT emp.first_name, emp.last_name
FROM pr3_employees emp JOIN pr3_job_history hist ON hist.employee_id = emp.employee_id
     JOIN pr3_departments dept ON dept.department_id = emp.department_id
WHERE dept.department_name = 'Sales';

/*5. Nombres de los puestos que desempeñan los empleados en el departamento IT, sin tuplas
repetidas.*/
SELECT distinct jobs.job_title
FROM pr3_departments dept JOIN pr3_employees emp on dept.department_id = emp.department_id
    JOIN pr3_jobs jobs ON jobs.job_id = emp.job_id
WHERE dept.department_name = 'IT';

/*6. Listado con los nombres de los empleados que trabajan en cualquier departamento cuyo
nombre contenga una e que no trabajan en Europa, junto con el nombre del departamento y
del país en el que trabajan.*/
SELECT  emp.first_name, dept.department_name, country.country_name
FROM ((pr3_employees emp JOIN pr3_departments dept ON emp.department_id = dept.department_id)
    JOIN pr3_jobs jobs ON jobs.job_id = emp.job_id) JOIN pr3_locations loc ON loc.location_id = dept.location_id
    JOIN pr3_countries country ON country.country_id = loc.country_id JOIN pr3_regions reg ON country.region_id = reg.region_id
WHERE dept.department_name LIKE '%e%' AND reg.region_name NOT LIKE 'Europe';

/*7. Listado de las localizaciones de los departamentos de la empresa (identificador del país,
ciudad, identificador de la localización y nombre del departamento) en la que se encuentra
algún departamento de UK, incluyendo aquellas localizaciones de UK en las que no hay
departamento. El listado debe estar ordenado por ciudad.*/
SELECT country.country_id, loc.city, loc.location_id, dept.department_name
FROM pr3_countries country JOIN pr3_locations loc ON country.country_id = loc.country_id 
   LEFT JOIN pr3_departments dept ON loc.location_id = dept.location_id
WHERE  country.country_id = 'UK'
ORDER BY loc.city ASC;

/*8. Nombre de todos los países que no tengan ninguna localización, ordenados alfabéticamente
en orden descendente.*/
SELECT country.country_name
FROM pr3_countries country LEFT JOIN pr3_locations loc ON country.country_id = loc.location_id
WHERE loc.location_id IS NULL;
ORDER BY country.country_name DESC;

/*9. Nombre, apellidos y departamento de los empleados sin departamento (el departamento
aparecerá vacío) y de los departamentos sin empleados (el nombre y apellidos aparecerán
vacíos).*/
SELECT emp.first_name, emp.last_name, dept.department_name
FROM pr3_employees emp FULL JOIN pr3_departments dept ON emp.department_id = dept.department_id
WHERE emp.department_id IS NULL;