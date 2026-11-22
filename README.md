NEEDS EDITTING ###Problem Statement
We have to perform cohort and RFM analysis to understand the value derived from different customer segments. Further, we will divide customers in different clusters based on the analysis by using K-means algorithm.


NEEDS EDITTING ###Dataset Description
This is a transnational data set which contains all the transactions that occurred between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail. The company mainly sells unique and all-occasion gifts.

#Dataset
https://archive.ics.uci.edu/dataset/502/online+retail+ii?

#Columns Description:
- InvoiceNo: 
    Invoice Number. A six digit number uniquely assigned to each transaction. If this code starts with letter 'C', it indicates a cancelled order
- StockCode: 
    Product (item) code, a five digit number uniquely assigned to each distinct product
- Description: 
    Product (item) name 
- Quantity: 
    The quantities of each product (item) per transaction 
- InvoiceDate: 
    Invoice Date and time. The date and time when each transaction was generated
- UnitPrice: 
    Unit price, price per unit of product in sterling (£)
- CustomerID: 
    Unique six digit number assigned to each customer
- Country: 
    Name of country where the customer

#Assumptions & Limitations:
- NTILE(5) was used to split RFM scores into 5 equal groups with 1 being the bottom 20% of customers and 5 being the top 20%. However, this does not guarentee that a certain scores automatically meets a threshold or industry standard/target. It simply reflects the relative percentile of that customer within this (set as bold) dataset
- Whilst we can calculate the revenue that each customer generates, we lack data on the costs of the business. As such, we cannot determine profit or identify the most profitable customers or customer profile

#Tools Used:
PostGres (SQL) 
Power BI 
VSCode
Github

#Intro

#Background


#Business Question



#Cohort analysis

#RFM segmentation

#Customer Lifetime Value (CLV)


