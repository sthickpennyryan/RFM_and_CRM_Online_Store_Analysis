/* We're taking this project as if it is 2011-12-10 (10th of December 2011)
and we want to check the data from 2010-12-01 to 2011-12-09 

The aim is to create customer purchase metrics and scores in a customer table

*/ 

SELECT
    CustomerID,
    DATE '2011-12-10' - MAX(PurchaseDate) Recency,
    COUNT(DISTINCT InvoiceNo) Frequency,
    SUM(Quantity * unitprice) Monetary
FROM purchases
GROUP BY CustomerID
LIMIT 10; 
/* This gives us each customers most recent purchase (recency), 
how many purchases (frequency) and how much they spent (monetary)
*/ 

WITH RFM AS (
    SELECT
        CustomerID,
        DATE '2011-12-10' - MAX(PurchaseDate) Recency,
        COUNT(DISTINCT InvoiceNo) Frequency,
        SUM(Quantity * unitprice) Monetary
    FROM purchases
    GROUP BY CustomerID
),
RFM_scores AS(
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_score
FROM RFM
)
SELECT 
*,
CONCAT(R_score, F_score, M_score) RFM_score
FROM RFM_scores
--- Recency lower is better so go go high to low
--- Frequency/monetary higher is better so go low to high (N tile goes 1-5)
