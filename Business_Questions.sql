/* 
Questions:
1.	What is our total revenue and how does it change monthly?
2.	Who are our top 10 highest-value customers?
3.	What proportion of revenue comes from repeat customers?
4.	What percentage of customers have only purchased once?
5.	Which RFM segments generate the most revenue?
6.	How many high-value customers are at risk?
7.	What is our monthly customer retention rate?
8.	Which acquisition cohorts retain the best?
9.	Which products generate the most revenue?
10.	How much revenue is lost through cancellations and returns?
*/



--- 1.	What is our total revenue and how does it change monthly?
--- 2.	Who are our top 10 highest-value customers?
SELECT * FROM analysis_snapshot
WHERE customer_type = 'High Value Customers'
ORDER BY rfm_score DESC, monetary DESC
LIMIT 10;
--- 3.	What proportion of revenue comes from repeat customers?
/* original query 
WITH repeat_proportion AS (
SELECT
    SUM(Monetary) total_revenue,
(SELECT
    SUM(Monetary) repeat_revenue
FROM analysis_snapshot
WHERE frequency >= 2)
FROM analysis_snapshot
)
SELECT
    ROUND (
        100.0 * (repeat_revenue / total_revenue), 2) repeat_revenue_proportion
FROM repeat_proportion --- 93.08% 
*/ 

--- cleaned query
SELECT 
    ROUND (
        100.0 * SUM(Monetary) FILTER(WHERE frequency >= 2) / SUM(Monetary), 2
    )
FROM analysis_snapshot

--- 4.	What percentage of customers have only purchased once?
/* original
WITH one_time AS (
SELECT 
    (SELECT COUNT(DISTINCT CustomerID) FROM analysis_snapshot) AS total_customers,
    COUNT(DISTINCT CustomerID) one_time_customers
FROM analysis_snapshot
GROUP BY frequency
HAVING frequency = 1
) 
SELECT 
    ROUND(
        100 * one_time_customers / NULLIF(total_customers, 0), 2)  AS percentage_one_time_orders
FROM one_time
--- 34% 
*/
--- cleaned code below
SELECT
    ROUND(
        100.0 * COUNT(DISTINCT CustomerID) FILTER(WHERE frequency = 1) / COUNT(DISTINCT CustomerID), 2
    )
FROM analysis_snapshot
--- 34.67% have only purchased once




--- 5.	Which RFM segments generate the most revenue?
SELECT 
    R_score,
    F_score,
    M_Score,
    SUM(Monetary) Revenue_by_score
FROM analysis_snapshot
GROUP BY R_Score, F_Score, M_Score
ORDER BY Revenue_by_score DESC
LIMIT 5
--- 5,5,5 
--- 4,5,5
--- 3,5,5
--- 5,3,5
--- 4, 4, 4
--- Scores that produced the highest revenue but this misses the mark. Which individual scores produce the highest revenue?

SELECT 
(SELECT R_score, SUM(Monetary) FROM analysis_snapshot GROUP BY R_score),
(SELECT F_score, SUM(Monetary) FROM analysis_snapshot GROUP BY F_score),
(SELECT M_score, SUM(Monetary) FROM analysis_snapshot GROUP BY M_score)
FROM analysis_snapshot

 





--- 6.	How many high-value customers are at risk?



--- 7.	What is our monthly customer retention rate?



--- 8.	Which acquisition cohorts retain the best? --- scrap for now. I'm getting confused/not managing this
/*
SELECT 
    MIN(PurchaseDate) AS date_joined,
    DATE_TRUNC(PurchaseDate, MONTH),
    COUNT(DISTINCT(CustomerID))
FROM purchases
LIMIT 10;

SELECT
    CustomerID,
    EXTRACT(YEAR FROM MIN(PurchaseDate)) AS acquisition_year,
    EXTRACT(MONTH FROM MIN(PurchaseDate)) AS acquisition_month
FROM purchases 
GROUP BY CustomerID
LIMIT 10;

WITH first_purchase AS(
SELECT
    CustomerID,
    DATE_TRUNC('month', MIN(PurchaseDate)) AS first_purchase
    FROM purchases
    GROUP BY CustomerID
), 
purchase_month AS (
    SELECT 
        DISTINCT
        CustomerID,
        DATE_TRUNC('month', PurchaseDate) AS purchase_month
    FROM purchases
),
cohort_purchases AS(
    SELECT
        f.CustomerID,
        f.first_purchase,
        pm.purchase_month,
            EXTRACT(YEAR FROM AGE(pm.purchase_month, f.first_purchase)) * 12 + 
            EXTRACT(MONTH FROM AGE(pm.purchase_month, f.first_purchase)) AS cohort
    FROM first_purchase f
    JOIN purchase_month pm
    ON f.customerID = pm.CustomerID
),
cohort_retention AS(
SELECT 
    first_purchase,
    cohort,
    COUNT(DISTINCT CustomerID) AS retained_customers
FROM cohort_purchases
GROUP BY first_purchase, cohort
ORDER BY first_purchase, cohort
)
SELECT 
    cohort,
    COUNT(cohort)
FROM cohort_retention
GROUP BY cohort
*/

--- 9.	Which products generate the most revenue?
SELECT
    Description,
    SUM(UnitPrice * Quantity) revenue
FROM purchases
GROUP BY Description
ORDER BY revenue DESC
LIMIT 5;
/* Top 5 products:
Paper Craft, Little Birdie,
Regency Cakestand 3 Tier,
White Hanging Heart T-Light Holder
Jumbo Bag Red Retrospot
Medium Ceramic Top Storage Jar
*/

--- 10.	How much revenue is lost through cancellations and returns?
SELECT 
    SUM(Quantity * unitprice)
FROM cancelled_orders
--- £611,342.09 lost




