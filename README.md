# HW10---SQL

## Homework Assignment

* 1a. You need a list of all the actors who have Display the first and last names of all actors from the table `actor`. 
~~~ mysql
USE sakila;
SELECT first_name, last_name FROM actor;
~~~

* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
~~~ mysql
SELECT CONCAT (UPPER(first_name)," ", UPPER(last_name)) AS `Actor Name` FROM actor;
~~~

* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
~~~ mysql
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name LIKE 'Joe%';
~~~

* 2b. Find all actors whose last name contain the letters `GEN`:
~~~ mysql
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';
~~~

* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
~~~ mysql
SELECT actor_id, last_name, first_name FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;
~~~

* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
~~~ mysql
SELECT country_id, country
FROM country          
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
~~~

* 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
~~~ mysql
ALTER TABLE actor
ADD middle_name VARCHAR(50) AFTER first_name;

SELECT * from actor;
~~~

* 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
~~~ mysql
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;
SELECT * from actor;
~~~

* 3c. Now delete the `middle_name` column.
~~~ mysql
ALTER TABLE actor
DROP COLUMN middle_name;
SELECT * from actor;
~~~

* 4a. List the last names of actors, as well as how many actors have that last name.
~~~ mysql
SELECT last_name, COUNT(last_name) as `number_of_actor`
FROM actor
GROUP BY last_name;
~~~

* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
~~~ mysql
SELECT last_name, COUNT(last_name) as `number_of_actor`
FROM actor
GROUP BY last_name
HAVING number_of_actor > 1;
~~~

* 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
~~~ mysql
Select * FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- per search above, the actor_id is 172 for the person

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- Now for Actor ID 172, the name is HARPO now
Select * FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
~~~

* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
~~~ mysql
UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id IN
(Select actor_id FROM
(Select actor_id FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS') AS x);

	-- ID 172 changed back to GROUCHO
Select * FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
~~~

* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
~~~ mysql
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
~~~

* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
~~~ mysql
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;
~~~

* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
~~~ mysql
SELECT s.first_name, s.last_name, sum(p.amount) as "Total_Amount_Rung_Up"
FROM payment p
JOIN staff s
ON p.staff_id = s.staff_id
GROUP BY s.staff_id;
~~~

* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
~~~ mysql
SELECT f.film_id, f.title, count(fa.actor_id) as "Number_of_Actors"
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY fa.film_id;
~~~

* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
~~~ mysql
SELECT f.film_id, f.title, count(f.film_id) as "Number_of_Copy"
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = "HUNCHBACK IMPOSSIBLE"
GROUP BY f.film_id;
~~~

* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
~~~ mysql
SELECT c.first_name, c.last_name, sum(p.amount) as "Total amount paid"
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;
~~~

* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
~~~ mysql
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
~~~

* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
~~~ mysql
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
~~~

* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
~~~ mysql
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ct
ON a.city_id = ct.city_id
JOIN country cy
ON ct.country_id = cy.country_id
WHERE country = "CANADA";
~~~

* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
~~~ mysql
SELECT f.title as "Film Title", c.name as "Movie Type"
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = "Family";
~~~

* 7e. Display the most frequently rented movies in descending order.
~~~ mysql
SELECT f.title as "Movie", count(r.rental_id) as "Rent Times"
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY i.film_id
ORDER BY count(r.rental_id) DESC;
~~~

* 7f. Write a query to display how much business, in dollars, each store brought in.
~~~ mysql
SELECT s.store_id, sum(p.amount) as "Total_Revenue"
FROM store s
JOIN inventory i
ON s.store_id = i.store_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY s.store_id;
~~~

* 7g. Write a query to display for each store its store ID, city, and country.
~~~ mysql
SELECT s.store_id, c.city, ct.country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city c
ON a.city_id = c.city_id
JOIN country ct
ON c.country_id = ct.country_id;
~~~

* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
~~~ mysql
SELECT c.name as "Movie Genres", sum(p.amount) as "Gross Revenue"
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.category_id
ORDER BY sum(p.amount) DESC
LIMIT 5;
~~~

* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
~~~ mysql
CREATE VIEW `top_five_genres` 
AS SELECT c.name as "Movie Genres", sum(p.amount) as "Gross Revenue"
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.category_id
ORDER BY sum(p.amount) DESC
LIMIT 5;
~~~

* 8b. How would you display the view that you created in 8a?
~~~ mysql
SELECT * FROM `top_five_genres`;
~~~

* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
~~~ mysql
DROP VIEW `top_five_genres`;
~~~

