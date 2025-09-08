CREATE DATABASE Sales_Insights
USE Sales_Insights

select * from sales_Canada
select * from sales_china
select * from Sales_India
select * from Sales_Nigeria
select * from Sales_UK
select * from Sales_US


-- Creating Table Sales_Data

CREATE TABLE Sales_Data (
    Transaction_ID       NVARCHAR(50) PRIMARY KEY,
    Date                 DATE,
    Country              NVARCHAR(50),
    Product_ID           NVARCHAR(50),
    Product_Name         NVARCHAR(50),
    Category             NVARCHAR(50),
    Price_per_Unit       FLOAT,
    Quantity_Purchased   TINYINT,
    Cost_Price           FLOAT,
    Discount_Applied     FLOAT,
    Payment_Method       NVARCHAR(50),
    Customer_Age_Group   NVARCHAR(50),
    Customer_Gender      NVARCHAR(50),
    Store_Location       NVARCHAR(50),
    Sales_Rep            NVARCHAR(50)
);

-- Merging the 6 Datasets

INSERT INTO Sales_Data
SELECT * FROM Sales_Canada
UNION ALL
SELECT * FROM Sales_China
UNION ALL
SELECT * FROM Sales_India
UNION ALL
SELECT * FROM Sales_Nigeria
UNION ALL
SELECT * FROM Sales_UK
UNION ALL 
SELECT * FROM Sales_US

SELECT * FROM Sales_Data

-- Data Cleaning

-- Checking For Missing Values

SELECT * FROM Sales_Data
WHERE Transaction_ID IS NULL
or Date IS Null
or Country is null
or Product_ID is null
or Category is null
or Price_per_Unit is null
or Quantity_Purchased is null
or Quantity_Purchased is null
or Cost_Price is null
or Discount_Applied is null
or Payment_Method is null
or Customer_Age_Group is null
or Customer_Gender is null
or Store_Location is null
or Sales_Rep is null


-- Quantity Purchased is null 
-- For filling the missing values lets assume you have called in that shop and  
-- they say may be the Quantiy was 3, we made the mistake while filling t

UPDATE Sales_Data
SET Quantity_Purchased = 3
WHERE Transaction_ID = '001898f7-b696-4356-91dc-8f2b73d09c63'

-- Price is null for filling null values we take avg of price and filled it

UPDATE Sales_Data
SET Price_per_Unit = (
			SELECT AVG(Price_Per_Unit) FROM Sales_Data 
			WHERE Price_per_Unit IS NOT NULL)
WHERE Transaction_ID = '001898f7-b696-4356-91dc-8f2b73d09c63'


UPDATE Sales_Data
SET Price_per_Unit = (
			SELECT AVG(Price_Per_Unit) FROM Sales_Data 
			WHERE Price_per_Unit IS NOT NULL)
WHERE Transaction_ID = '95e49860-f77d-4598-a078-098a8c570147'


-- Discount is null for filling null value I consider 
-- where the null values, there is no discount given.

UPDATE Sales_Data
SET Discount_Applied = 0
WHERE Transaction_ID = '45e4aaf0-240d-464c-b5cf-0ae075998169'


-- Checking for Duplicate Values 
-- There is no Duplicate Values in the Dataset

SELECT Transaction_ID, COUNT(*)
FROM Sales_Data
GROUP BY Transaction_ID
HAVING COUNT(*) > 1


-- Adding "Total_Amount" Column

ALTER TABLE Sales_Data
ADD Total_Amount NUMERIC(10,2)

UPDATE Sales_Data
SET Total_Amount = (Price_Per_Unit * Quantity_Purchased) - Discount_Applied

-- Adding "Profit" Column

ALTER TABLE Sales_Data
ADD Profit NUMERIC(10,2)

UPDATE Sales_Data
SET Profit = Total_Amount - (Cost_Price * Quantity_Purchased)

-- What is the Sales Revenue & Profit by Country?

SELECT Country, SUM(Total_Amount) AS Total_Revenue,
SUM(Profit) AS Total_Profit
FROM Sales_Data
GROUP BY Country
ORDER BY Total_Revenue DESC


-- What is the Top 5 best selling products?

SELECT TOP 5 Product_Name,
SUM(Quantity_Purchased) AS Total_Unit_Sold
FROM Sales_Data
GROUP BY Product_Name
ORDER BY Total_Unit_Sold DESC

-- Best Sales Repersentative

SELECT TOP 5 Sales_Rep AS Sales_Repersentative,
SUM(Total_Amount) AS Total_Sales
FROM Sales_Data
GROUP BY Sales_Rep
ORDER BY Total_Sales DESC


-- Which Store Location generates highest sales?

SELECT TOP 5 Store_Location, 
SUM(Total_Amount) as Total_Sales,
SUM(Profit) as Total_Profit
FROM Sales_Data
GROUP BY Store_Location
ORDER BY Total_Sales Desc


-- 13.	What are the key sales and profit insights for the selected period?

SELECT MIN(Total_Amount) AS Min_Sales_Value,
MAX(Total_Amount) AS Max_Sales_Value,
AVG(Total_Amount) AS Avg_Sales_Value,
SUM(Total_Amount) AS Total_Sales_Value,
MIN(Profit) AS Min_Profit,
MAX(Profit) AS Max_Profit,
AVG(Profit) AS Avg_Profit,
SUM(Profit) AS Total_Profit
FROM Sales_Data



