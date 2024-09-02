-- Create the 'library' database
CREATE DATABASE library;

-- Switch to the 'library' database
USE library;

-- Create the PUBLISHER table
CREATE TABLE PUBLISHER (
    NAME VARCHAR(20) PRIMARY KEY, 
    PHONE BIGINT, 
    ADDRESS VARCHAR(20)
);

-- Create the BOOK table
CREATE TABLE BOOK (
    BOOK_ID INTEGER PRIMARY KEY, 
    TITLE VARCHAR(20), 
    PUB_YEAR VARCHAR(20), 
    PUBLISHER_NAME VARCHAR(20), 
    FOREIGN KEY (PUBLISHER_NAME) REFERENCES PUBLISHER(NAME) ON DELETE CASCADE
);

-- Create the BOOK_AUTHORS table
CREATE TABLE BOOK_AUTHORS (
    AUTHOR_NAME VARCHAR(20), 
    BOOK_ID INTEGER, 
    FOREIGN KEY(BOOK_ID) REFERENCES BOOK (BOOK_ID) ON DELETE CASCADE, 
    PRIMARY KEY (BOOK_ID, AUTHOR_NAME)
);

-- Create the LIBRARY_BRANCH table
CREATE TABLE LIBRARY_BRANCH (
    BRANCH_ID INTEGER PRIMARY KEY, 
    BRANCH_NAME VARCHAR(50), 
    ADDRESS VARCHAR(50)
);

-- Create the BOOK_COPIES table
CREATE TABLE BOOK_COPIES (
    NO_OF_COPIES INTEGER, 
    BOOK_ID INTEGER, 
    FOREIGN KEY(BOOK_ID) REFERENCES BOOK (BOOK_ID) ON DELETE CASCADE, 
    BRANCH_ID INTEGER, 
    FOREIGN KEY(BRANCH_ID) REFERENCES LIBRARY_BRANCH (BRANCH_ID) ON DELETE CASCADE, 
    PRIMARY KEY (BOOK_ID, BRANCH_ID)
);

-- Create the CARD table
CREATE TABLE CARD (
    CARD_NO INTEGER PRIMARY KEY
);

-- Create the BOOK_LENDING table
CREATE TABLE BOOK_LENDING (
    DATE_OUT DATE, 
    DUE_DATE DATE, 
    BOOK_ID INTEGER, 
    FOREIGN KEY(BOOK_ID) REFERENCES BOOK (BOOK_ID) ON DELETE CASCADE, 
    BRANCH_ID INTEGER, 
    FOREIGN KEY(BRANCH_ID) REFERENCES LIBRARY_BRANCH (BRANCH_ID) ON DELETE CASCADE, 
    CARD_NO INTEGER, 
    FOREIGN KEY(CARD_NO) REFERENCES CARD (CARD_NO) ON DELETE CASCADE, 
    PRIMARY KEY (BOOK_ID, BRANCH_ID, CARD_NO)
);

-- Display the structure of the tables
DESC PUBLISHER;
DESC BOOK;
DESC BOOK_AUTHORS;
DESC LIBRARY_BRANCH;
DESC BOOK_COPIES;
DESC CARD;
DESC BOOK_LENDING;

-- Insert values into the PUBLISHER table
INSERT INTO PUBLISHER VALUES('MCGRAWHILL', 9191919191, 'BANGALORE');
INSERT INTO PUBLISHER VALUES('PEARSON', 8181818181, 'NEWDELHI');
INSERT INTO PUBLISHER VALUES('RANDOMHOUSE', 7171717171, 'HYDERABAD');
INSERT INTO PUBLISHER VALUES('LIVRE', 6161616161, 'CHENNAI');
INSERT INTO PUBLISHER VALUES('PLANETA', 5151515151, 'BANGALORE');

-- View the contents of the PUBLISHER table
SELECT * FROM PUBLISHER;

-- Insert values into the BOOK table
INSERT INTO BOOK VALUES(1, 'DBMS', 'JAN-2017', 'MCGRAWHILL');
INSERT INTO BOOK VALUES(2, 'ADBMS', 'JUN-2016', 'MCGRAWHILL');
INSERT INTO BOOK VALUES(3, 'CN', 'SEP-2016', 'PEARSON');
INSERT INTO BOOK VALUES(4, 'CG', 'SEP-2015', 'PLANETA');
INSERT INTO BOOK VALUES(5, 'OS', 'MAY-2016', 'PEARSON');

-- View the contents of the BOOK table
SELECT * FROM BOOK;

-- Insert values into the BOOK_AUTHORS table
INSERT INTO BOOK_AUTHORS VALUES ('NAVATHE', 1); 
INSERT INTO BOOK_AUTHORS VALUES ('NAVATHE', 2); 
INSERT INTO BOOK_AUTHORS VALUES ('TANENBAUM', 3); 
INSERT INTO BOOK_AUTHORS VALUES ('EDWARD ANGEL', 4); 
INSERT INTO BOOK_AUTHORS VALUES ('GALVIN', 5);

-- View the contents of the BOOK_AUTHORS table
SELECT * FROM BOOK_AUTHORS;

