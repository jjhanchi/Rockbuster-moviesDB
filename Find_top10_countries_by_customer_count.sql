--
-- find the top 10 countries for Rockbuster in terms of customer numbers
-- 
SELECT ctry_id, country_name, COUNT(customer_id) AS num_customers
FROM -- generate a set of COUNTRY-CITIES
	( SELECT DISTINCT c2.country_id AS ctry_id, c2.country AS country_name, c1.city_id
	  FROM city AS c1
	  INNER JOIN country AS c2
	  USING(country_id)
	 ) AS country_city
INNER JOIN -- generate a set of CITY vs CUSTOMER 
	( SELECT DISTINCT city_id, customer_id
	  FROM customer
	  INNER JOIN address
	  USING(address_id)
	 ) AS customer_city
USING( city_id ) -- join country-cities AND city-customer
GROUP BY ctry_id, country_name
ORDER BY num_customers DESC
LIMIT 10;
