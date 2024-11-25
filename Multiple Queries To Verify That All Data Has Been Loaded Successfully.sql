USE bike_store
SELECT COUNT(*) FROM bike_store.dbo.Stores;
GO
USE bike_storeDW
SELECT COUNT(*) FROM bike_storeDW.dbo.DimStore;
GO

USE bike_store
SELECT COUNT(*) FROM bike_store.dbo.Staff;
GO
USE bike_storeDW
SELECT COUNT(*) FROM bike_storeDW.dbo.DimStaff;
GO

USE bike_store
SELECT COUNT(*) FROM bike_store.dbo.Suppliers;
GO
USE bike_storeDW
SELECT COUNT(*) FROM bike_storeDW.dbo.DimSupplier;
GO

USE bike_store
SELECT COUNT(*) FROM bike_store.dbo.Products;
GO
USE bike_storeDW
SELECT COUNT(*) FROM bike_storeDW.dbo.DimProduct;
GO

USE bike_store
SELECT COUNT(*) FROM bike_store.dbo.Customers;
GO
USE bike_storeDW
SELECT COUNT(*) FROM bike_storeDW.dbo.DimCustomer;
GO

USE bike_store
SELECT COUNT(*) FROM bike_store.dbo.Inventory;
GO
USE bike_storeDW
SELECT COUNT(*) FROM bike_storeDW.dbo.FactInventory;
GO


USE bike_store
SELECT COUNT(*) FROM bike_store.dbo.Order_Items;
GO
USE bike_storeDW
SELECT COUNT(*) FROM bike_storeDW.dbo.FactSales;
GO