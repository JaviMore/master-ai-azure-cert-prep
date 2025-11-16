# Practice with CosmosDB

## Create account using Template

### Create 

To create the cosmos account using the template file first change the value name in file template/parameter.json
```json  
  ...
 "parameters": {
        "name": {
            "value": "CHANGE_ME_UNIQUE_NAME"  
        },
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

Create database
```bash
az cosmosdb sql database create \
  --account-name CHANGE_ME_UNIQUE_NAME \
  --resource-group myResourceGroup \
  --name dp900_nosql_ecom
```

```bash
az cosmosdb sql container create \
  --account-name CHANGE_ME_UNIQUE_NAME \
  --resource-group myResourceGroup \
  --database-name dp900_nosql_ecom \
  --name orders \
  --partition-key-path "/customerId" 
``` 

### Clean up
```bash
az group delete --name myResourceGroup --yes --no-wait
```

## Insert data using python script

### Create .env

Create an .env file with the following content: 
```bash
COSMOS_ENDPOINT=Account_endpoint
COSMOS_KEY=Access_key
COSMOS_DB=dp900_nosql_ecom
COSMOS_CONTAINER=orders
```

### Create virtual env
Create 

```bash
python3 -m venv .venv
``` 
Activate 

```bash
source .venv/bin/activate
``` 
Install dependencies
```bash
pip install -r requirements.txt
``` 
### Execute
```bash
python3 insert-cosmos.py
```

## Example queries

#### Orders and total spending per customer (GROUP BY, SUM, COUNT)

```sql
SELECT 
  c.customerId,
  COUNT(1) AS totalOrders,
  SUM(c.total) AS totalSpent
FROM c
GROUP BY c.customerId
```

#### Expand items and compute line total (JOIN on arrays, expressions)
```sql
SELECT 
  c.id AS orderId,
  i.name AS productName,
  i.qty,
  i.unitPrice,
  (i.qty * i.unitPrice) AS lineTotal
FROM c
JOIN i IN c.items
```

#### Filter by status and date + sorting and pagination (ARRAY_CONTAINS, ORDER BY, OFFSET/LIMIT)

```sql
SELECT 
  c.id, c.customer.name AS customerName, c.status, c.orderDate, c.total
FROM c
WHERE ARRAY_CONTAINS(["Paid","Shipped"], c.status)
  AND c.orderDate >= "2025-11-01T00:00:00Z"
ORDER BY c.orderDate DESC
OFFSET 0 LIMIT 5
```

#### Sales by product category (JOIN, GROUP BY, SUM)

```sql
SELECT
  i.category AS category,
  SUM(i.qty) AS unitsSold,
  SUM(i.qty * i.unitPrice) AS revenue
FROM c
JOIN i IN c.items
GROUP BY i.category
```

#### Recalculate each order’s total using a subquery (subquery, ROUND)

```sql
SELECT
  c.id,
  c.total AS storedTotal,
  (SELECT VALUE ROUND(SUM(i.qty * i.unitPrice), 2) FROM i IN c.items) AS calcTotal
FROM c
```