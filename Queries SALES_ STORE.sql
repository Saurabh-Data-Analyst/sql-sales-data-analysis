CREATE DATABASE sales_store;

USE sales_store;
GO

CREATE TABLE sales_store (
transaction_id VARCHAR(15),
customer_id VARCHAR(15),
customer_name VARCHAR(30),
customer_age INT,
gender VARCHAR(15),
product_id VARCHAR(15),
product_name VARCHAR(15),
product_category VARCHAR(15),
quantiy INT,
prce FLOAT,
payment_mode VARCHAR(15),
purchase_date DATE,
time_of_purchase TIME,
status VARCHAR(15)
);

SELECT * FROM sales_store;

SET DATEFORMAT dmy
BULK INSERT sales_store
FROM 'C:\Users\user\Downloads\archive (4)\sales_store.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);
	SELECT * FROM sales_store;

	--YYYY-MM-DD

	--DATA CLEANING
	SELECT * FROM sales_store

	SELECT * INTO sales FROM sales_store

	SELECT * FROM sales_store
	

	--Data Cleaning
	--Step 1:- to check for duplicate

	SELECT transaction_id, COUNT(*)
	FROM sales_store
	GROUP BY transaction_id
	HAVING COUNT (transaction_id) > 1

	TXN240646
	TXN342128
	TXN855235
	TXN981773
	
	WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS ROW_NUM
    FROM sales_store
)
DELETE FROM CTE
WHERE ROW_NUM > 1;

	--DELETE FROM CTE
	--WHERE ROW_NUM = 2

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS ROW_NUM
    FROM sales_store
)

SELECT *
FROM CTE
WHERE transaction_id IN ('TXN240646','TXN342128','TXN855235','TXN981773');

SELECT DISTINCT transaction_id
FROM sales_store;


	SELECT * FROM sales_store
	

-- STEP 2:- Correction of Headers

EXEC sp_rename 'sales_store.quantittty' , 'quantity', 'COLUMN'

EXEC sp_rename'sales_store.prce' , 'price', 'COLUMN'


--step 3 :- to check data type

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales_store'

--step 4 :- to check null values
-- to  check null count

DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName,
            COUNT(*) AS NullCount
     FROM ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + '
     WHERE ' + QUOTENAME(COLUMN_NAME) + ' IS NULL'
, ' UNION ALL ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales_store';

EXEC sp_executesql @SQL;

--TREATING NULL VALUES

SELECT *
FROM sales_store
WHERE transaction_id is null
OR
customer_id IS NULL
OR
customer_name IS NULL
OR
customer_age IS NULL
OR
gender IS NULL
OR
product_id IS NULL
OR
product_name IS NULL
OR
product_category IS NULL
OR
quantity IS NULL
OR
price IS NULL
OR
payment_mode IS NULL
OR
time_of_purchase IS NULL
OR
status IS NULL

DELETE FROM sales_store
WHERE transaction_id IS NULL;

SELECT * FROM sales_store
WHERE Customer_name = 'Ehsaan Ram'

UPDATE sales_store
SET customer_id = 'CUST9494'
WHERE transaction_id = 'TXN977900'

SELECT * FROM sales_store
WHERE Customer_name = 'Damini Raju'

UPDATE sales_store
SET customer_id = 'CUST1401'
WHERE transaction_id = 'TXN985663'

SELECT * FROM sales_store
WHERE Customer_id = 'CUST1003'

UPDATE sales_store
SET customer_name = 'Mahika Saini', customer_age = 35, gender = 'Male'
WHERE transaction_id = 'TXN432798'

SELECT * FROM sales_store

--step 5 data :- data Cleaning

SELECT DISTINCT gender
FROM sales_store

UPDATE sales_store
SET gender = 'Male'
WHERE gender = 'M'

UPDATE sales_store
SET gender = 'Female'
WHERE gender = 'F'

SELECT DISTINCT Payment_mode	
FROM sales_store

UPDATE sales_store
SET payment_mode = 'Credit Card'
WHERE payment_mode = 'CC'


--Data Analysis--

--Q1. What are the top 5 most selling products by quantity?
SELECT * FROM sales_store

SELECT DISTINCT status
FROM sales_store

SELECT TOP 5 product_name, SUM (quantity) AS total_quantity_sold
FROM sales_store
WHERE status = 'delivered'
GROUP BY product_name
ORDER BY total_quantity_sold DESC;

------Business Problem solved : We don't know which products are most in demand.

------ Business Impact : Helps priortize stock and boost sales through targeted promotions.

--Q2; Which products are most frequently canceled?

SELECT TOP 5 product_name, COUNT (*) AS total_cancelled
FROM sales_store
WHERE status = 'cancelled'
GROUP BY product_name
ORDER BY total_cancelled DESC;

---Business Problem  solved: Frequent cancellation afffect revenue and customer trust.
----Business Impact; Identify poor - performing products to improve quality or remove form catalog.

--Q3; what time of the day has the highest number of purchases ?

SELECT *FROM sales_store

SELECT 
	CASE
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
	END AS time_of_day,
	COUNT(*) AS total_orders
FROM sales_store
GROUP BY 
    CASE
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
	END 
	ORDER BY total_orders DESC;

	---Business Problem solved : For finding peak time of sales
	----Business Impact ; optimize staffing, promotins, and server loads.

--Q4; Who are the top 5 highest spending customers?

