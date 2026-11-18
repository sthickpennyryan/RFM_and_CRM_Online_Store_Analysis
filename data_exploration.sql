--- Explore and understand the data 

SELECT 
    COUNT(*)
FROM "Online Retail"
WHERE CustomerID IS NULL
--- 135080 null customer IDs

    COUNT(*)
FROM "Online Retail"
WHERE CustomerID IS NULL
AND InvoiceNo IS NOT NULL
--- 135080 rows where invoice data but no customer data. same as missing customer data.
--- therefore it is likely these rows need removing
--- Check whether any InvoiceNo that start with a character have the same customerID as the same invoiceNo without a character to potentially save some rows

SELECT 
    COUNT(*) AS matching_invoices
FROM "Online Retail" a
JOIN "Online Retail" b
    ON a.InvoiceNo = SUBSTRING(b.InvoiceNo FROM 2)
    --- joining and filtering to ensure any invoice numbers have their first character removed
WHERE b.InvoiceNo ~ '^[A-Za-z]';
--- checking to see whether the substring matches the invoice number when the invoice number starts with a character originally
--- As there are no matching invoices a possible avenue to clarify the NULL customerID is gone and we therefore need to remove NULL customerID

--- 1) InvoiceNo
SELECT
COUNT(DISTINCT(InvoiceNo))
FROM "Online Retail"
--- 25900 unique invoices
SELECT COUNT(InvoiceNo)
FROM "Online Retail"
--- 541909 total invoices
SELECT COUNT(InvoiceNo)
FROM (SELECT DISTINCT(InvoiceNo) FROM "Online Retail")
--- works same as the above one.

--- 2) StockCode
SELECT 
    COUNT(DISTINCT(StockCode))
FROM "Online Retail" 
--- 4070 unique stock codes

--- 3) Description

--- 4) Quantity

--- 5) InvoiceDate

--- 6) UnitPrice

--- 7) CustomerID

--- 8) Country