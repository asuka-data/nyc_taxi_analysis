-- Analyze demand by day of the week and hour
SELECT
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dow, -- 1= Sunday, ... 6= Saturday
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  COUNT(*) AS total_ride
FROM bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022
WHERE fare_amount BETWEEN 1 AND 200   -- Remove invalid and input error data
      AND trip_distance > 0
      AND tip_amount >= 0
GROUP BY dow, hour
ORDER BY dow, hour;


-- Created cleaned VIEW that reflected cleaning data conditions
CREATE OR REPLACE VIEW famous-cache-463121-g6.nyc_taxi.vw_cleaned AS
  SELECT
    *
  FROM bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022
  WHERE fare_amount BETWEEN 1 AND 200 
      AND trip_distance > 0
      AND tip_amount >= 0;


-- Analyze Top 5 pick up locations by day of the week and hour
WITH location AS(
  SELECT
   EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dow, -- 1= Sunday, ... 6= Saturday
   EXTRACT(HOUR FROM pickup_datetime) AS hour,
   pickup_location_id,
   COUNT(pickup_location_id) AS ride_total
  FROM famous-cache-463121-g6.nyc_taxi.vw_cleaned
  GROUP BY dow, hour, pickup_location_id
  ORDER BY dow, hour
)
SELECT
  dow,
  hour,
  pickup_location_id,
  ride_total,
  RANK()OVER(PARTITION BY dow, hour ORDER BY ride_total DESC) AS rank
FROM location
QUALIFY rank <= 5
ORDER BY dow, hour, rank;
