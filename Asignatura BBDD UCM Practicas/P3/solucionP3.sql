/*Alberto Collado Mamblona
  Beatriz Villegas Sánchez
*/

/*1. Listado de departamentos (con toda la información disponible) de los departamentos cuya localización sea 1500.*/
SELECT * 
FROM pr3_departments
WHERE location_id = 1500;

/*2. Listado con los nombres de los empleados que trabajan en el departamento cuyo identificador es 100.*/
SELECT first_name, last_name 
FROM pr3_employees
WHERE department_id = 100;

/*3. Listado con los nombres de los empleados que no tienen jefe.*/
SELECT first_name, last_name 
FROM pr3_employees
WHERE manager_id  IS NULL;

/*4. Listado con los identificadores de departamento de aquellos empleados que reciben algún tipo de comisión. Sin repetición.*/
SELECT distinct pr3_employees.department_id 
FROM pr3_employees , pr3_departments 
WHERE commission_pct IS NOT NULL;

/*5. Listado con los nombres de los empleados (ordenados por apellido) que trabajan en el departamento Finance.*/
SELECT pr3_employees.first_name , pr3_employees.last_name  
FROM pr3_employees, pr3_departments
WHERE pr3_departments.department_name = 'Finance'
ORDER BY pr3_employees.last_name ASC;

/*6. Nombres de los empleados que tienen personal a su cargo, es decir, que son jefes de algún empleado. Sin repetición.*/
SELECT distinct emp.first_name , emp.last_name /*MIRAR*/
FROM pr3_employees emp , pr3_departments
WHERE emp.manager_id IS NOT NULL and emp.manager_id = pr3_departments.manager_id;

/*7. Listado de los apellidos de los empleados que ganan más que su jefe, incluyendo también el apellido de su jefe y los salarios de ambos.*/
SELECT emp.last_name, emp.salary , jefe.last_name, jefe.salary  
FROM  pr3_employees jefe, pr3_departments dept, pr3_employees emp
WHERE jefe.employee_id = dept.manager_id AND emp.employee_id = jefe.manager_id AND emp.salary > jefe.salary;

/*8. Listado con los nombres de los empleados que han trabajado en el departamento Sales.*/
SELECT emp.first_name , emp.last_name
FROM pr3_job_history history, pr3_departments dept, pr3_employees emp , 
WHERE dept.department_name = 'Sales' AND history.department_id = dept.department_id;

/*9. Nombres de los puestos que desempeñan los empleados en el departamento IT, sin tuplas repetidas.*/
/*10. Listado con los nombres de los empleados que trabajan en el departamento IT que no trabajan en Europa, junto con el nombre del país en el que trabajan.*/
/*11. Listado de los apellidos de los empleados del departamento SALES que no trabajan en el mismo departamento que su jefe, junto con el apellido de su jefe y el departamento en el que trabaja el jefe.*/
/*12. Listado con los nombres de los empleados que han trabajado en el departamento IT, pero que actualmente trabajan en otro departamento distinto.*/

