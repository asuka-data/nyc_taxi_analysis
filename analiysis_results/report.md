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
Grasp the overall trend by analyzing total rides by day of week and hour

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

| Row | dow | hour | total_ride  |
|-----|-----|------|------------ |
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
- **Evening Peak Hours**: Between 5-7pm on Weekdays are the peak for taxi demands
- See more details in the file [heatmap.sql](sql/nyc_heatmap.sql)

### Popular Locations 
Compare locations by total rides and find popular locations

```sql
SELECT
  pickup_location_id,
  COUNT(pickup_location_id) AS total
FROM famous-cache-463121-g6.nyc_taxi.vw_cleaned
GROUP BY pickup_location_id
ORDER BY total DESC
LIMIT 10;

| Row | pickup_location_id | total    |
|-----|--------------------|--------- |
| 1   | 237                | 1678,029 |
| 2   | 132                | 1677,109 |
| 3   | 236                | 1493,435 |
| 4   | 161                | 1430,746 |
| 5   | 186                | 1169,058 |
| 6   | 162                | 1163,670 |
| 7   | 142                | 1161,036 |
| 8   | 170                | 1101,208 |
| 9   | 230                | 1099,473 |
| 10  | 48                 | 1088,336 |

```
#### Short summary
- **Concentration of demand**: The demand is highly concentrated in the top four locations
- **Standby Taxi**: For 237 and 132, there should be pooled some standby taxi for the immediate dispatch
  
### Comparison of Tip Rate by Day of Week and Hour
Calculated tip rate to figure out high revenue day of week and hours,

```sql
SELECT
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dow, -- 1= Sunday, ... 6= Saturday
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  SUM(tip_amount) AS total_tip,
  SUM(total_amount) AS total_sales,
  ROUND(AVG(tip_amount),4) AS avg_tips,
  ROUND(SAFE_DIVIDE(SUM(tip_amount), SUM(total_amount)),4) AS tip_rate
FROM famous-cache-463121-g6.nyc_taxi.vw_cleaned
GROUP BY dow, hour
ORDER BY tip_rate DESC
LIMIT 10;

| Row | dow | hour | avg_tips | tip_rate |
|-----|-----|------|----------|----------|
| 1   | 3   | 21   | 2.8144   | 0.1357   |
| 2   | 4   | 21   | 2.7982   | 0.1357   |
| 3   | 4   | 22   | 2.8984   | 0.1353   |
| 4   | 5   | 21   | 2.7885   | 0.1347   |
| 5   | 5   | 22   | 2.8925   | 0.1347   |
| 6   | 3   | 20   | 2.7058   | 0.1344   |
| 7   | 4   | 20   | 2.7081   | 0.1342   |
| 8   | 3   | 22   | 2.9006   | 0.1341   |
| 9   | 2   | 21   | 2.8773   | 0.1335   |
| 10  | 5   | 20   | 2.7049   | 0.1327   |

```
#### Short summary
- **NIght hours**: The tip rate gets higher between 8-10pm

## 4. Summary
- Consider stable dispach for the peak hours and locations
- Decrease the number of standby taxi for the low demand hours
