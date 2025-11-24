### Prerequisites

| Program |Link |
| ----------- | ----------- |
| Azure CLI | https://learn.microsoft.com/es-es/cli/azure/install-azure-cli-windows?view=azure-cli-latest |
| Visual Studio Code | https://code.visualstudio.com/Download |
| Power BI | https://www.python.org/downloads/ |
| SQL Server (mssql) Plugin | https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql |

You must also have access to the **Azure SQL Database** created earlier in the lab [Session 5](./session-5/azuresql/README.md). 

---

### 2. Connect Power BI to Azure SQL Database

1. Open **Power BI Desktop**
2. Select **Get Data → Azure → Azure SQL Database**
3. Enter:
   - **Server**: `<your-sql-server>.database.windows.net`
   - **Database**: `dp900_sql_ecom`
4. Choose **DirectQuery** connectivity mode
5. Authenticate using your SQL login
6. Select and load the following tables:
   - `Customers`
   - `Products`
   - `Orders`
   - `OrderDetails`
---


### 3. Create Calculated Fields (Measures)

#### Total Revenue
```DAX
Total Revenue = SUM ( Orders[TotalAmount] )
```

#### Average Order Value
```DAX
Average Order Value = 
DIVIDE( [Total Revenue], COUNTROWS(Orders) )
```

#### Total Items Sold
```DAX
Total Items Sold =
SUMX ( OrderDetails, OrderDetails[Quantity] )
```
---
### 4. Card: Create cards using the new measures


1. Insert a **Card** visual:
   - **Value** → `previous section measure`

---
### 5. Line Chart: Total Revenue by Year

Add column Year to Orders table
```DAX
Year = YEAR(Orders[OrderDate])
```

1. Insert a **Line Chart**
2. Set:
   - **X-axis** → `Calendar[Year]`
   - **Y-axis** → `[Total Revenue]`
3. Format → X-axis:
   - **Type = Categorical**
4. Optional:
   - Legend → `Orders[Status]`

---
### 6. Azure Map: Customers by Country

1. Create:
```DAX
Distinct Customer Count = DISTINCTCOUNT(Customers[CustomerID])
```

2. Insert a **Azure Map** visual:
   - **Location** → `Customers[Country]`
   - **Tooltops** → `Customers[Distinct Customer Count]`

---
### 7. Funnel: Order status

1. Create:
```DAX
Order Count = COUNTROWS(Orders)
```

2. Insert a **Funnel** visual:
   - **Category** → `Orders[Status]`
   - **Status** → `Orders[Order Count]`

### 8. KPIS: Total Revenue, Total customers

1. Insert a **KPI** visual:
   - **Value** → `Orders[Total Customers]`
   - **Trend axis** → `Orders[Year]`

2. Insert a **KPI** visual:
   - **Value** → `Orders[Total Revenue]`
   - **Trend axis** → `Orders[Year]`   

---
### 9. Donut Chart: Total Revenue by Status

1. Insert a **Donut chart** visual:
   - **Legend** → `Orders[Status]`
   - **Values** → `Total[Revenue]`  

---
### 10. Slicer: Year, Status   

1. Insert a **Slicer** visual:
   - **Field** → `Orders[Year]`

2. Insert a **Slicer** visual:
   - **Field** → `Orders[Status]`