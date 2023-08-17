-- find the countries where top5 customers live in
-- this is a rewrite of query # 5 using Common Table Expressions (CTEs)
-- 
WITH city_country AS (
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
	),
top5_payers AS (
	SELECT customer_id, city_id, total_amount
	FROM customer_address_amount
	WHERE city_id IN (SELECT city_id FROM top10_cities)
	ORDER BY total_amount DESC LIMIT 5
	),
country_allcounts AS (
	SELECT 	country.country_id, country.country AS country_name,
			COUNT(DISTINCT customer.customer_id) AS all_customer_count
	FROM customer
	INNER JOIN address USING(address_id)
	INNER JOIN city USING(city_id)
	INNER JOIN country USING(country_id)
	GROUP BY country_id, country_name 
    ),
country_top5count AS (
	SELECT country_id, country_name, 
		COUNT(top5_customer_id) as top_customer_count
	FROM (SELECT ctry.country_id, ctry.country AS country_name, 
				cust.customer_id AS top5_customer_id, 
		  		SUM(pmt.amount) AS total_amount_paid
		   FROM customer AS cust
		   INNER JOIN payment as pmt 	USING(customer_id)
		   INNER JOIN address AS addr	USING(address_id)
		   INNER JOIN city AS city	USING(city_id)
		   INNER JOIN country AS ctry	USING(country_id)
		   WHERE city_id IN (SELECT city_id FROM top10_cities)
		   GROUP BY customer_id, country_id, country, city
		   ORDER BY total_amount_paid DESC
		   LIMIT 5 ) AS top5_customers
	     GROUP BY country_id, country_name
    )

SELECT c_all.country_name, all_customer_count, top_customer_count
FROM country_allcounts AS c_all
LEFT JOIN country_top5count AS c_top
USING(country_id)
ORDER BY top_customer_count ASC;
