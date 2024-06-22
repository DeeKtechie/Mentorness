-- Q1. Write a code to check NULL values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN province IS NULL THEN 1 ELSE 0 END) AS null_province,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) AS null_latitude,
    SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS null_longitude,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN confirmed IS NULL THEN 1 ELSE 0 END) AS null_confirmed,
    SUM(CASE WHEN deaths IS NULL THEN 1 ELSE 0 END) AS null_deaths,
    SUM(CASE WHEN recovered IS NULL THEN 1 ELSE 0 END) AS null_recovered
FROM 
	corona_virus
;

-- Q2. If NULL values are present, update them with zeros for all columns.
UPDATE corona_virus
SET 
    province = COALESCE(province, 'Unknown'),
    country = COALESCE(country, 'Unknown'),
    latitude = COALESCE(latitude, 0),
    longitude = COALESCE(longitude, 0),
    date = COALESCE(date, '1970-01-01'),
    confirmed = COALESCE(confirmed, 0),
    deaths = COALESCE(deaths, 0),
    recovered = COALESCE(recovered, 0)
;

-- Q3. Check total number of rows
SELECT
	COUNT(*) AS total_rows
FROM 
	corona_virus
;

-- Q4. Check what is start_date and end_date
SELECT 
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM 
	corona_virus
;

-- Q5. Number of months present in dataset
SELECT 
    COUNT(DISTINCT TO_CHAR(date, 'YYYY-MM')) AS no_of_months
FROM 
    corona_virus
;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    COUNT(DISTINCT TO_CHAR(date, 'YYYY-MM')) AS no_of_months,
	ROUND(AVG(confirmed),2) AS avg_confirmed,
    ROUND(AVG(deaths),2) AS avg_deaths,
    ROUND(AVG(recovered),2) AS avg_recovered
FROM 
    corona_virus
;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month
SELECT 
    month,
    confirmed,
    deaths,
    recovered
FROM (
    SELECT 
        TO_CHAR(date, 'YYYY-MM') AS month,
        confirmed,
        deaths,
        recovered,
        ROW_NUMBER() OVER (PARTITION BY TO_CHAR(date, 'YYYY-MM') ORDER BY COUNT(*) DESC) AS rank
    FROM corona_virus
    GROUP BY month, confirmed, deaths, recovered
) AS ranked
WHERE 
	rank = 1
;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    MIN(confirmed) AS min_confirmed,
    MIN(deaths) AS min_deaths,
    MIN(recovered) AS min_recovered
FROM corona_virus
GROUP BY 
	year
ORDER BY
	year
;


-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    MAX(confirmed) AS max_confirmed,
    MAX(deaths) AS max_deaths,
    MAX(recovered) AS max_recovered
FROM
	corona_virus
GROUP BY
	year
ORDER BY
	year
;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    TO_CHAR(date, 'YYYY-MM') AS month,
    SUM(confirmed) AS total_confirmed,
    SUM(deaths) AS total_deaths,
    SUM(recovered) AS total_recovered
FROM
	corona_virus
GROUP BY
	month
ORDER BY
	month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(confirmed) AS total_confirmed,
    ROUND(AVG(confirmed),2) AS avg_confirmed,
    ROUND(VARIANCE(confirmed),2) AS var_confirmed,
    ROUND(STDDEV(confirmed),2) AS stdev_confirmed
FROM 
	corona_virus
;


-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    TO_CHAR(date, 'YYYY-MM') AS month,
    ROUND(SUM(deaths),2) AS total_deaths,
    ROUND(AVG(deaths),2) AS avg_deaths,
    ROUND(VARIANCE(deaths),2) AS var_deaths,
    ROUND(STDDEV(deaths),2) AS stdev_deaths
FROM corona_virus
GROUP BY 
	month
ORDER BY
	month
;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    ROUND(SUM(recovered),2) AS total_recovered,
    ROUND(AVG(recovered),2) AS avg_recovered,
    ROUND(VARIANCE(recovered),2) AS var_recovered,
    ROUND(STDDEV(recovered),2) AS stdev_recovered
FROM 
	corona_virus
;

-- Q14. Find Country having highest number of the Confirmed case
SELECT 
    country,
    SUM(confirmed) AS total_confirmed
FROM 
	corona_virus
GROUP BY
	country
ORDER BY
	total_confirmed DESC
LIMIT 1
;

-- Q15. Find Country having lowest number of the death case
SELECT 
    country,
    SUM(deaths) AS total_deaths
FROM 
	corona_virus
GROUP BY
	country
ORDER BY
	total_deaths ASC
LIMIT 1;

-- Q16. Find top 5 countries having highest recovered case
SELECT 
    country,
    SUM(recovered) AS total_recovered
FROM corona_virus
GROUP BY 
	country
ORDER BY 
	total_recovered DESC
LIMIT 5
;
