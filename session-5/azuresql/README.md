# Practice with Azure SQL

## Create Azure SQL Database using Template

### Create 

To create the cosmos account using the template file first change the values in file template/parameter.json
> To get your public IP you can use [this website](https://whatismyipaddress.com/)

```json  
  ...
 "parameters": {
    ...
        "serverName": {
            "value": "uniqueservername"
        },
    ...
        "clientIpValue": {
            "value":  "YOUR_PUBLIC_IP_ADDRESS"
        },    
    ...
        "administratorLogin": {
            "value": "datauser"
        },
        "administratorLoginPassword": {
            "value": "securePassword"
        }    
  ... 
  }



``` 
Perform login with Azure CLI

```bash
az login 
``` 

Create a resource group

```bash
az group create --name myResourceGroup --location westeurope
```

Go into template forder and deploy using CLI

```bash
cd template
az deployment group create \
  --resource-group myResourceGroup \
  --template-file template.json \
  --parameters @parameters.json
```


### Clean up
```bash
az group delete --name myResourceGroup --yes --no-wait
```

## Example queries

#### Select & Filter: Retrieve all customers from Spain

```sql
SELECT CustomerID, FullName, City, Country
FROM dbo.Customers
WHERE Country = 'Spain';
```

#### Sorting: Top 5 most expensive products
```sql
SELECT TOP 5 ProductName, Category, UnitPrice
FROM dbo.Products
ORDER BY UnitPrice DESC;
```

#### Calculated Columns: Show price with 21% tax

```sql
SELECT 
    ProductName,
    UnitPrice,
    ROUND(UnitPrice * 1.21, 2) AS PriceWithTax
FROM dbo.Products;
```

#### Joins: Show each order with the customer’s name

```sql
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Status,
    c.FullName AS CustomerName,
    c.Country
FROM dbo.Orders o
JOIN dbo.Customers c ON o.CustomerID = c.CustomerID;
```

#### Aggregation: Total revenue per product category

```sql
SELECT 
    p.Category,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS TotalRevenue
FROM dbo.Products p
JOIN dbo.OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;
```