Rem
Rem $Header: hr_cre.sql 03-mar-2001.10:05:13 ahunold Exp $
Rem
Rem hr_cre.sql
Rem
Rem  Copyright (c) Oracle Corporation 2001. All Rights Reserved.
Rem
Rem    NAME
Rem      hr_cre.sql - Create data objects for HR schema
Rem
Rem    DESCRIPTION
Rem      This script creates six tables, associated constraints
Rem      and indexes in the human resources (HR) schema.
Rem
Rem    NOTES
Rem
Rem    CREATED by Nancy Greenberg, Nagavalli Pataballa - 06/01/00
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    ahunold     09/14/00 - Added emp_details_view
Rem    ahunold     02/20/01 - New header
Rem    vpatabal	 03/02/01 - Added regions table, modified regions
Rem			            column in countries table to NUMBER.
Rem			            Added foreign key from countries table
Rem			            to regions table on region_id.
Rem		                    Removed currency name, currency symbol 
Rem			            columns from the countries table.
Rem		      	            Removed dn columns from employees and
Rem			            departments tables.
Rem			            Added sequences.	
Rem			            Removed not null constraint from 
Rem 			            salary column of the employees table.

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

REM ********************************************************************
REM Create the REGIONS table to hold region information for locations
REM HR.LOCATIONS table has a foreign key to this table.

Prompt ******  Creating REGIONS table ....

CREATE TABLE pr3_regions
    ( region_id      NUMBER 
       CONSTRAINT  pr3_region_id_nn NOT NULL 
    , region_name    VARCHAR2(25) 
    );

CREATE UNIQUE INDEX pr3_reg_id_pk
ON pr3_regions (region_id);

ALTER TABLE pr3_regions
ADD ( CONSTRAINT pr3_reg_id_pk
       		 PRIMARY KEY (region_id)
    ) ;

REM ********************************************************************
REM Create the COUNTRIES table to hold country information for customers
REM and company locations. 
REM OE.CUSTOMERS table and HR.LOCATIONS have a foreign key to this table.

Prompt ******  Creating COUNTRIES table ....

CREATE TABLE pr3_countries 
    ( country_id      CHAR(2) 
       CONSTRAINT  pr3_country_id_nn NOT NULL 
    , country_name    VARCHAR2(40) 
    , region_id       NUMBER 
    , CONSTRAINT     pr3_country_c_id_pk 
        	     PRIMARY KEY (country_id) 
    ) 
    ORGANIZATION INDEX; 

ALTER TABLE pr3_countries
ADD ( CONSTRAINT pr3_countr_reg_fk
        	 FOREIGN KEY (region_id)
          	  REFERENCES pr3_regions(region_id) 
    ) ;

REM ********************************************************************
REM Create the LOCATIONS table to hold address information for company departments.
REM HR.DEPARTMENTS has a foreign key to this table.

Prompt ******  Creating LOCATIONS table ....

CREATE TABLE pr3_locations
    ( location_id    NUMBER(4)
    , street_address VARCHAR2(40)
    , postal_code    VARCHAR2(12)
    , city       VARCHAR2(30)
	CONSTRAINT     pr3_loc_city_nn  NOT NULL
    , state_province VARCHAR2(25)
    , country_id     CHAR(2)
    ) ;

CREATE UNIQUE INDEX pr3_loc_id_pk
ON pr3_locations (location_id) ;

ALTER TABLE pr3_locations
ADD ( CONSTRAINT pr3_loc_id_pk
       		 PRIMARY KEY (location_id)
    , CONSTRAINT pr3_loc_c_id_fk
       		 FOREIGN KEY (country_id)
        	  REFERENCES pr3_countries(country_id) 
    ) ;

Rem 	Useful for any subsequent addition of rows to locations table
Rem 	Starts with 3300

CREATE SEQUENCE pr3_locations_seq
 START WITH     3300
 INCREMENT BY   100
 MAXVALUE       9900
 NOCACHE
 NOCYCLE;

REM ********************************************************************
REM Create the DEPARTMENTS table to hold company department information.
REM HR.EMPLOYEES and HR.JOB_HISTORY have a foreign key to this table.

Prompt ******  Creating DEPARTMENTS table ....

CREATE TABLE pr3_departments
    ( department_id    NUMBER(4)
    , department_name  VARCHAR2(30)
	CONSTRAINT  pr3_dept_name_nn  NOT NULL
    , manager_id       NUMBER(6)
    , location_id      NUMBER(4)
    ) ;

CREATE UNIQUE INDEX pr3_dept_id_pk
ON pr3_departments (department_id) ;

ALTER TABLE pr3_departments
ADD ( CONSTRAINT pr3_dept_id_pk
       		 PRIMARY KEY (department_id)
    , CONSTRAINT pr3_dept_loc_fk
       		 FOREIGN KEY (location_id)
        	  REFERENCES pr3_locations (location_id)
     ) ;

Rem 	Useful for any subsequent addition of rows to departments table
Rem 	Starts with 280 

CREATE SEQUENCE pr3_departments_seq
 START WITH     280
 INCREMENT BY   10
 MAXVALUE       9990
 NOCACHE
 NOCYCLE;

REM ********************************************************************
REM Create the JOBS table to hold the different names of job roles within the company.
REM HR.EMPLOYEES has a foreign key to this table.

