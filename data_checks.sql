--- Check data quality and understand the data 

SELECT * FROM "Online Retail"
LIMIT 10;

--- 1) InvoiceNo

SELECT InvoiceNo
FROM "Online Retail"
WHERE TRIM(InvoiceNo) != InvoiceNo
--- no whitespace issues
SELECT InvoiceNo
FROM "Online Retail"
WHERE InvoiceNo IS NULL
--- no NULL values

SELECT
    COUNT(*)
FROM "Online Retail"
WHERE CustomerID IS NULL
AND InvoiceNo IS NOT NULL
--- 135080 rows where invoice data but no customer data. same as missing customer data.
--- therefore it is likely these rows need removing

--- 2) StockCode
SELECT 
    Description,
    COUNT(DISTINCT StockCode)
FROM "Online Retail"
GROUP BY Description
HAVING COUNT(DISTINCT StockCode) > 1;
--- Multiple descriptions have the same stock code- different countries may have same items
--- there are also significant nulls

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

--- 3) Description
SELECT 
    Description
FROM "Online Retail"
WHERE Description != TRIM(Description)
--- a lot, think the test is wrong
SELECT 
    Description
FROM "Online Retail"
WHERE Description IS NULL
--- 1454 null descriptions

--- 4) Quantity
SELECT 
    MIN(Quantity),
    MAX(Quantity)
From "Online Retail"
--- min: -80995
--- max: 80995
--- odd large numbers and negatives need investigating

SELECT 
    Quantity
From "Online Retail"
WHERE Quantity IS NULL
--- no NULLs
SELECT 
    Quantity
FROM "Online Retail"
WHERE Quantity < 0
--- 10624 returned negative values
SELECT 
    *
FROM "Online Retail"
WHERE Quantity < 0
LIMIT 20;


--- 5) InvoiceDate
SELECT 
    MIN(InvoiceDate),
    MAX(InvoiceDate)
From "Online Retail"
--- min: 2010-12-01 08:26:00
--- max: 2011-12-09 12:50:00
SELECT 
    InvoiceDate
From "Online Retail"
WHERE InvoiceDate IS NULL

--- 6) UnitPrice
SELECT 
    MIN(UnitPrice),
    MAX(UnitPrice)
From "Online Retail"
--- min: -11062.06
--- max: 38970.00

/* - Initial thoughts requiring further checks
--- min is negative and problematic but max is fine
--- some 0 unit prices, items either can't be sold or shouldn't be part of this
*/

SELECT 
    UnitPrice
From "Online Retail"
WHERE UnitPrice IS NULL

--- 7) CustomerID
SELECT 
    COUNT(*)
FROM "Online Retail"
WHERE CustomerID IS NULL
--- 135080 null customer IDs


--- 8) Country
SELECT 
    DISTINCT(Country)
FROM "Online Retail"
--- 38 unique countries
--- 1 country as "unspecified"

