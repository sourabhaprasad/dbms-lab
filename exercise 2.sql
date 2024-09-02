CREATE DATABASE orders;

USE orders;

CREATE TABLE SALESMAN (
    SALESMAN_ID INTEGER PRIMARY KEY,
    NAME VARCHAR(20),
    CITY VARCHAR(20),
    COMMISSION VARCHAR(20)
);

CREATE TABLE CUSTOMER (
    CUSTOMER_ID INTEGER PRIMARY KEY,
    CUST_NAME VARCHAR(20),
    CITY VARCHAR(20),
    GRADE INTEGER,
    SALESMAN_ID INTEGER,
    FOREIGN KEY (SALESMAN_ID) REFERENCES SALESMAN(SALESMAN_ID) ON DELETE SET NULL
);

CREATE TABLE ORDERS (
    ORD_NO INTEGER PRIMARY KEY,
    PURCHASE_AMT BIGINT,
    ORD_DATE DATE,
    CUSTOMER_ID INTEGER,
    SALESMAN_ID INTEGER,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON DELETE CASCADE,
    FOREIGN KEY (SALESMAN_ID) REFERENCES SALESMAN(SALESMAN_ID) ON DELETE CASCADE
);

DESC SALESMAN;
DESC CUSTOMER;
DESC ORDERS;

INSERT INTO SALESMAN VALUES 
(1000, 'AKASH', 'BANGALORE', '25 %'),
(2000, 'RAVI', 'BANGALORE', '20 %'),
(3000, 'KUMAR', 'MYSORE', '15 %'),
(4000, 'SMITH', 'DELHI', '30 %'),
(5000, 'HARSHA', 'HYDERABAD', '15 %');

SELECT * FROM SALESMAN;

INSERT INTO CUSTOMER VALUES 
(10, 'PREETHI', 'BANGALORE', 100, 1000),
(11, 'VIVEK', 'MANGALORE', 300, 1000),
(12, 'BHASKAR', 'CHENNAI', 400, 2000),
(13, 'CHETHAN', 'BANGALORE', 200, 2000),
(14, 'MAMATHA', 'BANGALORE', 400, 3000);

SELECT * FROM CUSTOMER;

INSERT INTO ORDERS VALUES 
(50, 5000, '2021-05-22', 10, 1000),
(51, 450, '2021-05-22', 10, 2000),
(52, 1000, '2023-02-05', 13, 2000),
(53, 3500, '2021-04-13', 14, 3000),
(54, 550, '2021-03-09', 12, 2000);

SELECT * FROM ORDERS;

-- Query 1: Count the customers with grades above Bangalore’s average.
SELECT GRADE, COUNT(DISTINCT CUSTOMER_ID) 
FROM CUSTOMER
GROUP BY GRADE
HAVING GRADE > (SELECT AVG(GRADE) FROM CUSTOMER WHERE CITY = 'BANGALORE');

-- Query 2: Find the name and numbers of all salesmen who had more than one customer.
SELECT SALESMAN_ID, NAME 
FROM SALESMAN A
WHERE 1 < (SELECT COUNT(*) FROM CUSTOMER WHERE SALESMAN_ID = A.SALESMAN_ID);

-- Query 3: List all salesmen and indicate those who have and don’t have customers in their cities (Use UNION operation).
SELECT SALESMAN.SALESMAN_ID, NAME, CUST_NAME, COMMISSION 
FROM SALESMAN, CUSTOMER
WHERE SALESMAN.CITY = CUSTOMER.CITY
UNION
SELECT SALESMAN_ID, NAME, 'NO MATCH', COMMISSION 
FROM SALESMAN
WHERE NOT CITY = ANY (SELECT CITY FROM CUSTOMER)
ORDER BY NAME DESC;

-- Query 4: Create a view that finds the salesman who has the customer with the highest order of a day.
CREATE VIEW ELITSALESMAN AS
SELECT B.ORD_DATE, A.SALESMAN_ID, A.NAME 
FROM SALESMAN A, ORDERS B
WHERE A.SALESMAN_ID = B.SALESMAN_ID
AND B.PURCHASE_AMT = (SELECT MAX(PURCHASE_AMT) FROM ORDERS C WHERE C.ORD_DATE = B.ORD_DATE);

SELECT * FROM ELITSALESMAN;

-- Query 5: Demonstrate the DELETE operation by removing the salesman with ID 1000. All his orders must also be deleted.
DELETE FROM SALESMAN WHERE SALESMAN_ID = 1000;

SELECT * FROM SALESMAN;
