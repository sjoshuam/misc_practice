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


## modifying key constraints
# SHOW CREATE TABLE person; # get name for foreign key here
ALTER TABLE person DROP FOREIGN KEY person_ibfk_1;


## SELECT - FROM, GROUP BY
DROP VIEW IF EXISTS temp;
CREATE VIEW temp as SELECT state, COUNT(city) AS cities FROM place GROUP BY state;

    
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


## UNION, ORDER BY (NOTE: no INTERSECT  OR MINUS operatorS in mysql, use UNION ALL to include duplicates)
DROP TABLE IF EXISTS all_people;
CREATE TABLE all_people AS 
	SELECT full_name, place_id FROM person
    UNION 
    SELECT full_name, place_id FROM more_people
    ORDER BY full_name;


## LEFT JOIN AUGMENTING AN EXISTING TABLE (NOTE: can use USING instead of ON if colnames identical)
DROP TABLE IF EXISTS temp_table;

CREATE TABLE temp_table AS (
	SELECT * FROM all_people
	LEFT JOIN
    (SELECT person_id, full_name AS fn FROM person) as p2
    ON all_people.full_name = p2.fn
    );

DROP TABLE IF EXISTS all_people;
CREATE TABLE all_people AS SELECT person_id, full_name, place_id FROM temp_table;

ALTER TABLE all_people MODIFY COLUMN person_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT;


##  INNER / LEFT JOIN (NOTE: no OUTER join in mysql)
DROP TABLE IF EXISTS person_place;
CREATE TABLE person_place AS (
	SELECT * FROM all_people
    LEFT JOIN
   (SELECT * FROM place) as x
    USING (place_id)
    );

DROP VIEW IF EXISTS temp;
CREATE VIEW temp AS (
	SELECT * FROM person_place
    INNER JOIN
    (SELECT full_name FROM more_people LIMIT 3) as x
    USING (full_name)
	);


## PARTITION BY, INDEX  (for optimization purposes)
ALTER TABLE all_people PARTITION BY RANGE(person_id) (
	PARTITION p0 VALUES LESS THAN (10),
    PARTITION p1 VALUES LESS THAN MAXVALUE
	);
    
    
CREATE INDEX place_idx ON person_place(city);
##SHOW INDEX FROM person_place; # show existing indices

DROP VIEW IF EXISTS temp;
CREATE VIEW temp AS (SELECT * FROM all_people PARTITION (p1));


## ROWS BETWEEN

## LAG() OVER

## RANK() OVER

## AVG(), COUNT(), MIN(), MAX()

## SHOW
SHOW DATABASES;
SHOW TABLES;
