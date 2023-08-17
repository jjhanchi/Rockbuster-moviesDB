-- find the top 5 customers in the top 10 cities who have paid the highest total amounts to Rockbuster
-- The customer team would like to reward them for their loyalty
-- 
SELECT	cust.customer_id, cust.first_name, cust.last_name,
	ctry.country, city.city,
	SUM(pmt.amount) AS total_amount_paid
FROM customer AS cust
INNER JOIN payment as pmt 	USING(customer_id)
INNER JOIN address AS addr	USING(address_id)
INNER JOIN city AS city	USING(city_id)
INNER JOIN country AS ctry	USING(country_id)
WHERE city_id IN (42,51,386,190,350,554,552,426,278,550)
GROUP BY customer_id, first_name, last_name, country, city
ORDER BY total_amount_paid DESC
LIMIT 5;
