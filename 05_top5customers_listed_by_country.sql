-- Find out how many of the top 5 customers are based within each country.
-- Your final output should include 3 columns:
--  “country”
-- “all_customer_count” with the total number of customers in each country
-- “top_customer_count” showing how many of the top 5 customers live in each country
--
-- NOTE: the approach taken is to create 2 tables (LEFT & RIGHT) to perform a JOIN of those intermediate results
-- 
SELECT left_table.country_name, all_customer_count, top_customer_count
FROM  	   (SELECT  country.country_id, country.country AS country_name,
			COUNT(DISTINCT customer.customer_id) AS all_customer_count
		FROM customer
		INNER JOIN address USING(address_id)
		INNER JOIN city USING(city_id)
		INNER JOIN country USING(country_id)
		GROUP BY country_id, country_name 
    ) AS left_table
LEFT JOIN (SELECT country_id, country_name, COUNT(DISTINCT top5_customer_id) as top_customer_count
	     FROM (SELECT	ctry.country_id, ctry.country AS country_name, 
		 	cust.customer_id AS top5_customer_id, SUM(pmt.amount) AS total_amount_paid
			 FROM customer AS cust
			 INNER JOIN payment as pmt 	USING(customer_id)
			 INNER JOIN address AS addr	USING(address_id)
			 INNER JOIN city AS city	USING(city_id)
			 INNER JOIN country AS ctry	USING(country_id)
			 WHERE city_id IN (42,51,386,190,350,554,552,426,278,550)
			 GROUP BY customer_id, country_id, country, city
			 ORDER BY total_amount_paid DESC
			 LIMIT 5 ) AS top5_customers
	     GROUP BY country_id, country_name
    ) AS right_table
USING(country_id)
ORDER BY top_customer_count ASC
