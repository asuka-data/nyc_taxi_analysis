## NYC Taxi Data Cleaning & Analysis

## 1. Data Preperation
- Review the data required for analysis 
- Review data structures and ranges
- Define cleaning rules

## 2. Data Cleaning Steps
- Excluded negative fares: `fare_amount` < 1
- Excluded unusually high fares: `fare_amount` > 200
- Excluded no trip data: `trip_distance` = 0
- Excluded input error: `tip_amount` < 0

## 3. Data Exploration Summary
### Data Volume
- Total Rows: ** **

### Data Range
- 2001_

### Total Ride Count by day of week and hour

```sql
 SELECT
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dow, -- 1= Sunday, ... 6= Saturday
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  COUNT(*) AS total_ride
 FROM bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022
 WHERE fare_amount BETWEEN 1 AND 200   -- Remove invalid and input error data
      AND trip_distance > 0
      AND tip_amount >= 0
 GROUP BY dow, hour
 ORDER BY total_ride DESC
 LIMIT 10;

| Row | dow | hour | total_ride |
|-----|-----|------|------------|
| 1   | 3   | 18   | 398,211     |
| 2   | 4   | 18   | 396,831     |
| 3   | 5   | 18   | 394,306     |
| 4   | 6   | 18   | 386,214     |
| 5   | 3   | 17   | 372,776     |
| 6   | 4   | 17   | 371,989     |
| 7   | 6   | 19   | 368,439     |
| 8   | 5   | 17   | 365,833     |
| 9   | 4   | 19   | 359,585     |
| 10  | 6   | 17   | 357,422     |

```
#### Short summary
