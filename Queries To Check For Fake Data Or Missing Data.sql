SELECT * 
FROM FactSales fs
LEFT JOIN DimProduct  dp ON fs.product_id  = dp.product_id
LEFT JOIN DimCustomer dc ON fs.customer_id = dc.customer_id
WHERE dp.product_id IS NULL OR dc.customer_id IS NULL;

SELECT
DISTINCT
X.FullData
FROM
(
SELECT
CONCAT(first_name,last_name,state,city) FullData
FROM
[dbo].[DimCustomer]
) X