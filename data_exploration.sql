SELECT * FROM "Online Retail"
LIMIT 10;

SELECT 
    CustomerID,
    COUNT(*) duplicate_rows
FROM "Online Retail"
GROUP BY CustomerID
HAVING COUNT(*) > 1;
--- this doesn't currently work.
--- invoice number can have several orders associated with it 
--- and customerID will obviously be duplicated 

SELECT 
    InvoiceNo
FROM "Online Retail"
WHERE InvoiceNo IS NULL

/* Start data cleaning and identifying issues etc
*/

