--
--
--
SELECT ROUND(AVG(total_amount_paid),2) AS avg_payment_top5_customers
FROM	(SELECT cust.customer_id, cust.first_name, cust.last_name,
		 	ctry.country, city.city, SUM(pmt.amount) AS total_amount_paid
		 FROM customer AS cust
		 INNER JOIN payment AS pmt	USING(customer_id)
		 INNER JOIN address AS addr	USING(address_id)
		 INNER JOIN city AS city	USING(city_id)
		 INNER JOIN country AS ctry	USING(country_id)
		 WHERE city_id IN(42,51,386,190,350,554,552,426,278,550)
		 GROUP BY customer_id, first_name, last_name, country, city
		 ORDER BY total_amount_paid DESC
		 LIMIT 5
	  ) AS top5_average