SELECT TOP 5 customer_name, SUM (price*quantity ) AS total_spend
FROM sales_store
GROUP BY customer_name
ORDER BY total_spend DESC;

--if we want total_spend in rs. symbol------

SELECT TOP 5 customer_name,
	FORMAT( SUM (price*quantity ), 'C0', 'en-IN') AS total_spend
FROM sales_store
GROUP BY customer_name
ORDER BY SUM(price*quantity ) DESC;

---Business Problem solved : Identify VIP customers
---Business Imapact ; Personalized, loyalty rewards, and retention.

--Q5. Which  product categories generate highest revenue?

SELECT * FROM sales_store

SELECT product_category ,
	FORMAT(SUM( price*quantity),'C0','en-IN') AS Revenue
FROM sales_store
	GROUP BY product_category
	ORDER BY SUM( price*quantity) DESC;

---Business Problem solved : Identify top performaing product categories.
--- Business Impact ; Refine product strategy, supply chain , and promotions, allowing the business 
                   --to invest more in high margin or high _ demand categories.

--Q6. what is the return/ cancellation rate per product category?
SELECT * FROM sales_store

---Cancelletion----
	SELECT product_category,
		COUNT (CASE WHEN status = 'cancelled' THEN 1 END) * 100.0/COUNT(*) AS cancelled_percentage
	FROM sales_store
	GROUP BY product_category
	ORDER BY cancelled_percentage DESC;
 
 --- does FORMATTING---

 SELECT product_category,
		FORMAT (COUNT (CASE WHEN status = 'cancelled' THEN 1 END) * 100.0/COUNT(*), 'N3')+ ' %' AS cancelled_percentage
	FROM sales_store
	GROUP BY product_category
	ORDER BY cancelled_percentage DESC;
 
 ---Return % ----

 SELECT product_category,
		FORMAT (COUNT (CASE WHEN status = 'returned' THEN 1 END) * 100.0/COUNT(*), 'N3')+ ' %' AS returned_percentage
	FROM sales_store
	GROUP BY product_category
	ORDER BY returned_percentage DESC;
 

 ---Business Problem solved : Monitor dissatisfaction trends per category..
 ---Business Impact ; Reduce retuns, improve product descriptions/ expectations.
 -------------------- helps identify and fix products ans logistics issues.

 ---Q7; What is the most perferred paymnet mode?

 SELECT * FROM sales_store;

 SELECT payment_mode, COUNT (payment_mode) AS total_count
 FROM sales_store
 GROUP BY payment_mode
 ORDER BY total_count;

------Business problem solved; Know which payment methods customers prefferd
-----Business Imapct; stremline payment processing , priortize popular modes.

---QQ 8. How does age group affect puchasing behavior?

SELECT * FROM sales_store;

SELECT MIN (customer_age) as min_age , MAX (customer_age) as max_age
from sales_store

SELECT 
	CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18 -25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26 -35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36 -50'
		ELSE '51+'
	END AS customer_age,
	SUM (price*quantity) AS total_purchase
FROM sales_store
GROUP BY CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18 -25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26 -35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36 -50'
		ELSE '51+'
	END 
ORDER BY total_purchase DESC;

--LET'S DO FORMATING--

SELECT 
	CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18 -25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26 -35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36 -50'
		ELSE '51+'
	END AS customer_age,
	FORMAT (SUM (price*quantity), 'C0', 'en_IN') AS total_purchase
FROM sales_store
GROUP BY CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18 -25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26 -35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36 -50'
		ELSE '51+'
	END 
ORDER BY SUM (price*quantity) DESC;

---Business Problem solved; Understand customer demographics.
---Business impact -Targeted marketing and product recommendation by age group.

--Q9; What's the monthly sales trend?

SELECT * FROM sales_store

---- Method 1-----

SELECT 
	FORMAT(purchase_date,'yyyy-MM') AS Month_year,
	FORMAT(SUM(price*quantity), 'C0','en-IN') AS total_sales,
	SUM (quantity) AS total_quantity
	FROM sales_store
	GROUP BY FORMAT (purchase_date,'yyyy-MM')
	ORDER BY Month_year ;

	-----Method 2---
	SELECT* FROM sales_store;

	SELECT 
		YEAR(purchase_date) AS Years,
		MONTH(Purchase_date) AS Months,
		FORMAT (SUM(price * quantity), 'C0', 'en-IN') AS total_sales,
		SUM(quantity) AS total_quantity
	FROM sales_store
	GROUP BY YEAR (purchase_date),MONTH (purchase_date)
	ORDER BY Months;
	
---Business Problem solved; Sales fluctuations go unnoticed.
---Busniesss Impact; Plan inventory and marketing according to seasonal tends.

---Q 10; are certain genders buying more specific product categories?
SELECT * FROM Sales_store

--Method 1---
SELECT gender, product_category,COUNT(product_category) AS total_purchse
FROM sales_store
GROUP BY gender, product_category
ORDER BY gender;

---Method 2---(Subquery
SELECT *
FROM ( 
	SELECT gender, product_category
	FROM sales_store
	) AS source_table
PIVOT (
	COUNT (gender)
	FOR gender IN ([MALE], [FEMALE])
	) AS pivot_table
ORDER BY product_category;

----Business problem solved - gender based product preferences.
----Business Impact - Personalised ads,  gender- focused campaigns.











 

























