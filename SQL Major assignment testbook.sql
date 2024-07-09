
-- Creating Station table for the Project

CREATE TABLE IF NOT EXISTS Station (
ID INT PRIMARY KEY,
CITY VARCHAR(50) NOT NULL,
STATE VARCHAR(2) NOT NULL,
LAT_N FLOAT NOT NULL,
LONG_W FLOAT NOT NULL
);


-- Filling Data

INSERT INTO Station (ID, CITY, STATE, LAT_N, LONG_W)
VALUES
(13, 'PHOENIX', 'AZ', 33, 112),
(44, 'DENVER', 'CO', 40, 105),
(66, 'CARIBOU', 'ME', 47, 68);

-- Showing Data

SELECT * FROM station;

-- Q) Execute a query to select Northern stations (Northern latitude > 39.7).

SELECT *
FROM station
WHERE lat_n > 39.7;

-- Q) Create another table, ‘STATS’, to store normalized temperature and precipitation data:

CREATE TABLE IF NOT EXISTS Stats (
ID INT,
MONTH INT NOT NULL,
TEMP_F FLOAT NOT NULL,
RAIN_I FLOAT NOT NULL,
FOREIGN KEY (ID) REFERENCES Station(ID)
);	
	
-- Q) Populate the table STATS with some statistics for January and July:

INSERT INTO Stats (ID, MONTH, TEMP_F, RAIN_I)
VALUES
(13, 1, 57.4, 0.31),
(13, 7, 91.7, 5.15),
(44, 1, 27.3, 0.18),
(44, 7, 74.8, 2.11),
(66, 1, 6.7, 2.1),
(66, 7, 65.8, 4.52);

-- Q) Execute a query to display temperature stats (from the STATS table) for each city (from the STATION table).

SELECT S.CITY, AVG(ST.TEMP_F) AS AVG_TEMPERATURE,
MIN(ST.TEMP_F) AS MIN_TEMPERATURE,
MAX(ST.TEMP_F) AS MAX_TEMPERATURE
FROM
Station S
JOIN
Stats ST ON S.ID = ST.ID
GROUP BY S.CITY;

-- NOTE: I have created a temporary table Using CTE named “Temp_month_name” for month names to show the names correctly. Here is the code for that.

CREATE TEMPORARY TABLE IF NOT EXISTS temp_month_name AS
WITH month_name AS(
SELECT DISTINCT month, TO_CHAR(TO_DATE(CONCAT('2023-',
month, '-01'), 'YYYY-MM-DD'), 'Month') AS M_name
FROM stats
)
SELECT * FROM month_name;
SELECT * FROM temp_month_name;

-- Q) Execute a query to look at the table STATS, ordered by month and greatest rainfall, with columns rearranged. It should also show the corresponding cities.

SELECT s.city, m.m_name AS month, st.temp_f, st.rain_i
FROM stats AS st
JOIN station AS s
ON st.id = s.id
JOIN temp_month_name AS m
ON st.month = m.month
ORDER BY month, rain_i DESC;

-- Q) Execute a query to look at temperatures for July from table STATS, lowest temperatures first, picking up city name and latitude.

SELECT S.CITY, M.m_name AS month, S.LAT_N, ST.TEMP_F
FROM Stats AS ST
JOIN Station AS S
ON ST.ID = S.ID
JOIN temp_month_name AS M
ON ST.month = M.month
WHERE ST.MONTH = 7
ORDER BY ST.TEMP_F;

-- Q10) Execute a query to show MAX and MIN temperatures as well as average rainfall for each city.

SELECT 
    S.CITY,
    ROUND(MAX(ST.TEMP_F)::numeric, 2) AS MAX_TEMPERATURE,
    ROUND(MIN(ST.TEMP_F)::numeric, 2) AS MIN_TEMPERATURE,
    ROUND(AVG(ST.RAIN_I)::numeric, 2) AS AVG_RAINFALL
FROM Station AS S
JOIN Stats AS ST ON S.ID = ST.ID
GROUP BY S.CITY;


-- Q11) Execute a query to display each city’s monthly temperature in Celsius and rainfall in Centimeter.

SELECT
S.CITY,
M.m_name AS MONTH,
CONCAT(ROUND(((ST.TEMP_F - 32) * 5/9)::numeric, 2), ' °C') AS
TEMPERATURE_CELSIUS,
CONCAT(ROUND((ST.RAIN_I * 2.54)::numeric, 2), ' cm') AS
RAINFALL_CENTIMETER
FROM Stats ST
JOIN Station S ON ST.ID = S.ID
JOIN temp_month_name M ON ST.MONTH = M.month
ORDER BY s.id;

-- Q) Update all rows of table STATS to compensate for faulty rain gauges known to read 0.01 inches low.

UPDATE Stats
SET RAIN_I = RAIN_I + 0.01;

-- Q) Update Denver's July temperature reading as 74.9.

UPDATE Stats
SET TEMP_F = 74.9
WHERE ID = (SELECT ID FROM Station WHERE CITY = 'DENVER')
AND MONTH = 7;
s
-- DROP TABLE station;










