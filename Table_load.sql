
--- Permissions denied for direct copy.
COPY "Online Retail"
FROM 'C:\Users\samue\OneDrive\Documents\VS Code Projects\Online_Retail_Analysis\Online Retail.xlsx'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

--- below was used in -psql to load the data directly
\copy "Online Retail" FROM 'C:/Users/samue/OneDrive/Documents/VS Code Projects/Online_Retail_Analysis/Online Retail.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
--- Rows copied: COPY 541909
--- Rows expected: 541909
*/