



--- No NULLS in the final data
--- Cancelled orders removed
--- Country names updated
SELECT
  InvoiceNo,
    StockCode,
    Description,
    Quantity,
    CAST(InvoiceDate AS DATE) purchase_date,
    CAST(InvoiceDate AS TIME) purchase_time,
    UnitPrice,
    CustomerID, -- nulls removed
    CASE 
      WHEN Country = 'EIRE' THEN 'Ireland'
      ELSE Country
    END AS Location
FROM "Online Retail"
WHERE CustomerID IS NOT NULL
AND Country != 'Unspecified'
AND InvoiceNO NOT LIKE 'C%'



SELECT * FROM "Online Retail"
WHERE InvoiceNo LIKE 'C%'
AND CustomerID IS NOT NULL
--- (cancelled orders) this gives us the cancelled orders table







SELECT
  CustomerID,
  MAX(InvoiceDate) AS last_purchase,
  DATE '2011-12-09' - MAX(InvoiceDate) time_since_last_purchase,
  COUNT(DISTINCT InvoiceNo) AS frequency,
  SUM(Quantity * UnitPrice) AS monetary
FROM purchases
GROUP BY CustomerID
--- need to split the dates to get accuracy, currently datetime is a bit of a pain so should remove 


--- min: 2010-12-01 08:26:00
--- max: 2011-12-09 12:50:00