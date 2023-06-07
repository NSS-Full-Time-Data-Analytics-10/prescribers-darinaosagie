--TOP 4 

WITH apple AS (SELECT DISTINCT name, price::money AS a_price, rating AS a_rating, content_rating AS a_content_rating, 
			   primary_genre AS a_genre
			   FROM app_store_apps), 
	 play AS  (SELECT DISTINCT name, price::money AS p_price, rating AS p_rating, content_rating AS p_content_rating, 
			   genres AS p_genre
			   FROM play_store_apps)
SELECT *
FROM apple 
	INNER JOIN play
	USING(name)
WHERE a_price = '$0.00' 
	AND p_price = '$0.00'
	AND name LIKE 'Airbnb'OR name LIKE 'Uber' OR name LIKE 'Instagram' OR name LIKE 'DoorDash - Food Delivery'