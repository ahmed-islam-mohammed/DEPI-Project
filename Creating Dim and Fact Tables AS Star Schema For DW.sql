CREATE DATABASE bike_storeDW;
GO

USE bike_storeDW;
GO

CREATE TABLE DimCustomer (
    customer_id INT PRIMARY KEY,  -- same as in transactional table
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(10)
);

CREATE TABLE DimProduct (
    product_id INT PRIMARY KEY,           -- same as in transactional table
    product_name VARCHAR(255),
    brand_id INT,                         -- Foreign key reference to Brands
    category_id INT,                      -- Foreign key reference to Categories
    model_year INT,
    list_price DECIMAL(10, 2),
    supplier_id INT,
    brand_name VARCHAR(255),              -- Brand name from Brands
    category_name VARCHAR(255)            -- Category name from Categories
);

CREATE TABLE DimStore (
    store_id INT PRIMARY KEY,  -- same as in transactional table
    store_name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(10)
);

CREATE TABLE DimStaff (
    staff_id INT PRIMARY KEY,  -- same as in transactional table
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    active VARCHAR(20),
    store_id INT,  -- Foreign key reference to DimStore
    manager_id INT -- Self-referential relationship (manager)
);


CREATE TABLE DimSupplier (
    supplier_id INT PRIMARY KEY,  -- same as in transactional table
    supplier_name VARCHAR(255),
    contact_name VARCHAR(255),
    contact_phone VARCHAR(50),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20)
);

CREATE TABLE FactSales (
    sales_id INT PRIMARY KEY IDENTITY(1,1),  -- Surrogate primary key
    customer_id INT,                         -- Foreign key to DimCustomer
    product_id INT,                          -- Foreign key to DimProduct
    store_id INT,                            -- Foreign key to DimStore
    staff_id INT,                            -- Foreign key to DimStaff
    quantity INT,                            -- From Order_Items
    list_price DECIMAL(10, 2),               -- From Order_Items
    discount DECIMAL(5, 2),                  -- From Order_Items
    total_sales_amount DECIMAL(18, 2),		 -- Calculated column
    DateKey INT,                             -- Foreign key to DimDate
    FOREIGN KEY (customer_id) REFERENCES DimCustomer(customer_id),
    FOREIGN KEY (product_id) REFERENCES DimProduct(product_id),
    FOREIGN KEY (store_id) REFERENCES DimStore(store_id),
    FOREIGN KEY (staff_id) REFERENCES DimStaff(staff_id),
    FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey)          -- Link to DimDate
);


CREATE TABLE FactInventory (
    inventory_id INT PRIMARY KEY IDENTITY(1,1),  -- Surrogate primary key for FactInventory
    store_id INT,                                -- Foreign key reference to DimStore
    product_id INT,                              -- Foreign key reference to DimProduct
    quantity INT,                                -- From Inventory table (quantity of product in stock)
    FOREIGN KEY (store_id  ) REFERENCES DimStore(store_id),
    FOREIGN KEY (product_id) REFERENCES DimProduct(product_id)
);
