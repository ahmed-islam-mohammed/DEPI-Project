CREATE INDEX idx_fact_sales_date 
ON FactSales(DateKey);

CREATE INDEX idx_fact_sales_product 
ON FactSales(product_id);

CREATE INDEX idx_fact_sales_customer
ON FactSales(customer_id);

CREATE INDEX idx_fact_sales_Store
ON FactSales(store_id);

CREATE INDEX idx_fact_sales_Staff
ON FactSales(staff_id);



CREATE INDEX idx_fact_inventory_product 
ON FactInventory(product_id);

CREATE INDEX idx_fact_inventory_store 
ON FactInventory(store_id);


