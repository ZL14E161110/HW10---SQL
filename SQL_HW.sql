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

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- I don't want to delete the current "Address file" here,so i will use address 1
CREATE TABLE address1 (
 address_id INTEGER(11) AUTO_INCREMENT NOT NULL,
 address VARCHAR(50) NOT NULL,
 address2 VARCHAR(50) NOT NULL,
 district VARCHAR(20) NOT NULL,
 city_id INTEGER(10) NOT NULL,
 postal_code VARCHAR(10) NOT NULL,
 location GEOMETRY NOT NULL,
 last_update timestamp,
 PRIMARY KEY (address_id)
);

SELECT * FROM address1;

-- 6a. Use JOIN to display the first and last names, as well as the address, Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 

SELECT s.first_name, s.last_name, sum(p.amount) as "Total_Amount_Rung_Up"
FROM payment p
JOIN staff s
ON p.staff_id = s.staff_id
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT f.film_id, f.title, count(fa.actor_id) as "Number_of_Actors"
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY fa.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.film_id, f.title, count(f.film_id) as "Number_of_Copy"
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = "HUNCHBACK IMPOSSIBLE"
GROUP BY f.film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, sum(p.amount) as "Total amount paid"
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 

SELECT title
FROM film
WHERE title like "K%" 
OR title like "Q%"
AND language_id IN
(
  SELECT language_id
  FROM language
  WHERE name IN ('ENGLISH')
);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN 
  (
  SELECT film_id
  FROM film
  WHERE title = "ALONE TRIP"
  )
);

-- 7c. List the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ct
ON a.city_id = ct.city_id
JOIN country cy
ON ct.country_id = cy.country_id
WHERE country = "CANADA";

-- 7d. Identify all movies categorized as famiy films.

SELECT f.title as "Film Title", c.name as "Movie Type"
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = "Family";

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title as "Movie", count(r.rental_id) as "Rent Times"
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY i.film_id
ORDER BY count(r.rental_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.



-- 7g. Write a query to display for each store its store ID, city, and country.



-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)



