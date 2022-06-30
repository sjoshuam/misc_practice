##########==========##########==========##########==========##########==========##########==========

## CREATE DATABASE, USE
CREATE DATABASE IF NOT EXISTS sql_practice;
USE sql_practice;


## CREATE TABLE, DROP TABLE, ALTER TABLE
DROP TABLE IF EXISTS person;
CREATE TABLE person (
	person_id int AUTO_INCREMENT NOT NULL,
    full_name varchar(32) UNIQUE,
    place_id int,
    PRIMARY KEY (person_id)
);

DROP TABLE IF EXISTS place;
CREATE TABLE place (
	place_id int AUTO_INCREMENT NOT NULL,
    city  varchar(32),
    state varchar(2),
    PRIMARY KEY (place_id)
);

ALTER TABLE person ADD CONSTRAINT FOREIGN KEY (place_id) REFERENCES place(place_id);


## INSERT INTO - VALUES
INSERT INTO person (full_name) VALUES
	("Ava"),
    ("Ben"),
    ("Chloe"), 
    ('Gorblatt'), 
    ('Dylan'), 
    ('Emma'),
    ('Felix');
INSERT INTO place (city, state) VALUES 
	('Austin', 'TX'), 
    ('Boston', 'MA'), 
    ('Chicago', 'IL'), 
    ('Dallas', 'TX')
    ;


## UPDATE - SET, WHERE
UPDATE person SET place_id = 1 WHERE person_id < 3;
UPDATE person SET place_id = 2 WHERE person_id > 4;
UPDATE person SET place_id = 3 WHERE place_id IS NULL;


## DELETE FROM
DELETE FROM person WHERE full_name = 'Gorblatt';


## SELECT - FROM, GROUP BY
DROP VIEW IF EXISTS state_count;
CREATE VIEW state_count as SELECT state, COUNT(city) as city_count FROM place GROUP BY state;
    
## LOAD DATA LOCAL INFILE
DROP TABLE IF EXISTS more_people;
CREATE TABLE more_people(
	person_id int,
    full_name varchar(32),
    place_id int,
    mcguffin varchar(2)
	);

SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE '/Users/s8/Documents/Coding/misc_practice/A_Input/sql_practice_1.csv' 
	INTO TABLE more_people
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (person_id, mcguffin, place_id, full_name);
SET GLOBAL local_infile = 0;

ALTER TABLE more_people DROP COLUMN mcguffin;

SET SQL_SAFE_UPDATES = 0;
UPDATE more_people SET person_id = NULL WHERE person_id < 1;
SET SQL_SAFE_UPDATES = 1;


## UNION, ORDER BY
(SELECT * FROM person LIMIT 3) UNION (SELECT * FROM MORE_PEOPLE LIMIT 3) ORDER BY place_id;


## UNION ALL, WITH - AS

WITH dup_names AS (
	SELECT full_name, COUNT(full_name) AS n FROM
		((SELECT full_name FROM more_people) UNION ALL (SELECT full_name FROM person)) as x
	GROUP BY full_name HAVING n > 1
    )
SELECT *  FROM dup_names;



## INNER JOIN

## OUTER JOIN

## LEFT JOIN

## RIGHT JOIN

## WITH

## PARTITION BY

## ROWS BETWEEN

## LAG() OVER

## RANK() OVER

## AVG(), COUNT(), MIN(), MAX()


