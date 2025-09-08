-- creating the database 
CREATE DATABASE IF NOT EXISTS Nifty_data;

USE Nifty_data;
SELECT 
    *
FROM
    n50;
SELECT 
    *
FROM
    nn50;
SELECT 
    *
FROM
    nm100;

-- Modifying column Date from datetime to date

ALTER TABLE nm100 MODIFY DATE DATE;
ALTER TABLE nn50 MODIFY DATE DATE;
ALTER TABLE n50 MODIFY DATE DATE;

-- Creating a view with all 3 indices data

CREATE VIEW v1 AS
    SELECT 
        n1.date AS Date,
        n1.Close AS Nifty50,
        n2.Close AS NiftyNext50,
        n3.Close AS NiftyMidcap100
    FROM
        n50 n1
            INNER JOIN
        nn50 n2 ON n1.date = n2.date
            INNER JOIN
        nm100 n3 ON n2.date = n3.date;
        
SELECT 
    *
FROM
    v1;

/* Creating another table to calculate 5 YR rolling returns
We will add a new column that captures the date five years prior to the current date.
 This will serve as the reference point for calculating 5-year rolling returns.
*/

CREATE TABLE v2 AS SELECT n1.date AS curr_date,
    n1.Nifty50 AS curr_closeN50,
    MAX(n2.Nifty50) AS prev_closeN50,
    n1.NiftyNext50 AS curr_closeNN50,
    MAX(n2.NiftyNext50) AS prev_closeNN50,
    n1.NiftyMidcap100 AS curr_closeNM100,
    MAX(n2.NiftyMidcap100) AS prev_closeNM100 FROM
    v1 n1
        JOIN
    v1 n2 ON n2.date <= DATE_SUB(n1.date, INTERVAL 5 YEAR)
GROUP BY curr_date , curr_closeN50 , curr_closeNN50 , curr_closeNM100
ORDER BY curr_date;

SELECT 
    *
FROM
    v2;


-- 5 Yr Rolling Returns

SELECT 
    curr_date AS date,
    ROUND((curr_closeN50 / prev_closeN50 - 1) * 10,
            3) AS Nifty50,
    ROUND((curr_closeNN50 / prev_closeNN50 - 1) * 10,
            3) AS NiftyNext50,
    ROUND((curr_closeNM100 / prev_closeNM100 - 1) * 10,
            3) AS NiftyMidcap100
FROM
    v2
ORDER BY curr_date;

-- Daily Returns

SELECT * FROM (
SELECT date,
ROUND(((Nifty50 - LAG(Nifty50,1) OVER (ORDER BY date))/
LAG(Nifty50,1) OVER (ORDER BY date))*100,3) as Nifty50,
ROUND(((NiftyNext50 - LAG(NiftyNext50,1) OVER (ORDER BY date))/
LAG(NiftyNext50,1) OVER (ORDER BY date))*100,3) as NiftyNext50,
ROUND(((NiftyMidcap100 - LAG(NiftyMidcap100,1) OVER (ORDER BY date))
/LAG(NiftyMidcap100,1) OVER (ORDER BY date))*100,3) as NiftyMidcap100
FROM v1) AS oo
WHERE Nifty50 IS NOT NULL
ORDER BY date;

-- 5 YR Rolling Risk 

WITH v3 AS (
SELECT  date,
((Nifty50 - LAG(Nifty50,1) OVER (ORDER BY date))/LAG(Nifty50,1) OVER (ORDER BY date))*100 AS N50daily_returns,
((NiftyNext50 - LAG(NiftyNext50,1) OVER (ORDER BY date))/LAG(NiftyNext50,1) OVER (ORDER BY date))*100 AS NN50daily_returns,
((NiftyMidcap100 - LAG(NiftyMidcap100,1) OVER (ORDER BY date))/LAG(NiftyMidcap100,1) OVER (ORDER BY date))*100 AS NM100daily_returns
FROM v1
ORDER BY date)
SELECT e1.date,(
SELECT STDDEV_SAMP(e2.N50daily_returns)* SQRT(252)
FROM v3 e2
WHERE e2.date BETWEEN DATE_SUB(e1.date,INTERVAL 5 YEAR) AND e1.date) AS Nifty50,
(SELECT STDDEV_SAMP(e3.NN50daily_returns)* SQRT(252)
FROM v3 e3
WHERE e3.date BETWEEN DATE_SUB(e1.date,INTERVAL 5 YEAR) AND e1.date) AS NiftyNext50,
(SELECT STDDEV_SAMP(e4.NM100daily_returns)* SQRT(252)
FROM v3 e4
WHERE e4.date BETWEEN DATE_SUB(e1.date,INTERVAL 5 ) AND e1.date) AS NiftyMidcap100
FROM v3 e1
ORDER BY e1.date;

/* OR Alternate Method 
SELECT date,
STDDEV_SAMP((N50daily_returns)*SQRT(252))
OVER (ORDER BY date ROWS BETWEEN 1260 PRECEDING AND CURRENT ROW) AS Nifty50,
STDDEV_SAMP((NN50daily_returns)*SQRT(252)) 
OVER (ORDER BY date ROWS BETWEEN 1260 PRECEDING AND CURRENT ROW) AS NiftyNext50,
STDDEV_SAMP((NM100daily_returns)*SQRT(252))
OVER (ORDER BY date ROWS BETWEEN 1260 PRECEDING AND CURRENT ROW) AS NiftyMidcap100  
FROM v3;
*/


-- Drawdown (identifying peak value of index in subquery)

select date,ROUND((peak_n50-Nifty50)/Nifty50*100,2) AS Nifty50,
ROUND((peak_nn50-NiftyNext50)/NiftyNext50*100,2) AS NiftyNext50,
ROUND((peak_nm100-NiftyMidcap100)/NiftyMidcap100*100,2) AS NiftyMidcap100 FROM (
SELECT date,Nifty50,
MAX(Nifty50) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS peak_n50,
NiftyNext50,
MAX(NiftyNext50) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS peak_nn50,
NiftyMidcap100,
MAX(NiftyMidcap100) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS peak_nm100 FROM v1) AS d;
