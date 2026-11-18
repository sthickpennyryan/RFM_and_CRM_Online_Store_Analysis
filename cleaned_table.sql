  
--- utilising the checks and exploration, we begin to clean the table
SELECT
  InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID ,
    Country
FROM "Online Retail"
WHERE CustomerID IS NOT NULL


--- this may be more useful after I do all the cleaning
WITH cleaned_rows AS(
SELECT
    COUNT(*) AS total_rows,
    (SELECT COUNT(*) FROM "Online Retail" WHERE CustomerID IS NOT NULL) AS remaining_rows
FROM "Online Retail"
)
SELECT 
*,
total_rows - remaining_rows AS rows_deleted,
ROUND(
(remaining_rows::NUMERIC / total_rows) * 100, 2 --- changing 
 ) AS percent_remaining_rows,
 ROUND(
100 - (remaining_rows::NUMERIC / total_rows) * 100, 2
 ) percent_deleted_rows
FROM cleaned_rows

--- 531909 rows of data
--- 406829 rows afterwards
--- How many rows deleted?


