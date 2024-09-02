# Create the database and switch to it
CREATE DATABASE movies;
USE movies;

# Create the tables
CREATE TABLE ACTOR (
    ACT_ID INTEGER PRIMARY KEY,
    ACT_NAME VARCHAR(20),
    ACT_GENDER CHAR(1)
);

CREATE TABLE DIRECTOR (
    DIR_ID INTEGER PRIMARY KEY,
    DIR_NAME VARCHAR(20),
    DIR_PHONE BIGINT
);

CREATE TABLE MOVIES (
    MOV_ID INTEGER PRIMARY KEY,
    MOV_TITLE VARCHAR(25),
    MOV_YEAR INTEGER,
    MOV_LANG VARCHAR(12),
    DIR_ID INTEGER,
    FOREIGN KEY (DIR_ID) REFERENCES DIRECTOR (DIR_ID)
);

CREATE TABLE MOVIE_CAST (
    ACT_ID INTEGER,
    MOV_ID INTEGER,
    ROLE VARCHAR(20),
    PRIMARY KEY (ACT_ID, MOV_ID),
    FOREIGN KEY (ACT_ID) REFERENCES ACTOR (ACT_ID),
    FOREIGN KEY (MOV_ID) REFERENCES MOVIES (MOV_ID)
);

CREATE TABLE RATING (
    MOV_ID INTEGER PRIMARY KEY,
    REV_STARS VARCHAR(25),
    FOREIGN KEY (MOV_ID) REFERENCES MOVIES (MOV_ID)
);

# Insert data into ACTOR table
INSERT INTO ACTOR (ACT_ID, ACT_NAME, ACT_GENDER) VALUES
(1, 'Robert Downey Jr.', 'M'), (2, 'Scarlett Johansson', 'F'),
(3, 'Chris Hemsworth', 'M'), (4, 'Mark Ruffalo', 'M'),
(5, 'Tom Holland', 'M'), (6, 'Gal Gadot', 'F'),
(7, 'Harrison Ford', 'M');

# Insert data into DIRECTOR table
INSERT INTO DIRECTOR (DIR_ID, DIR_NAME, DIR_PHONE) VALUES
(1, 'Steven Spielberg', 1234567890), (2, 'Christopher Nolan', 9876543210),
(3, 'James Cameron', 5555555555), (4, 'Quentin Tarantino', 4444444444),
(5, 'Patty Jenkins', 3333333333), (6, 'Alfred Hitchcock', 2222222222);

# Insert data into MOVIES table
INSERT INTO MOVIES (MOV_ID, MOV_TITLE, MOV_YEAR, MOV_LANG, DIR_ID) VALUES
(1, 'Avengers: Endgame', 2019, 'English', 1), (2, 'Inception', 2010, 'English', 2),
(3, 'Titanic', 1997, 'English', 3), (4, 'Pulp Fiction', 1994, 'English', 4),
(5, 'Wonder Woman', 2017, 'English', 5), (6, 'Psycho', 1960, 'English', 6),
(7, 'Star Wars', 1977, 'English', 1), (8, 'Blade Runner 2049', 2017, 'English', 1);

# Insert data into MOVIE_CAST table
INSERT INTO MOVIE_CAST (ACT_ID, MOV_ID, ROLE) VALUES
(1, 1, 'Iron Man'), (2, 1, 'Black Widow'), (3, 1, 'Thor'), (4, 1, 'Hulk'),
(5, 2, 'Peter Parker'), (6, 5, 'Wonder Woman'), (7, 7, 'Han Solo'),
(7, 8, 'Rick Deckard'), (1, 2, 'Iron Man'), (2, 2, 'Black Widow'),
(3, 7, 'Thor'), (5, 7, 'Peter Parker'); 

# Insert data into RATING table
INSERT INTO RATING (MOV_ID, REV_STARS) VALUES
(1, '4.5'), (2, '5'), (3, '4.8'), (4, '4.7'),
(5, '4.9'), (6, '4.6'), (7, '4.3'), (8, '4.2');

# Queries

# Query 1: Find movies directed by Alfred Hitchcock
SELECT MOV_TITLE 
FROM MOVIES 
WHERE DIR_ID = (SELECT DIR_ID FROM DIRECTOR WHERE DIR_NAME = 'Alfred Hitchcock');

# Query 2: Find movies with actors who played in multiple movies
SELECT MOV_TITLE 
FROM MOVIES M 
JOIN MOVIE_CAST MC ON M.MOV_ID = MC.MOV_ID 
WHERE MC.ACT_ID IN (SELECT ACT_ID FROM MOVIE_CAST GROUP BY ACT_ID HAVING COUNT(*) > 1)
GROUP BY MOV_TITLE 
HAVING COUNT(*) > 1;

# Query 3: Find actors who starred in movies before 2000 and after 2015
SELECT DISTINCT A.ACT_NAME 
FROM ACTOR A
JOIN MOVIE_CAST MC1 ON A.ACT_ID = MC1.ACT_ID
JOIN MOVIES M1 ON MC1.MOV_ID = M1.MOV_ID
JOIN MOVIE_CAST MC2 ON A.ACT_ID = MC2.ACT_ID
JOIN MOVIES M2 ON MC2.MOV_ID = M2.MOV_ID
WHERE M1.MOV_YEAR < 2000 AND M2.MOV_YEAR > 2015;

# Query 4: List movies with ratings greater than 0 and order by title
SELECT MOV_TITLE, MAX(REV_STARS) 
FROM MOVIES 
JOIN RATING USING (MOV_ID) 
GROUP BY MOV_TITLE 
HAVING MAX(REV_STARS) > 0 
ORDER BY MOV_TITLE;

# Query 5: Update ratings to 5 for movies directed by Steven Spielberg
UPDATE RATING 
SET REV_STARS = '5' 
WHERE MOV_ID IN (
    SELECT MOV_ID 
    FROM MOVIES 
    WHERE DIR_ID = (SELECT DIR_ID FROM DIRECTOR WHERE DIR_NAME = 'Steven Spielberg')
);
SELECT * FROM RATING;
