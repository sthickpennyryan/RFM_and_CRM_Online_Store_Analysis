
CREATE TABLE IF NOT EXISTS "Online Retail" (
    InvoiceNo INT,
    StockCode TEXT,
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice DEC(10,2),
    CustomerID INT,
    Country TEXT
);
--- invoice number contains text so loading the data did not work.

ALTER TABLE "Online Retail"
ALTER COLUMN InvoiceNo TYPE TEXT; 
--- updated to accomodate text in invoice number