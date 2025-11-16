
-- --------------------------------------------------------------
-- CUSTOMERS
-- --------------------------------------------------------------
INSERT INTO dbo.Customers (FullName, Email, City, Country, RegistrationDate)
VALUES
('Anna Perez',        'anna.perez@example.com',        'Madrid',      'Spain',    '2025-01-10'),
('Luis Garcia',       'luis.garcia@example.com',       'Barcelona',   'Spain',    '2025-02-05'),
('Maria Lopez',       'maria.lopez@example.com',       'Seville',     'Spain',    '2025-03-12'),
('John Smith',        'john.smith@example.com',        'London',      'United Kingdom', '2025-01-20'),
('Laura Gomez',       'laura.gomez@example.com',       'Valencia',    'Spain',    '2025-02-14'),
('Emma Johnson',      'emma.johnson@example.com',      'Dublin',      'Ireland',  '2025-04-01'),
('Carlos Ruiz',       'carlos.ruiz@example.com',       'Bilbao',      'Spain',    '2025-03-25'),
('Lucia Mendez',      'lucia.mendez@example.com',      'Granada',     'Spain',    '2025-02-11'),
('Sofia Rossi',       'sofia.rossi@example.com',       'Rome',        'Italy',    '2025-01-18'),
('Peter Muller',      'peter.muller@example.com',      'Berlin',      'Germany',  '2025-02-21');
GO


-- --------------------------------------------------------------
-- PRODUCTS
-- --------------------------------------------------------------
INSERT INTO dbo.Products (ProductName, Category, UnitPrice, StockQuantity)
VALUES
('Laptop 14"',            'Computers',        799.99,  25),
('Wireless Mouse',        'Peripherals',       19.90,  400),
('Mechanical Keyboard',   'Peripherals',       89.00,  300),
('Monitor 27"',           'Computers',        229.50,  100),
('Bluetooth Headphones',  'Audio',             59.95,  500),
('SSD 1TB',               'Storage',          109.00,  150),
('USB-C Dock',            'Peripherals',       34.90,  250),
('HD Webcam',             'Peripherals',       49.50,  180),
('Laser Printer',         'Peripherals',      159.00,   70),
('Stereo Speakers',       'Audio',             79.90,  120),
('Tablet 10"',            'Computers',        349.00,   60),
('WiFi 6 Router',         'Networking',       129.00,   90),
('MicroSD 128GB',         'Storage',           24.90,  200),
('Ergonomic Chair',       'Office',           189.00,   40),
('Laptop Backpack',       'Accessories',       49.00,  150);
GO


-- --------------------------------------------------------------
-- ORDERS
-- --------------------------------------------------------------
INSERT INTO dbo.Orders (CustomerID, OrderDate, Status, TotalAmount)
VALUES
(1, DATEADD(DAY, -30, SYSDATETIME()), 'Paid',       0),
(1, DATEADD(DAY, -20, SYSDATETIME()), 'Shipped',    0),
(2, DATEADD(DAY, -15, SYSDATETIME()), 'Pending',    0),
(3, DATEADD(DAY, -12, SYSDATETIME()), 'Paid',       0),
(4, DATEADD(DAY, -40, SYSDATETIME()), 'Cancelled',  0),
(5, DATEADD(DAY, -8,  SYSDATETIME()), 'Paid',       0),
(6, DATEADD(DAY, -5,  SYSDATETIME()), 'Shipped',    0),
(7, DATEADD(DAY, -3,  SYSDATETIME()), 'Paid',       0),
(8, DATEADD(DAY, -2,  SYSDATETIME()), 'Pending',    0),
(9, DATEADD(DAY, -25, SYSDATETIME()), 'Paid',       0),
(10,DATEADD(DAY, -10, SYSDATETIME()), 'Shipped',    0),
(2, DATEADD(DAY, -18, SYSDATETIME()), 'Paid',       0),
(3, DATEADD(DAY, -7,  SYSDATETIME()), 'Paid',       0),
(8, DATEADD(DAY, -1,  SYSDATETIME()), 'Shipped',    0),
(9, DATEADD(DAY, -4,  SYSDATETIME()), 'Pending',    0);
GO


-- --------------------------------------------------------------
-- ORDER DETAILS
-- --------------------------------------------------------------
INSERT INTO dbo.OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES
-- Order 1 (Anna Perez)
(1, 1, 1, 799.99),
(1, 2, 2, 19.90),
(1, 5, 1, 59.95),
-- Order 2 (Anna Perez)
(2, 3, 1, 89.00),
(2, 4, 2, 229.50),
-- Order 3 (Luis Garcia)
(3, 2, 3, 19.90),
(3, 7, 1, 34.90),
(3, 10,1, 79.90),
-- Order 4 (Maria Lopez)
(4, 6, 1, 109.00),
(4, 11,1, 349.00),
-- Order 5 (John Smith)
(5, 2, 2, 19.90),
(5, 5, 1, 59.95),
-- Order 6 (Laura Gomez)
(6, 1, 1, 799.99),
(6, 8, 1, 49.50),
(6, 15,1, 49.00),
-- Order 7 (Emma Johnson)
(7, 3, 1, 89.00),
(7, 9, 1, 159.00),
(7, 10,1, 79.90),
-- Order 8 (Carlos Ruiz)
(8, 4, 1, 229.50),
(8, 5, 1, 59.95),
(8, 12,1, 129.00),
-- Order 9 (Lucia Mendez)
(9, 6, 2, 109.00),
(9, 7, 1, 34.90),
-- Order 10 (Sofia Rossi)
(10,8, 2, 49.50),
(10,1, 1, 799.99),
-- Order 11 (Peter Muller)
(11,2, 4, 19.90),
(11,5, 2, 59.95),
-- Order 12 (Luis Garcia)
(12,4, 1, 229.50),
(12,14,1, 189.00),
-- Order 13 (Maria Lopez)
(13,3, 2, 89.00),
(13,6, 1, 109.00),
(13,7, 1, 34.90),
-- Order 14 (Lucia Mendez)
(14,5, 1, 59.95),
(14,9, 1, 159.00),
(14,10,1, 79.90),
-- Order 15 (Sofia Rossi)
(15,11,1, 349.00),
(15,13,2, 24.90),
(15,15,1, 49.00);
GO


-- --------------------------------------------------------------
-- UPDATE TOTAL AMOUNTS FOR EACH ORDER
-- --------------------------------------------------------------
UPDATE o
SET TotalAmount = totals.SumAmount
FROM dbo.Orders o
CROSS APPLY (
    SELECT SUM(od.Quantity * od.UnitPrice) AS SumAmount
    FROM dbo.OrderDetails od
    WHERE od.OrderID = o.OrderID
) AS totals;
GO


-- --------------------------------------------------------------
-- VALIDATION QUERIES
-- --------------------------------------------------------------
-- SELECT COUNT(*) AS TotalCustomers FROM dbo.Customers;
-- SELECT COUNT(*) AS TotalProducts FROM dbo.Products;
-- SELECT COUNT(*) AS TotalOrders FROM dbo.Orders;
-- SELECT COUNT(*) AS TotalOrderDetails FROM dbo.OrderDetails;
-- SELECT TOP 10 * FROM dbo.vw_OrdersWithCustomers;
