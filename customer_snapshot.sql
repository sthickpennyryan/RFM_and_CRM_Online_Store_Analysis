SELECT
    CustomerID,
    DATE '2011-12-10' AS analysis_date,
    DATE '2011-12-10' - MAX(PurchaseDate) Recency,
    COUNT(DISTINCT InvoiceNo) Frequency,
    SUM(Quantity * unitprice) Monetary
FROM purchases
GROUP BY CustomerID
LIMIT 10; 
/* This gives us each customers most recent purchase (recency), 
how many purchases (frequency) and how much they spent (monetary)
*/ 

CREATE OR REPLACE VIEW customer_snapshot AS


WITH RFM AS (
    SELECT
        CustomerID,
        DATE '2011-12-10' AS analysis_date,   
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
),
CRM AS (
    SELECT
        *,
        CONCAT(R_Score, F_Score, M_Score) AS RFM_Score,
        CASE
            WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'High Value Customers'
            WHEN R_Score <= 2 AND F_Score >= 4 AND M_Score >= 4 THEN 'Customers to try retain'
            WHEN R_Score <= 2 AND F_Score <= 3 THEN 'At Risk of Losing'
            WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'Inactive'
            WHEN R_Score >= 3 AND F_Score >= 4 THEN 'Loyal Customers'
            WHEN R_Score >= 4 AND F_Score BETWEEN 2 AND 3 THEN 'Potentially Loyal Customers'
            WHEN R_Score = 5 AND F_Score = 1 THEN 'New Customers'
            WHEN M_Score = 5 AND R_Score >= 3 THEN 'Big Spenders'
        ELSE 'Other Customers'
    END AS Customer_type
FROM RFM_scores
)
SELECT 
*
FROM CRM;

SELECT * FROM customer_snapshot
LIMIT 10;


CREATE TABLE IF NOT EXISTS analysis_snapshot (
        CustomerID INT,
        Analysis_Date DATE,   
        Recency INT,
        Frequency INT,
        Monetary DEC(12, 2),
        R_Score INT,
        F_Score INT,
        M_Score INT,
        RFM_Score TEXT,
        Customer_type TEXT
)

INSERT INTO analysis_snapshot (
     CustomerID,
        Analysis_Date,   
        Recency,
        Frequency,
        Monetary,
        R_Score,
        F_Score,
        M_Score,
        RFM_Score,
        Customer_type
)
SELECT 
* 
FROM customer_snapshot

SELECT * FROM analysis_snapshot 
--- same # of rows insert from customer_snapshot

--- CHECK THAT THE PRICES ETC OR SUM OF PRICES AND ORDERS MAKES UP THE SAME AS THE MAIN TABLE
--- 4335 unique people
SELECT
COUNT(DISTINCT CustomerID)
FROM purchases

SELECT
    SUM(Quantity * UnitPrice)
FROM purchases
--- total 8908740.83
SELECT SUM(Monetary) FROM analysis_snapshot
--- same as above. all fine