
--- Invoices with 'C' are cancelled interactions and we don't want those so need removing
--- RFM analysis wants customerID so we just remove interactions that don't have it 
--- negative quantity and returned are useful to know but not to add in the final analysis of customer purchases

--- utilising the checks and exploration, we begin to clean the table
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


--- negative unit price only goes to 2 interactions of 'Adjust bad debt'
--- this is also on a NULL customerID and will be removed with the filter but is fine otherwise


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

SELECT 
  DISTINCT(Country)
FROM "Online Retail" 
--- EIRE is Ireland, change to consistant
--- Unspecified needs looking into
SELECT 
   DISTINCT(CustomerID),
  Country
FROM "Online Retail"
WHERE Country = 'Unspecified'
--- 4 customer ideas for unspecified. 
--- checking to see if they have other orders that have a country

SELECT *
FROM "Online Retail"
WHERE CustomerID IN (12363, 12743, 14265, 16320)
AND Country != 'Unspecified'
--- those customer ideas are all unspecified. likely remove from final data.

WITH case_when AS(
SELECT *,
    CASE 
      WHEN Country = 'EIRE' THEN 'Ireland'
      ELSE Country
    END AS Location
from "Online Retail"
)
SELECT *
FROM case_when
WHERE Location = 'Ireland'


SELECT * FROM "Online Retail"
ORDER BY UnitPrice ASC
LIMIT 5;


SELECT * FROM "Online Retail"
WHERE (Quantity < 0 
AND CustomerID IS NOT NULL)
--- 8905 rows where this is the case 
SELECT 
  CustomerID,
  MAX(Quantity)
FROM "Online Retail"
GROUP BY CustomerID



SELECT
    a.CustomerID,
    a.InvoiceNo AS Invoice_1,
    b.InvoiceNo AS Invoice_2,
    a.Quantity,
    a.StockCode,
    a.Description
FROM "Online Retail" a
JOIN "Online Retail" b
    ON a.CustomerID = b.CustomerID
    AND a.StockCode = b.StockCode
    AND a.InvoiceNo <> b.InvoiceNo
    
SELECT *
FROM "Online Retail"
WHERE Quantity < 0 AND InvoiceNo LIKE 'C%'
--- this totals 9288 rows
SELECT *
FROM "Online Retail"
WHERE Quantity < 0 
--- returns 10624 
--- therefore some negative quantites are not cancelled orders
SELECT *
FROM "Online Retail"
WHERE Quantity > 0 AND InvoiceNo LIKE 'C%'
--- None as expected

SELECT 
  DISTINCT Description
FROM "Online Retail"