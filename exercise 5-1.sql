-- Create the company database
CREATE DATABASE company;

-- Switch to the company database
USE company;

-- 1. Create the EMPLOYEE table
CREATE TABLE EMPLOYEE (
    SSN VARCHAR(20) PRIMARY KEY,     -- Social Security Number
    FNAME VARCHAR(20),               -- First Name
    LNAME VARCHAR(20),               -- Last Name
    ADDRESS VARCHAR(50),             -- Address
    SEX CHAR(1),                     -- Gender
    SALARY INT,                      -- Salary
    SUPERSSN VARCHAR(20),            -- Supervisor SSN
    DNO VARCHAR(20)                  -- Department Number
);

-- 2. Create the DEPARTMENT table
CREATE TABLE DEPARTMENT (
    DNO VARCHAR(20) PRIMARY KEY,     -- Department Number
    DNAME VARCHAR(20),                -- Department Name
    MGRSTARTDATE DATE,                -- Manager Start Date
    MGRSSN VARCHAR(20)                -- Manager SSN
);

-- 3. Create the DLOCATION table
CREATE TABLE DLOCATION (
    DLOC VARCHAR(20),                -- Department Location
    DNO VARCHAR(20),                 -- Department Number
    PRIMARY KEY (DNO, DLOC)          -- Primary Key (Composite Key)
);

-- 4. Create the PROJECT table
CREATE TABLE PROJECT (
    PNO INT PRIMARY KEY,             -- Project Number
    PNAME VARCHAR(30),               -- Project Name
    PLOCATION VARCHAR(30),           -- Project Location
    DNO VARCHAR(20)                  -- Department Number
);

-- 5. Create the WORKS_ON table
CREATE TABLE WORKS_ON (
    HOURS INT,                       -- Hours Worked
    SSN VARCHAR(20),                 -- Employee SSN
    PNO INT,                         -- Project Number
    PRIMARY KEY (SSN, PNO)          -- Primary Key (Composite Key)
);

-- 1. Alter EMPLOYEE table to add foreign keys
ALTER TABLE EMPLOYEE
    ADD FOREIGN KEY (SUPERSSN) REFERENCES EMPLOYEE(SSN),
    ADD FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO);

-- 2. Alter DEPARTMENT table to add foreign key
ALTER TABLE DEPARTMENT
    ADD FOREIGN KEY (MGRSSN) REFERENCES EMPLOYEE(SSN);

-- 3. Alter DLOCATION table to add foreign key
ALTER TABLE DLOCATION
    ADD FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO);

-- 4. Alter PROJECT table to add foreign key
ALTER TABLE PROJECT
    ADD FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO);

-- 5. Alter WORKS_ON table to add foreign keys
ALTER TABLE WORKS_ON
    ADD FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN),
    ADD FOREIGN KEY (PNO) REFERENCES PROJECT(PNO);
    
DESC EMPLOYEE;
DESC Department;
DESC DLOCATION;
DESC Project;
DESC WORKS_ON;

-- Inserting values into DEPARTMENT table
INSERT INTO DEPARTMENT (DNO, DNAME, MGRSTARTDATE) VALUES 
('D1', 'HR', '2022-01-15'),
('D2', 'Finance', '2022-03-01'),
('D3', 'IT', '2022-05-10'),
('D4', 'Accounts', '2023-07-01'),
('D5', 'Sales', '2023-08-15');

-- Inserting values into EMPLOYEE table
INSERT INTO EMPLOYEE (SSN, FNAME, LNAME, ADDRESS, SEX, SALARY, SUPERSSN, DNO) VALUES 
('E101', 'Alice', 'Johnson', '123 Maple Ave', 'F', 950000, NULL, 'D1'),
('E102', 'Bob', 'Smith', '456 Oak St', 'M', 850000, 'E101', 'D2'),
('E103', 'Carol', 'Taylor', '789 Pine Rd', 'F', 700000, 'E101', 'D3'),
('E104', 'David', 'Williams', '321 Elm St', 'M', 750000, 'E102', 'D1'),
('E105', 'Eva', 'Brown', '654 Cedar Blvd', 'F', 900000, 'E102', 'D2'),
('E106', 'Frank', 'Jones', '234 Maple St', 'M', 720000, NULL, 'D4'),
('E107', 'Grace', 'Davis', '789 Elm St', 'F', 800000, 'E106', 'D4'),
('E108', 'Hardin', 'Scott', '345 Oak St', 'M', 850000, 'E107', 'D5'),
('E109', 'Irene', 'Wilson', '567 Pine St', 'F', 780000, 'E108', 'D5');

