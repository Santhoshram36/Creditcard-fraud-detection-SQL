SELECT TOP (1000) ["Time"]
      ,["V1"]
      ,["V2"]
      ,["V3"]
      ,["V4"]
      ,["V5"]
      ,["V6"]
      ,["V7"]
      ,["V8"]
      ,["V9"]
      ,["V10"]
      ,["V11"]
      ,["V12"]
      ,["V13"]
      ,["V14"]
      ,["V15"]
      ,["V16"]
      ,["V17"]
      ,["V18"]
      ,["V19"]
      ,["V20"]
      ,["V21"]
      ,["V22"]
      ,["V23"]
      ,["V24"]
      ,["V25"]
      ,["V26"]
      ,["V27"]
      ,["V28"]
      ,["Amount"]
      ,["Class"]
  FROM [sql_project_p2].[dbo].[creditcard]


select * from creditcard

select count(*) from creditcard

SELECT DISTINCT [Class]
FROM creditcard;


-- Verify the column name
EXEC sp_columns 'creditcard';


-- Identify problematic values in the Class column
SELECT DISTINCT Class
FROM creditcard
WHERE TRY_CAST(REPLACE(REPLACE(Class, '"', ''), '''', '') AS INT) IS NULL;


-- Clean the data by removing unwanted characters
UPDATE creditcard
SET Class = REPLACE(REPLACE(Class, '"', ''), '''', '')
WHERE TRY_CAST(REPLACE(REPLACE(Class, '"', ''), '''', '') AS INT) IS NOT NULL;


-- Ensure all values are numeric after cleaning
SELECT DISTINCT Class
FROM creditcard
WHERE TRY_CAST(Class AS INT) IS NULL;


-- Alter the column type to INT
ALTER TABLE creditcard
ALTER COLUMN Class INT;


--Total Fraudulent Transactions:
SELECT COUNT(*) AS Fraudulent_Transactions FROM creditcard WHERE Class = 1;


--Total Non-Fraudulent Transactions:
SELECT COUNT(*) AS Non_Fraudulent_Transactions FROM creditcard WHERE Class = 0;


--Percentage of Fraudulent Transactions:
SELECT 
  (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM creditcard)) AS Fraud_Percentage
FROM creditcard
WHERE Class = 1;


--STATISTICAL ANALYSIS

--Average Transaction Amount for Fraudulent Transactions:
SELECT AVG(["Amount"]) AS Avg_Fraud_Amount
FROM creditcard
WHERE Class = 1;

ALTER TABLE creditcard
ALTER COLUMN ["Amount"] float;

--Average Transaction Amount for Non-Fraudulent Transactions:
SELECT AVG(["Amount"]) AS Avg_Non_Fraud_Amount
FROM creditcard
WHERE Class = 0;

--Max Transaction Amount in Fraudulent Transactions:
SELECT MAX(["Amount"]) AS Max_Fraud_Amount
FROM creditcard
WHERE Class = 1;

--Max Transaction Amount in Non-Fraudulent Transactions:
SELECT MAX(["Amount"]) AS Max_Non_Fraud_Amount
FROM creditcard
WHERE Class = 0;


--Time-Based Analysis

--Transactions Distribution by Time:
SELECT ["Time"], COUNT(*) AS Transaction_Count
FROM creditcard
GROUP BY ["Time"]
ORDER BY ["Time"];


-- Identify problematic values in the time column
SELECT DISTINCT ["Time"]
FROM creditcard
WHERE TRY_CAST(REPLACE(REPLACE(["Time"], '"', ''), '''', '') AS INT) IS NULL;


-- Clean the data by removing unwanted characters
UPDATE creditcard
SET ["Time"] = REPLACE(REPLACE(["Time"], '"', ''), '''', '')
WHERE TRY_CAST(REPLACE(REPLACE(["Time"], '"', ''), '''', '') AS INT) IS NOT NULL;


-- Ensure all values are numeric after cleaning
SELECT DISTINCT ["Time"]
FROM creditcard
WHERE TRY_CAST(["Time"] AS INT) IS NULL;

-- Alter the column type to INT
ALTER TABLE creditcard
ALTER COLUMN ["Time"] INT;

-- Check for values in scientific notation or in a format that might not be an integer
SELECT DISTINCT ["Time"]
FROM creditcard
WHERE TRY_CAST(["Time"] AS INT) IS NULL;

-- Update Time column by converting scientific notation to integers
UPDATE creditcard
SET ["Time"] = CAST(CAST(["Time"] AS FLOAT) AS INT)
WHERE TRY_CAST(["Time"] AS INT) IS NULL AND TRY_CAST(["Time"] AS FLOAT) IS NOT NULL;

-- Verify the updated values
SELECT ["Time"]
FROM creditcard
WHERE TRY_CAST(["Time"] AS INT) IS NULL;

--Query to convert seconds to HH:MM:SS format and aggregate results
--Fraudulent Transactions Distribution by Time:
SELECT 
    RIGHT('0' + CAST(FLOOR(["Time"] / 3600) AS VARCHAR(2)), 2) + ':' +
    RIGHT('0' + CAST(FLOOR((["Time"] % 3600) / 60) AS VARCHAR(2)), 2) + ':' +
    RIGHT('0' + CAST(["Time"] % 60 AS VARCHAR(2)), 2) AS Time_Formatted,
    COUNT(*) AS Transaction_Count
FROM creditcard
GROUP BY 
    RIGHT('0' + CAST(FLOOR(["Time"] / 3600) AS VARCHAR(2)), 2) + ':' +
    RIGHT('0' + CAST(FLOOR((["Time"] % 3600) / 60) AS VARCHAR(2)), 2) + ':' +
    RIGHT('0' + CAST(["Time"] % 60 AS VARCHAR(2)), 2)
ORDER BY Time_Formatted;


-- Fraud Detection: Amount Thresholds
SELECT 
    ["Amount"],
    COUNT(*) AS Frequency,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS Fraudulent_Count
FROM creditcard
GROUP BY ["Amount"]
ORDER BY ["Amount"];

SELECT  
    COUNT(*) AS Transaction_Count, 
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS Fraudulent_Transactions
FROM creditcard
ORDER BY Fraudulent_Transactions DESC;





