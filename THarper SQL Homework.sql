USE sakila;

-- finished Question 1a 
SELECT first_name, last_name
FROM actor;

-- finished Question 1b Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT first_name, last_name
FROM actor;

-- finished Question 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT * FROM actor
WHERE first_name = "Joe";

-- finished Question 2b. Find all actors whose last name contain the letters `GEN'
SELECT * FROM actor
WHERE last_name LIKE "%GEN%";

-- Question 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY
    last_name DESC,
    first_name;

-- finished Question 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country, country_id
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- finished Question 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD description blob;

-- finished Question 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP description;

-- finished Question 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- reference:  https://www.w3resource.com/mysql/aggregate-functions-and-grouping/aggregate-functions-and-grouping-count-with-group-by.php

-- finished Question 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2;


-- finished Question 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor
SET 
	first_name = 'HARPO'
WHERE
	actor_id = 172;

-- finished Question 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor
SET 
	first_name = 'GROUCHO'
WHERE
	actor_id = 172;

-- finished Question 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
DESCRIBE address;

-- * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)

-- finished Question 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`. The address_id is how the 2 tables are related.  This is an INNER JOIN.

SELECT first_name, last_name, address

FROM staff s JOIN address a ON s.address_id = a.address_id;


-- finished Question 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT first_name, last_name, SUM(amount)

FROM staff s JOIN payment p ON s.staff_id = p.staff_id
WHERE p.payment_date BETWEEN "2005-08-01" AND "2005-08-31"
GROUP BY p.staff_id;


-- finishedQuestion 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title, COUNT(actor_id)
FROM film AS f
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
GROUP BY title;

-- finished Question 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, COUNT(inventory_id)
FROM film f
JOIN inventory i ON i.film_id=f.film_id
WHERE title = 'Hunchback Impossible';

--  finished Question 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
-- ![Total amount paid](Images/total_payment.png)

SELECT first_name, last_name, SUM(amount)
FROM payment AS p
JOIN customer AS c ON p.customer_id = c.customer_id
GROUP BY c.last_name;

-- finished Question 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title, film_id
FROM film f
WHERE title LIKE 'K%' 
OR title LIKE 'Q%'
AND language_id=1;


-- finished Question 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
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
   WHERE title = 'ALONE TRIP'
  )
);

-- Question 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email, country
FROM customer AS c 
JOIN address AS a ON c.address_id = a.address_id
JOIN city AS t ON a.city_id = t.city_id
JOIN country AS co ON t.country_id = co.country_id
WHERE country = 'CANADA';

-- finished Question 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT f.title, f.film_id, c.category_id, t.name
FROM film AS f
INNER JOIN film_category AS c ON f.film_id = c.film_id
INNER JOIN category AS t ON t.category_id = c.category_id
WHERE t.name = 'Family';

-- finished Question 7e. Display the most frequently rented movies in descending order.
        
SELECT i.inventory_id, f.title, COUNT(rental_id)
FROM rental AS r
JOIN inventory AS i ON (r.inventory_id = i.inventory_id)
JOIN film AS f ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY COUNT(rental_id) DESC;

-- finished Question 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(amount)
FROM  payment As p
JOIN rental As r ON r.rental_id = p.rental_id
JOIN inventory As i ON i.inventory_id = r.inventory_id
JOIN store As s ON s.store_id = i.store_id
GROUP BY s.store_id;

-- finished Question 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, t.city, c.country
FROM  store As s
JOIN address As a  ON a.address_id = s.address_id
JOIN city As t On t.city_id = a.city_id
JOIN country As c ON c.country_id = t.country_id
GROUP BY s.store_id;

-- finished Question 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name
FROM category AS c
JOIN film_category AS f ON f.category_id = c.category_id
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
JOIN payment AS p ON p.rental_id =r.rental_id
GROUP BY name
ORDER BY SUM(p.amount)DESC
LIMIT 5;

-- finished Question 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
SELECT c.name, SUM(amount)
FROM category AS c
JOIN film_category AS f ON f.category_id = c.category_id
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
JOIN payment AS p ON p.rental_id =r.rental_id
GROUP BY name
ORDER BY SUM(p.amount)DESC
LIMIT 5;

-- finished Question 8b. How would you display the view that you created in 8a?
CREATE VIEW top_five_genres AS
SELECT c.name, SUM(amount)
FROM category AS c
JOIN film_category AS f ON f.category_id = c.category_id
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r ON r.inventory_id = i.inventory_id
JOIN payment AS p ON p.rental_id =r.rental_id
GROUP BY name
ORDER BY SUM(p.amount)DESC
LIMIT 5;

-- finished Question 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP view top_five_genres