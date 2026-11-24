## Task
The online retail business wants to understand customers purchasing behaviour, identifying its most valuable customers, and understand the overall customer purchasing including understanding the times of the year where purchases are at their highest and lowest to allow for information-based decision making to implement strategies to capitalise on high purchases as well as increase low purchases. 

Therefore, the business needs a data-driven approach to analyse historical sales transactions, segment customers based on purchasing behaviour, identify sales trends, and evaluate product performance. The insights generated will help the business focus on areas to maintain as well as areas that need improvement and develop targeted marketing campaigns, improve customer retention, and make informed decisions to increase revenue.

### Dataset Description
This dataset contains transactional data (specific columns below) for the period  between 01/12/2010 and 09/12/2011. The company mainly sells unique and all-occasion gifts and is UK based but does do sales outside of the UK.

## Report and Recommendations
Autumn makes up the highest revenue for the year and highlights increasing spending habits just before December and Christmas. As there is an uptick in purchases in these months, capitalising on increased spending habits is promising and there are a few ways:
- Currently, at risk historic high-value customers bring in comparible revenue to our loyal customers. As this is a considerable amount of revenue that is not being capitalised on, a targetted promotion or loyality scheme is recommended to bring them out of the 'at risk' category and into the revenue stream
- Furthermore, other 'at risk' categories including those that need attention and are low activity, combined make up revenue of more than our loyal customers. Therefore, customer specific messaging and deals to entice customers back to the revenue pool with follow-up messaging to try convert one time customers into repeat customers as they are a majority of the revenue



## Dataset
https://archive.ics.uci.edu/dataset/502/online+retail+ii?

Sales Dashboard: ![My Image](Assets/Revenue%20Dashboard.png)

RFM and Customer Segment Dashboard: ![My Image](Assets/Customer%20Segment%20Dashboard.png)

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
- Country proportion - limited for many countries bar the UK meaning the sample for these companies is likely too small for proper analysis and as a result analysis would likely be assumptions 
- Due to lacking operational costs or profit, I am unable to determine how much revenue is turned into profit for the company
- Country demographic does not split into counties or City's so cannot ascertain whether a certain area has a higher than normal revenue
- December 2011 only covers 9 days of data and is therefore not the must representable measure

While 93% of the revenue comes from repeat customers, this only represents 65% of the overall customers and therefore 35% of customers only make one purchase. While converting single time customers into repeat/loyal customers is beneficial in the long run, this needs to be carefully considered. Focusing on, and spending money and time on customers that currently provide little value to the company may result in negative gains at the cost of alienating the existing significant revenue from repeat customers. Therefore, simple reminders via email or text to one time customers is a good starting point with more focused campaigns/targeted deals for only the highest spending one time customers



### Tools Used:
- PostGres (SQL) 
- Power BI 
- VSCode
- Github

## Business Questions
Questions:
1.	What is our total revenue and how does it change monthly?
![My Image](Assets/Monthly%20Revenue.png)
2.	Who are our top 10 highest-value customers?
```sql
SELECT * FROM analysis_snapshot
WHERE customer_type = 'High Value Customers'
ORDER BY rfm_score DESC, monetary DESC
LIMIT 10;
```
3.	What proportion of revenue comes from repeat customers?
93.08% of revenue comes from repeat customers
``` sql 
SELECT 
    ROUND (
        100.0 * SUM(Monetary) FILTER(WHERE frequency >= 2) / SUM(Monetary), 2
    )
FROM analysis_snapshot
```
4.	What percentage of customers have only purchased once?

34.67% have only purchased once. Meaning that 93.08 of revenue comes from 65.33% of customers (taking into consideration the above)
``` sql
SELECT
    ROUND(
        100.0 * COUNT(DISTINCT CustomerID) FILTER(WHERE frequency = 1) / COUNT(DISTINCT CustomerID), 2
    )
FROM analysis_snapshot
```
5.	Which RFM segments generate the most revenue?

Champion customers provide by far the most revenue followed by loyal customers

![My Image](Assets/Revenue%20by%20RFM%20Segment.png)

6.	How many high-value customers are at risk?