-- Insert values into the LIBRARY_BRANCH table
INSERT INTO LIBRARY_BRANCH VALUES (10, 'RR NAGAR', 'BANGALORE'); 
INSERT INTO LIBRARY_BRANCH VALUES (11, 'KENGERI', 'BANGALORE'); 
INSERT INTO LIBRARY_BRANCH VALUES (12, 'RAJAJI NAGAR', 'BANGALORE'); 
INSERT INTO LIBRARY_BRANCH VALUES (13, 'NITTE', 'MANGALORE');
INSERT INTO LIBRARY_BRANCH VALUES (14, 'MANIPAL', 'UDUPI');

-- View the contents of the LIBRARY_BRANCH table
SELECT * FROM LIBRARY_BRANCH;

-- Insert values into the BOOK_COPIES table
INSERT INTO BOOK_COPIES VALUES (10, 1, 10); 
INSERT INTO BOOK_COPIES VALUES (5, 1, 11); 
INSERT INTO BOOK_COPIES VALUES (2, 2, 12); 
INSERT INTO BOOK_COPIES VALUES (5, 2, 13); 
INSERT INTO BOOK_COPIES VALUES (7, 3, 14); 
INSERT INTO BOOK_COPIES VALUES (1, 5, 10); 
INSERT INTO BOOK_COPIES VALUES (3, 4, 11);

-- View the contents of the BOOK_COPIES table
SELECT * FROM BOOK_COPIES;

-- Insert values into the CARD table
INSERT INTO CARD VALUES (100); 
INSERT INTO CARD VALUES (101); 
INSERT INTO CARD VALUES (102);
INSERT INTO CARD VALUES (103); 
INSERT INTO CARD VALUES (104);

-- View the contents of the CARD table
SELECT * FROM CARD;

-- Insert values into the BOOK_LENDING table
INSERT INTO BOOK_LENDING VALUES ('2021-06-01', '2021-07-01', 1, 10, 101); 
INSERT INTO BOOK_LENDING VALUES ('2021-01-05', '2021-02-05', 3, 14, 101); 
INSERT INTO BOOK_LENDING VALUES ('2021-07-03', '2021-08-03', 2, 13, 101); 
INSERT INTO BOOK_LENDING VALUES ('2021-12-11', '2022-01-11', 4, 11, 101); 
INSERT INTO BOOK_LENDING VALUES ('2021-10-01', '2021-11-01', 1, 11, 104); 
INSERT INTO BOOK_LENDING VALUES ('2021-01-05', '2021-02-05', 3, 14, 100); 
INSERT INTO BOOK_LENDING VALUES ('2021-07-03', '2021-08-03', 2, 13, 100); 
INSERT INTO BOOK_LENDING VALUES ('2021-01-05', '2021-02-05', 3, 14, 103); 
INSERT INTO BOOK_LENDING VALUES ('2021-07-03', '2021-08-03', 2, 13, 104); 
INSERT INTO BOOK_LENDING VALUES ('2021-01-05', '2021-02-05', 3, 14, 104); 
INSERT INTO BOOK_LENDING VALUES ('2021-07-03', '2021-08-03', 1, 13, 101);

-- View the contents of the BOOK_LENDING table
SELECT * FROM BOOK_LENDING;

-- Query 1: Retrieve details of all books in the library – id, title, name of publisher, authors, number of copies in each branch, etc.
SELECT B.BOOK_ID, B.TITLE, B.PUBLISHER_NAME, A.AUTHOR_NAME, C.NO_OF_COPIES, L.BRANCH_ID
FROM BOOK B, BOOK_AUTHORS A, BOOK_COPIES C, LIBRARY_BRANCH L
WHERE B.BOOK_ID = A.BOOK_ID  
AND B.BOOK_ID = C.BOOK_ID  
AND L.BRANCH_ID = C.BRANCH_ID;

-- Query 2: Get the particulars of borrowers who have borrowed more than 3 books, but from Jan 2021 to Aug 2021
SELECT CARD_NO 
FROM BOOK_LENDING
WHERE DATE_OUT BETWEEN '2021-01-01' AND '2021-08-01'
GROUP BY CARD_NO
HAVING COUNT(*) > 3;

-- Query 3: Delete a book in the BOOK table. Update the contents of other tables to reflect this data manipulation operation.
DELETE FROM BOOK WHERE BOOK_ID = 3;

-- View the BOOK_COPIES table after deletion
SELECT * FROM BOOK_COPIES WHERE BOOK_ID = 3;

-- View the BOOK_LENDING table after deletion
SELECT * FROM BOOK_LENDING;

-- Query 4: Partition the BOOK table based on the year of publication. Demonstrate its working with a simple query.
CREATE VIEW V_PUBLICATION AS
SELECT PUB_YEAR
FROM BOOK;

-- View the V_PUBLICATION view
SELECT * FROM V_PUBLICATION;

-- Query 5: Create a view of all books and their number of copies that are currently available in the library.
CREATE VIEW V_BOOKS AS
SELECT B.BOOK_ID, B.TITLE, C.NO_OF_COPIES
FROM BOOK B, BOOK_COPIES C, LIBRARY_BRANCH L
WHERE B.BOOK_ID = C.BOOK_ID 
AND C.BRANCH_ID = L.BRANCH_ID;

-- View the V_BOOKS view
SELECT * FROM V_BOOKS;