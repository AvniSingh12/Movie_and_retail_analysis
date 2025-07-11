-- 1. Create Database and Table
CREATE DATABASE retail_data;
USE retail_data;

DROP TABLE IF EXISTS online_retail_clean;
CREATE TABLE online_retail_clean (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID VARCHAR(20),
    Country VARCHAR(50),
    TotalPrice DECIMAL(12, 2)
);

-- 2. Load CSV (Optional or import via Table Data Import wizard)
-- SET GLOBAL local_infile = 1;
-- LOAD DATA LOCAL INFILE "C:\Users\avnis\OneDrive\Documents\ELEVATE JOBS\Retail-Analysis-Project\output\online_retail_clean.csv"
-- INTO TABLE online_retail_clean
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- 3. Top 10 Profitable Products
SELECT Description, SUM(TotalPrice) AS Revenue
FROM online_retail_clean
GROUP BY Description
ORDER BY Revenue DESC
LIMIT 10;

-- 4. Country-wise Revenue
SELECT Country, SUM(TotalPrice) AS Revenue
FROM online_retail_clean
GROUP BY Country
ORDER BY Revenue DESC;

-- 5. Monthly Revenue 
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, SUM(TotalPrice) AS Revenue
FROM online_retail_clean
GROUP BY Month
ORDER BY Month;

-- 6. Bottom 10 Low-Revenue Products
SELECT Description, SUM(TotalPrice) AS Revenue
FROM online_retail_clean
GROUP BY Description
ORDER BY Revenue
LIMIT 10;

-- 7. Average Daily Quantity per Product
WITH daily_qty AS (
    SELECT Description, DATE(InvoiceDate) AS SaleDate, SUM(Quantity) AS Qty
    FROM online_retail_clean
    GROUP BY Description, SaleDate
)
SELECT Description,
       SUM(Qty) AS TotalQty,
       COUNT(*) AS DaysSold,
       ROUND(SUM(Qty)/COUNT(*), 2) AS AvgDailyQty
FROM daily_qty
GROUP BY Description
ORDER BY AvgDailyQty DESC
LIMIT 20;
