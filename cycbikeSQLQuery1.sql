select * from t01$

ALTER table t01$
Alter column start_station_id nvarchar(255)

ALTER table t01$
Alter column end_station_id nvarchar(255)

ALTER table t02$
Alter column end_station_id nvarchar(255)

INSERT INTO t01$
SELECT * FROM t02$

INSERT INTO t01$
SELECT * FROM t03$

ALTER table t04$
Alter column start_station_id nvarchar(255)

ALTER table t04$
Alter column end_station_id nvarchar(255)

INSERT INTO t01$
SELECT * FROM t04$

ALTER table t05$
Alter column end_station_id nvarchar(255)

INSERT INTO t01$
SELECT * FROM t05$

INSERT INTO t01$
SELECT * FROM t06$

INSERT INTO t01$
SELECT * FROM t07$

INSERT INTO t01$
SELECT * FROM t08$

INSERT INTO t01$
SELECT * FROM t09$

ALTER table t10$
Alter column start_station_id nvarchar(255)

INSERT INTO t01$
SELECT * FROM t10$

INSERT INTO t01$
SELECT * FROM t11$

INSERT INTO t01$
SELECT * FROM t12$

SELECT * FROM t01$

--After merging the data into TABLE t01$, the table was renamed to bikerides$
--Then the other tables (t02$ - t12$ were dropped)


DROP TABLE IF EXISTS t02$,t03$,t04$,t05$,t06$,t07$,t08$,t09$,t10$,t11$,t12$;

--Let's see what we have left in the database

SHOW TABLES --This didn't work because I didn't have the PROCEDURE set.

SELECT * FROM INFORMATION_SCHEMA.TABLES

--Let's check the number of records in TABLE bikeride$

SELECT COUNT(*) FROM bikerides$;

--Let's preview the records in the table bikerides$

SELECT * FROM bikerides$;

--Now Let's check for duplicate records in the table( here, the search will be based on the ride_id column)

SELECT ride_id, COUNT(ride_id)
FROM bikerides$
GROUP BY ride_id
HAVING COUNT(ride_id) > 1;


--The result shows that five ride_id (2.58E+97, 8.16E+30. 5.27E+19, 1.56E+21 and 5.63E+14) have duplicates.
--Let's remove the duplicates


DELETE FROM bikerides$
WHERE
	ride_id IN (
				SELECT ride_id
				FROM (
						SELECT ride_id, ROW_NUMBER() OVER (
													 PARTITION BY ride_id
													 ORDER BY ride_id) AS row_num
						FROM bikerides$
					 ) b
			WHERE row_num > 1
			);

--The outcome was successfull, but 10 rows were affected, now I don't know what happened because only 5 rows should be affected.ARRRGH!!

--Let's preview the table again

SELECT * FROM bikerides$;

--There are 12 columns in the table but i'd like to create additional columns to make it easy to carry out my analysis
--These new columns are:
--ride_length( the interval between the started_at and ended_at) in minutes
--day_of_week(the day of the week that each ride started)
--started_hour(the hour of the day that the ride started)
--day_of_month(the day of the month that the ride started)
--ride_status


--Let's filter the content of columns that are key to the analysis

SELECT DISTINCT(rideable_type) FROM bikerides$;

SELECT DISTINCT(rideable_type), COUNT(rideable_type)rt_number 
FROM bikerides$
GROUP BY rideable_type;

----There are three rideable_type: electric_bike, classic_bike and docked_bike

SELECT DISTINCT(member_casual) FROM bikerides$;

SELECT DISTINCT(member_casual), COUNT(member_casual)
FROM bikerides$
GROUP BY member_casual;

----There are two memberships in the record: casual, member

--I'll use the DATEDIFF function to create the ride_length column as shown below

SELECT * FROM bikerides$
WHERE started_at IS NULL 
OR ended_at IS NULL;

SELECT started_at, ended_at,DATEDIFF(MINUTE,started_at,ended_at) as ride_length
FROM bikerides$;

--To obtain the day_of_week

SELECT DATENAME(DW,CAST(started_at as date)) as day_of_week
FROM bikerides$;

--To obtain the started_hour

SELECT DATEPART(HOUR,started_at) as started_hour
FROM bikerides$;

SELECT DISTINCT(DATEPART(HOUR,started_at)) as started_hour
FROM bikerides$;

SELECT DATENAME(HOUR,started_at) as started_hour
FROM bikerides$;

SELECT DISTINCT(DATENAME(HOUR,started_at)) as started_hour
FROM bikerides$;

--To obtain the day_of_month

SELECT DATEPART(DD,started_at) as day_of_month
FROM bikerides$;

SELECT DISTINCT(DATEPART(DD,started_at)) as day_of_month
FROM bikerides$;

--To determine the ride status


WITH duration AS
(SELECT DATEDIFF(MINUTE,started_at, ended_at)as ride_length
FROM bikerides$)
SELECT ride_length,
	CASE 
		WHEN ride_length < 1 THEN 'False Start'
		WHEN ride_length > 1440 THEN 'Stolen'
		WHEN ride_length BETWEEN 1 AND 1440 THEN 'Good Ride'
		ELSE 'SpecialCase'
	END ride_status
FROM duration;

/*SELECT ride_status, COUNT(ride_length)
FROM duration
GROUP BY ride_status*/

--Adding a new column (ride_status) to the table

--Creating a view for the analysis

CREATE VIEW cycbike AS
	SELECT ride_id, rideable_type,DATEDIFF(MINUTE,started_at,ended_at) as ride_length,
	DATENAME(DW,CAST(started_at as date)) as day_of_week,
	DATEPART(HOUR,started_at) as started_hour,
	DATEPART(DD,started_at) as day_of_month,
	start_station_name, end_station_name, member_casual
FROM bikerides$;
-- To see the VIEW
SELECT * FROM cycbike;

--To see the number of rides per category
SELECT member_casual, COUNT(*)total_rides
FROM cycbike
GROUP BY member_casual;


--To see the number of rides and average length of rides per day_of_week
SELECT COUNT(ride_id)number_of_dayRides, ROUND(AVG(ride_length),2)average_dayRide_length, day_of_week
FROM cycbike
GROUP BY day_of_week
--HAVING member_casual='member';


--To see the top 10 stations with the highest startRides
SELECT TOP 10 start_station_name, COUNT(*)number_of_startRides
FROM cycbike
GROUP BY start_station_name
ORDER BY COUNT(*) DESC;

--To see the top 10 stations with the highest endRides
SELECT TOP 10 end_station_name, COUNT(*)number_of_endRides
FROM cycbike
GROUP BY end_station_name
ORDER BY COUNT(*) DESC;


--To see the number of rides, average length of rides started at different hours of the day
SELECT COUNT(ride_id)num_hourlyRides, AVG(ride_length)avgLength_hourlyRides, started_hour
FROM cycbike
GROUP BY started_hour
ORDER BY started_hour;


--To see the category, rideable type and the number of rides
SELECT member_casual,rideable_type, COUNT(*)total_rides
FROM cycbike
GROUP BY GROUPING SETS(ROLLUP(member_casual,rideable_type))

SELECT member_casual,rideable_type, COUNT(*)total_rides
FROM cycbike
GROUP BY ROLLUP(member_casual,rideable_type)

SELECT rideable_type, COUNT(*)total_rides
FROM cycbike
GROUP BY rideable_type;

SELECT day_of_week, 