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
