-- Find the average of the top 5 customers (from top 10 cities)
-- rewrite of query # 05 using Common Table Expressions
--
WITH 
city_country AS (
	SELECT country_id, city_id, country AS country_name, city AS city_name
	FROM city INNER JOIN country
	USING(country_id)
	),
city_customer AS (
	SELECT city_id, customer_id, customer.address_id
	FROM customer INNER JOIN address
	USING(address_id)
	),
top10_countries AS ( 
	--JOINs prior two CTEs to find top10 countries by num_customers
	SELECT country_id, COUNT(customer_id) AS num_customers
	FROM city_country INNER JOIN city_customer USING(city_id)
	GROUP BY country_id
	ORDER BY num_customers DESC
	LIMIT 10
	),
top10_cities AS ( 
	--uses top10_countries in WHERE filter
	SELECT city_id, COUNT(customer_id) AS num_cust
	FROM city INNER JOIN city_customer USING(city_id)
	WHERE city.country_id IN (SELECT country_id FROM top10_countries)
	GROUP BY city_id ORDER BY num_cust DESC
	LIMIT 10
	),
customer_address_amount AS ( 
	--list of customer + address + total paid by customer
	SELECT customer_id, address_id, city_id, SUM(amount)	AS total_amount
	FROM customer
	INNER JOIN payment USING(customer_id)
	INNER JOIN address USING(address_id)
	GROUP BY customer_id, address_id
	)
SELECT	ROUND(AVG(total_amount),2)      -- average of top5_payers
	
FROM	(SELECT city_id, total_amount
		 FROM customer_address_amount
		 WHERE city_id IN (SELECT city_id FROM top10_cities)
		 ORDER BY total_amount DESC LIMIT 5
		) AS top5_payers;