291 High-value customers are at risk
![My Image](Assets/At%20Risk%20High-Value%20Customers.png)

7.	Which products generate the most revenue?
```sql
SELECT
    Description,
    SUM(UnitPrice * Quantity) revenue
FROM purchases
GROUP BY Description
ORDER BY revenue DESC
LIMIT 10;
```
Top 10 products by revenue:
- Paper Craft, Little Birdie
- Regency Cakestand 3 Tier
- White Hanging Heart T-Light Holder
- Jumbo Bag Red Retrospot
- Medium Ceramic Top Storage Jar
- Postage
- Party Bunting
- Assocrted Colour Bird Ornament
- Manual
- Rabbit Night Light

![My Image](Assets/Top%2010%20Products%20by%20Revenue.png)

8.	How much revenue is lost through cancellations and returns?
£611,342.09 of potential revenue lost in cancellations and returns
```sql
SELECT 
    SUM(Quantity * unitprice)
FROM cancelled_orders
```
## RFM segmentation
This assigns a score of 1-5 for Recency, Frequency, and Monetary, to each customerID. For example, a low recency score means that compared to other customers, that customer has not made purchases close to the analysis date of '10.12.2011'. 
The scores relate to percentile brackets as follows:
- 1: 0-20% (bottom bracket)
- 2: 20-40%
- 3: 40-60%
- 4: 60-80%
- 5: 80-100% (top bracket)
```sql
WITH RFM AS (
    SELECT
        CustomerID,
        DATE '2011-12-10' - MAX(PurchaseDate) Recency,
        COUNT(DISTINCT InvoiceNo) Frequency,
        SUM(Quantity * unitprice) Monetary
    FROM purchases
    GROUP BY CustomerID
),
RFM_scores AS(
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_score
FROM RFM
)
SELECT 
*,
CONCAT(R_score, F_score, M_score) RFM_score
FROM RFM_scores
```
## Cohort analysis
The below code assigns categories to customers based upon their Recency, Frequency, and Monetary scores. This enables us to identify high value customers, customers who we risk losing, those who have already gone inactive, as well as those who are loyal customers, customers who are on the way to become loyal customers, and our biggest spenders (most valuable customers). The purpose of this classification is:
- Improve customer retention by identifying those at risk and creating strategies to achieve this
- Retain current customers, especially high-value customers/big spenders
- Identify the proportion of customers we retain
- Identify customers who we have lost/have become inactive and identify their revenue stream to understand whether they are likely to make further purchases in the future and identify possible strategies to accomplish this. At minimum, a reminder email and potential discount and analyse how many returned, their purchases and whether any were retained post-strategy. 
``` sql
CREATE OR REPLACE VIEW customer_snapshot AS


WITH RFM AS (
    SELECT
        CustomerID,
        DATE '2011-12-10' AS analysis_date,   
        DATE '2011-12-10' - MAX(PurchaseDate) Recency,
        COUNT(DISTINCT InvoiceNo) Frequency,
        SUM(Quantity * unitprice) Monetary
    FROM purchases
    GROUP BY CustomerID
),
RFM_scores AS(
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_score
FROM RFM
),
CRM AS (
    SELECT
        *,
        CONCAT(R_Score, F_Score, M_Score) AS RFM_Score,
        CASE
            WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'High Value Customers'
            WHEN R_Score <= 2 AND F_Score >= 4 AND M_Score >= 4 THEN 'Customers to try retain'
            WHEN R_Score <= 2 AND F_Score <= 3 THEN 'At Risk of Losing'
            WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'Inactive'
            WHEN R_Score >= 3 AND F_Score >= 4 THEN 'Loyal Customers'
            WHEN R_Score >= 4 AND F_Score BETWEEN 2 AND 3 THEN 'Potentially Loyal Customers'
            WHEN R_Score = 5 AND F_Score = 1 THEN 'New Customers'
            WHEN M_Score = 5 AND R_Score >= 3 THEN 'Big Spenders'
        ELSE 'Other Customers'
    END AS Customer_type
FROM RFM_scores
)
SELECT 
*
FROM CRM;
```