INSERT INTO DLOCATION (DLOC, DNO) VALUES 
('New York', 'D1'),
('Chicago', 'D2'),
('San Francisco', 'D3'),
('Dallas', 'D4'),
('Los Angeles', 'D5');



-- Update DEPARTMENT to set MGRSSN for each department

-- For department D1 (HR), the manager is E101
UPDATE DEPARTMENT
SET MGRSSN = 'E101'
WHERE DNO = 'D1';

-- For department D2 (Finance), the manager is E102
UPDATE DEPARTMENT
SET MGRSSN = 'E102'
WHERE DNO = 'D2';

-- For department D3 (IT), the manager is E103
UPDATE DEPARTMENT
SET MGRSSN = 'E103'
WHERE DNO = 'D3';

-- For department D4 (Marketing), the manager is E106
UPDATE DEPARTMENT
SET MGRSSN = 'E106'
WHERE DNO = 'D4';

-- For department D5 (Sales), the manager is E108
UPDATE DEPARTMENT
SET MGRSSN = 'E107'
WHERE DNO = 'D5';



-- Inserting values into PROJECT table
INSERT INTO PROJECT (PNO, PNAME, PLOCATION, DNO) VALUES (101, 'Website Redesign', 'New York', 'D1');
INSERT INTO PROJECT (PNO, PNAME, PLOCATION, DNO) VALUES (102, 'Financial Analysis', 'Chicago', 'D2');
INSERT INTO PROJECT (PNO, PNAME, PLOCATION, DNO) VALUES (103, 'IoT', 'San Francisco', 'D3');

-- Inserting values into WORKS_ON table
INSERT INTO WORKS_ON (HOURS, SSN, PNO) VALUES (40, 'E101', 101);
INSERT INTO WORKS_ON (HOURS, SSN, PNO) VALUES (35, 'E102', 102);
INSERT INTO WORKS_ON (HOURS, SSN, PNO) VALUES (30, 'E103', 103);
INSERT INTO WORKS_ON (HOURS, SSN, PNO) VALUES (25, 'E104', 101);
INSERT INTO WORKS_ON (HOURS, SSN, PNO) VALUES (20, 'E105', 102);
INSERT INTO WORKS_ON (HOURS, SSN, PNO) VALUES (24, 'E108', 103);

-- Selecting all records from each table
SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE;
SELECT * FROM DLOCATION;
SELECT * FROM PROJECT;
SELECT * FROM WORKS_ON;

-- Answers to the queries
-- Query 1: List of project numbers for projects involving an employee named 'Scott'
(SELECT DISTINCT P.PNO
 FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
 WHERE E.DNO=D.DNO
 AND D.MGRSSN=E.SSN
 AND E.LNAME='SCOTT')
UNION
(SELECT DISTINCT P1.PNO
 FROM PROJECT P1, WORKS_ON W, EMPLOYEE E1
 WHERE P1.PNO=W.PNO
 AND E1.SSN=W.SSN
 AND E1.LNAME='SCOTT');

-- Query 2: Resulting salaries if every employee working on the 'IoT' project is given a 10% raise
SELECT SSN, SALARY * 1.10 AS NEW_SALARY
FROM EMPLOYEE
WHERE SSN IN (
    SELECT SSN
    FROM WORKS_ON
    WHERE PNO = (SELECT PNO FROM PROJECT WHERE PNAME = 'IoT')
);

-- Query 3: Sum, max, min, and average salaries of employees in the 'Accounts' department
SELECT SUM(SALARY) AS TOTAL_SALARY, 
       MAX(SALARY) AS MAX_SALARY, 
       MIN(SALARY) AS MIN_SALARY, 
       AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEE
WHERE DNO = (SELECT DNO FROM DEPARTMENT WHERE DNAME = 'Accounts');


-- Query 4: Retrieve names of employees who work on all projects controlled by department number 5
SELECT E.FNAME, E.LNAME
FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT PNO FROM PROJECT WHERE DNO='5' AND PNO NOT IN (SELECT
PNO FROM WORKS_ON
WHERE E.SSN=SSN));

SELECT E.FNAME, E.LNAME
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT P.PNO
    FROM PROJECT P
    WHERE P.DNO = '5'
    AND NOT EXISTS (
        SELECT 1
        FROM WORKS_ON W
        WHERE W.SSN = E.SSN
        AND W.PNO = P.PNO
    )
);

-- Query 5: Departments with more than five employees making more than Rs. 6,00,000
SELECT D.DNO, COUNT(*) AS Num_Employees
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.DNO = E.DNO
WHERE E.SALARY > 600000
GROUP BY D.DNO
HAVING COUNT(*) > 5;