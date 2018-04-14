-- Select sakila Database
USE sakila;

-- 1a.list of all the actors who have Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT CONCAT (UPPER(first_name)," ", UPPER(last_name)) AS `Actor Name` FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name LIKE 'Joe%';

-- 2b. Find all actors whose last name contain the letters GEN
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI, ordered rows by last name and first name
SELECT actor_id, last_name, first_name FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country          
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name.
ALTER TABLE actor
ADD middle_name VARCHAR(50) AFTER first_name;

SELECT * from actor;

-- 3b. Change the data type of the middle_name column to blobs.
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;
SELECT * from actor;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;
SELECT * from actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) as `number_of_actor`
FROM actor
GROUP BY last_name;

-- 4b. List last names and the number of actors, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) as `number_of_actor`
FROM actor
GROUP BY last_name
HAVING number_of_actor > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered as GROUCHO WILLIAMS. Write a query to fix the record.
Select * FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- per search above, the actor_id is 172 for the person

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- Now for Actor ID 172, the name is HARPO now
Select * FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 4d. If the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO.
UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id IN
(Select actor_id FROM
(Select actor_id FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS') AS x);

-- ID 172 changed back to GROUCHO
Select * FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
