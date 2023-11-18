select
	arrival_date_year,
	hotel,
	round(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr)::numeric,2) AS revenue 
FROM hotels
GROUP BY arrival_date_year, hotel
ORDER BY 
	hotel, 
	revenue ASC

WITH hotels as(
SELECT * FROM "2018"
UNION ALL
SELECT * FROM "2019"
UNION ALL
SELECT * FROM "2020")

SELECT hotels.*, meal_cost.cost, market_segment.discount
FROM hotels
LEFT JOIN "market_segment"
ON hotels.market_segment = market_segment.market_segment
LEFT JOIN "meal_cost"
ON hotels.meal = meal_cost.meal