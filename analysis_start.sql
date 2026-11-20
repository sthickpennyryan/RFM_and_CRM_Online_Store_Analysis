

--- No NULLS in the final data
WITH rfm AS (
SELECT
  InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate, --- split down once cleaned to give month/quarter/year analytics
    UnitPrice,
    CustomerID, -- nulls removed
    CASE 
      WHEN Country = 'EIRE' THEN 'Ireland'
      ELSE Country
    END AS Location
FROM "Online Retail"
WHERE CustomerID IS NOT NULL
AND Country != 'Unspecified'
) SELECT 
MAX(InvoiceDate) AS last_purchase,
MIN(InvoiceDate) AS first_purchase,
CustomerID
FROM rfm
GROUP BY CustomerID



SELECT
    CustomerID,
    MAX(InvoiceDate) AS Last_Purchase,
    COUNT(DISTINCT InvoiceNo) AS Frequency,
    SUM(Quantity * UnitPrice) AS Monetary
FROM "Online Retail"
WHERE CustomerID IS NOT NULL
AND Quantity > 0
AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID;
--- recency will be compared to X date 
