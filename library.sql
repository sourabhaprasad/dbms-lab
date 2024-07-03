CREATE DATABASE library;

Use library;

CREATE TABLE Publisher (
    Name VARCHAR(20) PRIMARY KEY,
    Phone VARCHAR(15),
    Address VARCHAR(20)
);

CREATE TABLE Book(
    Book_ID INTEGER PRIMARY KEY,
    Title VARCHAR(20),
    Pub_year VARCHAR(20),
    Publisher_Name VARCHAR(20),
    FOREIGN KEY (Publisher_Name) references Publisher(Name) ON DELETE CASCADE
);

CREATE TABLE Book_authors (
    Author_name VARCHAR(20),
    Book_ID INTEGER,
    FOREIGN KEY (Book_ID) references Book(Book_ID) ON DELETE CASCADE,
    PRIMARY KEY (Book_ID, Author_Name)
);

CREATE TABLE Library_Branch (
    Branch_ID INTEGER PRIMARY KEY,
    Branch_Name VARCHAR(50),
    Address VARCHAR(50)
);

CREATE TABLE Book_Copies (
    No_of_Copies INTEGER,
    Book_ID Integer,
    FOREIGN KEY (Book_ID) references Book(Book_ID) ON DELETE CASCADE,
    BRANCH_ID INTEGER,
    FOREIGN KEY (Branch_ID) references LIBRARY_BRANCH (Branch_ID) ON DELETE CASCADE,
    PRIMARY KEY (Book_ID, Branch_ID)
);

CREATE TABLE Card(
     Card_No INTEGER PRIMARY KEY
);

CREATE TABLE Book_Lending (
   Book_ID INTEGER,
    FOREIGN KEY (Book_ID) references Book(Book_ID) ON DELETE CASCADE,
    Branch_ID INTEGER,
    FOREIGN KEY (Branch_ID) references Library_Branch(Branch_ID) ON DELETE CASCADE,
Card_No INTEGER,
FOREIGN KEY (Card_No) references Card(Card_No) ON DELETE CASCADE,
Date_Out Date,
Due_Date Date,
PRIMARY KEY (Book_ID,Branch_ID,Card_No)
);

DESC Book_Lending; 