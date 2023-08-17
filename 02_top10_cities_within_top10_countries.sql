-- Find the top 10 cities within the top 10 countries identified in former query
--
SELECT city.city, COUNT(customer_id) AS num_customers
FROM city 
INNER JOIN	( --generate a set of CUSTOMER - CITY
			SELECT customer_id, city_id
			FROM customer
			INNER JOIN address
			USING(address_id)
			) AS customer_city
USING(city_id)
WHERE city.country_id IN (44, 23, 103, 50, 60, 80, 15, 75, 97, 45) --top 10 countries
GROUP BY city
ORDER BY num_customers DESC
LIMIT 10;
