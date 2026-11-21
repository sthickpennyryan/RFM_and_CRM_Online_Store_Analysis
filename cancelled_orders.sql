--- cancelled orders table

CREATE TABLE IF NOT EXISTS cancelled_orders (
    InvoiceNo TEXT,
    StockCode TEXT,
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    PurchaseDate DATE, 
    PurchaseTime TIME,
    UnitPrice DEC(10,2),
    CustomerID INT,
    Country TEXT
) 

INSERT INTO cancelled_orders (
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    PurchaseDate, 
    PurchaseTime,
    UnitPrice,
    CustomerID,
    Country
)
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    CAST(InvoiceDate AS DATE), 
    CAST(InvoiceDate AS TIME),
    UnitPrice,
    CustomerID,
    CASE 
        WHEN Country = 'EIRE' THEN 'Ireland'
        ELSE Country
    END
FROM "Online Retail"
WHERE InvoiceNo LIKE 'C%'
AND CustomerID IS NOT NULL
AND Country != 'Unspecified'

SELECT *
FROM cancelled_orders
LIMIT 10;
--- Check it has inserted as expected

SELECT *
FROM cancelled_orders
WHERE Country = 'Ireland'
LIMIT 10; 
--- results as expected
SELECT *
FROM cancelled_orders
WHERE Country = 'Unspecified'
LIMIT 10; 
--- unspecified removed as expected
SELECT *
FROM cancelled_orders
WHERE CustomerID IS NULL
LIMIT 10; 
--- no NULL customerIDs
SELECT *
FROM cancelled_orders
WHERE InvoiceNo ~ '^[0-9]'
LIMIT 10; 
--- no orders starting with numbers only therefore we only have 'C' to begin aka cancelled orders
