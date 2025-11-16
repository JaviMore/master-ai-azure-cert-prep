
/*=============================================================================
Create schema and tables (run this connected to dp900_sql_ecom)
=============================================================================*/

-- Drop tables if they already exist (for re-run convenience)
IF OBJECT_ID('dbo.OrderDetails') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.Orders') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers') IS NOT NULL DROP TABLE dbo.Customers;
GO


-- =====================================================================
-- Table: Customers
-- Description: Stores registered customer data.
-- =====================================================================
CREATE TABLE dbo.Customers (
    CustomerID     INT IDENTITY(1,1)     NOT NULL PRIMARY KEY,     -- Unique customer identifier
    FullName       NVARCHAR(100)         NOT NULL,                 -- Customer's full name
    Email          NVARCHAR(150)         NOT NULL UNIQUE,          -- Email address (unique)
    City           NVARCHAR(100)         NULL,                     -- City of residence
    Country        NVARCHAR(100)         NULL,                     -- Country of residence
    RegistrationDate DATE                NOT NULL DEFAULT (GETDATE()) -- Date when the customer registered
);
GO


-- =====================================================================
-- Table: Products
-- Description: Stores catalog products available for purchase.
-- =====================================================================
CREATE TABLE dbo.Products (
    ProductID      INT IDENTITY(1,1)     NOT NULL PRIMARY KEY,     -- Unique product identifier
    ProductName    NVARCHAR(120)         NOT NULL,                 -- Product name
    Category       NVARCHAR(80)          NULL,                     -- Product category (e.g., "Audio", "Computers")
    UnitPrice      DECIMAL(10,2)         NOT NULL CHECK (UnitPrice >= 0), -- Price per unit
    StockQuantity  INT                   NOT NULL CHECK (StockQuantity >= 0) -- Units available in stock
);
GO


-- =====================================================================
-- Table: Orders
-- Description: Stores high-level order information.
-- =====================================================================
CREATE TABLE dbo.Orders (
    OrderID        INT IDENTITY(1,1)     NOT NULL PRIMARY KEY,     -- Unique order identifier
    CustomerID     INT                   NOT NULL,                 -- FK to Customers
    OrderDate      DATETIME2             NOT NULL DEFAULT (SYSDATETIME()), -- Order creation timestamp
    Status         NVARCHAR(30)          NOT NULL CHECK (Status IN ('Pending','Paid','Shipped','Cancelled')), -- Order status
    TotalAmount    DECIMAL(12,2)         NOT NULL DEFAULT (0),     -- Computed total (sum of details)
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
GO


-- =====================================================================
-- Table: OrderDetails
-- Description: Stores detailed line items for each order.
-- =====================================================================
CREATE TABLE dbo.OrderDetails (
    OrderDetailID  INT IDENTITY(1,1)     NOT NULL PRIMARY KEY,     -- Unique detail identifier
    OrderID        INT                   NOT NULL,                 -- FK to Orders
    ProductID      INT                   NOT NULL,                 -- FK to Products
    Quantity       INT                   NOT NULL CHECK (Quantity > 0),  -- Number of units ordered
    UnitPrice      DECIMAL(10,2)         NOT NULL CHECK (UnitPrice >= 0), -- Unit price at time of purchase
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID)
        REFERENCES dbo.Products(ProductID)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
GO


-- =====================================================================
-- Indexes (optional but recommended for performance)
-- =====================================================================
CREATE INDEX IX_Products_Category       ON dbo.Products(Category);
CREATE INDEX IX_Orders_CustomerID       ON dbo.Orders(CustomerID);
CREATE INDEX IX_Orders_OrderDate        ON dbo.Orders(OrderDate);
CREATE INDEX IX_OrderDetails_OrderID    ON dbo.OrderDetails(OrderID);
CREATE INDEX IX_OrderDetails_ProductID  ON dbo.OrderDetails(ProductID);
GO


-- =====================================================================
-- View: vw_OrdersWithCustomers
-- Description: Combines Orders and Customers for reporting.
-- =====================================================================
IF OBJECT_ID('dbo.vw_OrdersWithCustomers', 'V') IS NOT NULL DROP VIEW dbo.vw_OrdersWithCustomers;
GO
CREATE VIEW dbo.vw_OrdersWithCustomers AS
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Status,
    o.TotalAmount,
    c.CustomerID,
    c.FullName AS CustomerName,
    c.Email,
    c.City,
    c.Country
FROM dbo.Orders o
JOIN dbo.Customers c ON o.CustomerID = c.CustomerID;
GO


-- =====================================================================
-- Quick sanity checks (comment out when deploying)
-- =====================================================================
-- SELECT TOP 5 * FROM dbo.Customers;
-- SELECT TOP 5 * FROM dbo.Products;
-- SELECT TOP 5 * FROM dbo.Orders ORDER BY OrderDate DESC;
-- SELECT TOP 5 * FROM dbo.OrderDetails;
-- SELECT TOP 5 * FROM dbo.vw_OrdersWithCustomers;