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

-- Analyze average tips, total amount and total length by day of the week and hour
SELECT
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dow, -- 1= Sunday, ... 6= Saturday
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  ROUND(AVG(tip_amount),4) AS avg_tips,
  ROUND(AVG(total_amount),4) AS avg_amount,
  ROUND(AVG(trip_distance),4) AS avg_lenghth
FROM famous-cache-463121-g6.nyc_taxi.vw_cleaned
GROUP BY dow, hour
ORDER BY dow, hour;

-- Analyze tip rate by by day of the week and hour
SELECT
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dow, -- 1= Sunday, ... 6= Saturday
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  SUM(tip_amount) AS total_tip,
  SUM(total_amount) AS total_sales,
  ROUND(AVG(tip_amount),4) AS avg_tips,
  ROUND(SAFE_DIVIDE(SUM(tip_amount), SUM(total_amount)),4) AS tip_rate
FROM famous-cache-463121-g6.nyc_taxi.vw_cleaned
GROUP BY dow, hour
ORDER BY dow, hour;