Prompt ******  Creating JOBS table ....

CREATE TABLE pr3_jobs
    ( job_id         VARCHAR2(10)
    , job_title      VARCHAR2(35)
	CONSTRAINT     pr3_job_title_nn  NOT NULL
    , min_salary     NUMBER(6)
    , max_salary     NUMBER(6)
    ) ;

CREATE UNIQUE INDEX pr3_job_id_pk 
ON pr3_jobs (job_id) ;

ALTER TABLE pr3_jobs
ADD ( CONSTRAINT pr3_job_id_pk
      		 PRIMARY KEY(job_id)
    ) ;

REM ********************************************************************
REM Create the EMPLOYEES table to hold the employee personnel 
REM information for the company.
REM HR.EMPLOYEES has a self referencing foreign key to this table.

Prompt ******  Creating EMPLOYEES table ....

CREATE TABLE pr3_employees
    ( employee_id    NUMBER(6)
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25)
	 CONSTRAINT     pr3_emp_last_name_nn  NOT NULL
    , email          VARCHAR2(25)
	CONSTRAINT     pr3_emp_email_nn  NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE
	CONSTRAINT     pr3_emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR2(10)
	CONSTRAINT     pr3_emp_job_nn  NOT NULL
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6)
    , department_id  NUMBER(4)
    , CONSTRAINT     pr3_emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     pr3_emp_email_uk
                     UNIQUE (email)
    ) ;

CREATE UNIQUE INDEX pr3_emp_emp_id_pk
ON pr3_employees (employee_id) ;


ALTER TABLE pr3_employees
ADD ( CONSTRAINT     pr3_emp_emp_id_pk
                     PRIMARY KEY (employee_id)
    , CONSTRAINT     pr3_emp_dept_fk
                     FOREIGN KEY (department_id)
                      REFERENCES pr3_departments
    , CONSTRAINT     pr3_emp_job_fk
                     FOREIGN KEY (job_id)
                      REFERENCES pr3_jobs (job_id)
    , CONSTRAINT     pr3_emp_manager_fk
                     FOREIGN KEY (manager_id)
                      REFERENCES pr3_employees
    ) ;

ALTER TABLE pr3_departments
ADD ( CONSTRAINT pr3_dept_mgr_fk
      		 FOREIGN KEY (manager_id)
      		  REFERENCES pr3_employees (employee_id)
    ) ;


Rem 	Useful for any subsequent addition of rows to employees table
Rem 	Starts with 207 


CREATE SEQUENCE pr3_employees_seq
 START WITH     207
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

REM ********************************************************************
REM Create the JOB_HISTORY table to hold the history of jobs that 
REM employees have held in the past.
REM HR.JOBS, HR_DEPARTMENTS, and HR.EMPLOYEES have a foreign key to this table.

Prompt ******  Creating JOB_HISTORY table ....

CREATE TABLE pr3_job_history
    ( employee_id   NUMBER(6)
	 CONSTRAINT    pr3_jhist_employee_nn  NOT NULL
    , start_date    DATE
	CONSTRAINT    pr3_jhist_start_date_nn  NOT NULL
    , end_date      DATE
	CONSTRAINT    pr3_jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR2(10)
	CONSTRAINT    pr3_jhist_job_nn  NOT NULL
    , department_id NUMBER(4)
    , CONSTRAINT    pr3_jhist_date_interval
                    CHECK (end_date > start_date)
    ) ;

CREATE UNIQUE INDEX pr3_jhist_emp_id_st_date_pk 
ON pr3_job_history (employee_id, start_date) ;

ALTER TABLE pr3_job_history
ADD ( CONSTRAINT pr3_jhist_emp_id_st_date_pk
      PRIMARY KEY (employee_id, start_date)
    , CONSTRAINT     pr3_jhist_job_fk
                     FOREIGN KEY (job_id)
                     REFERENCES pr3_jobs
    , CONSTRAINT     pr3_jhist_emp_fk
                     FOREIGN KEY (employee_id)
                     REFERENCES pr3_employees
    , CONSTRAINT     pr3_jhist_dept_fk
                     FOREIGN KEY (department_id)
                     REFERENCES pr3_departments
    ) ;

REM ********************************************************************
REM Create the EMP_DETAILS_VIEW that joins the employees, jobs, 
REM departments, jobs, countries, and locations table to provide details
REM about employees.

Prompt ******  Creating EMP_DETAILS_VIEW view ...

CREATE OR REPLACE VIEW pr3_emp_details_view
  (employee_id,
   job_id,
   manager_id,
   department_id,
   location_id,
   country_id,
   first_name,
   last_name,
   salary,
   commission_pct,
   department_name,
   job_title,
   city,
   state_province,
   country_name,
   region_name)
AS SELECT
  e.employee_id, 
  e.job_id, 
  e.manager_id, 
  e.department_id,
  d.location_id,
  l.country_id,
  e.first_name,
  e.last_name,
  e.salary,
  e.commission_pct,
  d.department_name,
  j.job_title,
  l.city,
  l.state_province,
  c.country_name,
  r.region_name
FROM
  pr3_employees e,
  pr3_departments d,
  pr3_jobs j,
  pr3_locations l,
  pr3_countries c,
  pr3_regions r
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND c.region_id = r.region_id
  AND j.job_id = e.job_id 
WITH READ ONLY;

COMMIT;