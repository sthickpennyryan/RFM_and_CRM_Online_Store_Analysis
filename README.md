## Task
The online retail business wants to understand customers purchasing behaviour, identifying its most valuable customers, and understand the overall customer purchasing including understanding the times of the year where purchases are at their highest and lowest to allow for information-based decision making to implement strategies to capitalise on high purchases as well as increase low purchases. 

Therefore, the business needs a data-driven approach to analyse historical sales transactions, segment customers based on purchasing behaviour, identify sales trends, and evaluate product performance. The insights generated will help the business focus on areas to maintain as well as areas that need improvement and develop targeted marketing campaigns, improve customer retention, and make informed decisions to increase revenue.

We have to perform cohort and RFM analysis to understand the value derived from different customer segments. Further, we will divide customers in different clusters based on the analysis by using K-means algorithm.


NEEDS EDITTING ###Dataset Description
This is a transnational data set which contains all the transactions that occurred between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail. The company mainly sells unique and all-occasion gifts.

## Dataset
https://archive.ics.uci.edu/dataset/502/online+retail+ii?

### Columns Description:
- InvoiceNo: 
     Invoice Number. A six digit number uniquely assigned to each transaction. If this code starts with letter 'C', it indicates a cancelled order
- StockCode: Product (item) code, a five digit number uniquely assigned to each distinct product
- Description: Product (item) name 
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

### Assumptions & Limitations:
- NTILE(5) was used to split RFM scores into 5 equal groups with 1 being the bottom 20% of customers and 5 being the top 20%. However, this does not guarentee that a certain scores automatically meets a threshold or industry standard/target. It simply reflects the relative percentile of that customer within this (set as bold) dataset
- Whilst we can calculate the revenue that each customer generates, we lack data on the costs of the business. As such, we cannot determine profit or identify the most profitable customers or customer profile
- Country proportion - limited for many countries bar the UK --- assumptions/analysis limited

### Tools Used:
PostGres (SQL) 
Power BI 
VSCode
Github

## Business Questions

Questions:
1.	What is our total revenue and how does it change monthly?
2.	Who are our top 10 highest-value customers?


3.	What proportion of revenue comes from repeat customers?
4.	What percentage of customers have only purchased once?
5.	Which RFM segments generate the most revenue?
6.	How many high-value customers are at risk?
7.	What is our monthly customer retention rate?
8.	Which acquisition cohorts retain the best?
9.	Which products generate the most revenue?
10.	How much revenue is lost through cancellations and returns?

## Cohort analysis

## RFM segmentation

## Customer Lifetime Value (CLV)


