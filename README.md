# Northwind-Sales-Optimization-Resource-Management-PostgreSQL
 A SQL analysis of the Northwind database (PostgreSQL) answering 29 business questions on sales, customers, products &amp; stock, employees and suppliers.

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/status-completed-brightgreen)
![Domain](https://img.shields.io/badge/domain-Sales%20%26%20Operations-blue)

---

## 📌 Project Overview

**Northwind** is a fictional company that imports and exports food products worldwide. Its database stores customers, orders, products, suppliers, employees and shippers.

**The goal** of this project is to use SQL to **monitor sales performance, understand customer behavior, manage inventory, evaluate employee contribution and identify competitive suppliers**, in order to support data-driven decisions.

## 🎯 Business Objectives

| # | Theme | Objective | Questions |
|---|-------|-----------|-----------|
| I | 🛒 Sales Analysis | Monitor overall sales performance | Q1 – Q8 |
| II | 👨‍💼 Customer Behavior | Understand who buys, how often and for what amount | Q9 – Q14 |
| III | 📦 Products & Stock | Manage inventory and identify key products | Q15 – Q20 |
| IV | 👷‍♀️ Employee Performance | Track each employee's contribution to sales | Q21 – Q25 |
| V | 🚚 Suppliers | Identify the best suppliers offering competitive prices | Q26 – Q29 |

## 🧱 Database Structure

The database contains **14 tables**:

| Domain | Tables |
|--------|--------|
| Sales | `orders`, `order_details`, `shippers` |
| Customers | `customers`, `customer_demographics`, `customer_customer_demo` |
| Products | `products`, `categories`, `suppliers` |
| Employees | `employees`, `employee_territories`, `territories`, `region` |
| Reference | `us_states` |

<img width="512" height="393" alt="ERD_NorthWind_3" src="https://github.com/user-attachments/assets/207f8510-0f5e-4532-967a-22fb80b8a799" />


## 🔁 Main relationships

- `orders` → `customers`, `employees`, `shippers`
- `order_details` links `orders` and `products` (unit price, quantity, discount)
- `products` → `categories`, `suppliers`
- `employees` → `employees` (`reports_to`, supervisor hierarchy)
- `employees` ↔ `territories` (via `employee_territories`) → `region`

## 🧠 SQL Skills Demonstrated

- `INNER JOIN` / `LEFT JOIN` across multiple tables
- Aggregations: `SUM`, `COUNT`, `AVG`, `ROUND`
- Grouping and filtering: `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT`
- Date functions: `EXTRACT`, `TO_CHAR`, `AGE`, `CURRENT_DATE`
- Subqueries (`NOT IN`, derived tables)
- `COALESCE` for NULL handling
- `STRING_AGG` for text aggregation
- Type casting and formatting (`::numeric`, string concatenation)

---

## ❓ Business Questions & SQL Queries

## 🛒 I. Sales Analysis
*Objective: monitor overall sales performance.*

### 1) What are the total annual sales? 📅

```sql
SELECT 
	EXTRACT(YEAR FROM O.order_date) As "Year",
	ROUND(SUM(OD.quantity * OD.unit_price)::numeric,2) ||' '||'$' As "Total Sale"
FROM Order_details As OD
INNER JOIN Orders As O ON O.order_id = OD.order_id
GROUP BY EXTRACT(YEAR FROM O.order_date)
ORDER BY ROUND(SUM(OD.quantity * OD.unit_price)::numeric,2) DESC;
```

**✅ Result:**

| Year | Total Sale |
| --- | --- |
| 1997 | 658388.75 $ |
| 1998 | 469771.34 $ |
| 1996 | 226298.50 $ |


### 2) What are the monthly sales?

   **a) Monthly sales table**

```sql
SELECT 
	TO_CHAR(O.order_date,'Month') As "Months",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$' As "Total Sale"
FROM Order_details As OD
INNER JOIN Orders As O ON O.order_id = OD.order_id
GROUP BY TO_CHAR(O.order_date,'Month')
ORDER BY SUM(OD.quantity * unit_Price) DESC;
```

**✅ Result:**

| Months | Total Sale |
| --- | --- |
| April | 190329.95 $ |
| January | 167547.52 $ |
| March | 149805.35 $ |
| February | 145769.15 $ |
| December | 128429.66 $ |
| October | 111532.10 $ |
| November | 95617.36 $ |
| September | 87369.02 $ |
| July | 85657.03 $ |
| May | 76722.36 $ |
| August |76591.09 $ |
| June |39088.00 $ |

   **b) Data for a monthly sales graph**

```sql
SELECT 
	EXTRACT(MONTH FROM O.order_date) As "Months", 
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) ||' '||'$' As "Total Sale"
FROM Order_details As OD
INNER JOIN Orders As O ON O.order_id = OD.order_id
GROUP BY EXTRACT(MONTH FROM O.order_date)
ORDER BY EXTRACT(MONTH FROM O.order_date) ASC;
```

**✅ Result:**

| Months | Total Sale |
| --- | --- |
| 1 | 167547.52 $ |
| 2 | 145769.15 $ |
| 3 | 149805.35 $ |
| 4 | 190329.95 $ |
| 5 | 76722.36 $ |
| 6 | 39088.00 $ |
| 7 | 85657.03 $ |
| 8 | 76591.09 $ |
| 9 | 87369.02 $ |
| 10 | 111532.10 $ |
| 11 | 95617.36 $ |
| 12 | 128429.66 $ |

### 3) What is the best-selling product?

```sql
SELECT 
	P.product_name As "Products",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$' AS "Amount"
FROM Products As P
INNER JOIN Order_details As OD ON P.product_id = OD.product_id
GROUP BY P.product_name
ORDER BY ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) DESC
LIMIT 1;
```

**✅ Result:**

| Products | Amount |
| --- | --- |
| Côte de Blaye | 149984.20 $ |


### 4) Who are the top 10 customers in terms of revenue?

```sql
SELECT 
	C.company_name As "Customers",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$' As "Revenue"
FROM Customers As C
INNER JOIN Orders As O ON C.customer_id = O.customer_id	
INNER JOIN Order_details As OD ON O.order_id = OD.order_id
GROUP BY C.company_name
ORDER BY ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) DESC
LIMIT 10;
```

**✅ Result:**

| Customers | Revenue |
| --- | --- |
| QUICK-Stop | 117483.39 $ |
| Save-a-lot Markets | 115673.39 $ |
| Ernst Handel | 113236.68 $ |
| Hungry Owl All-Night Grocers | 57317.39 $ |
| Rattlesnake Canyon Grocery | 52245.90 $ |
| Hanari Carnes | 34101.15 $ |
| Folk och fä HB | 32555.55 $ |
| Mère Paillarde | 32203.90 $ |
| Königlich Essen | 31745.75 $ |
| Queen Cozinha | 30226.10 $ |


### 5) What is the largest order ever placed?

```sql
SELECT 
	O.order_id AS "Orders",
	SUM(OD.Quantity) "Total Of Order"
FROM Orders As O
INNER JOIN  order_details As OD ON O.order_id = OD.order_id
GROUP BY O.order_id
ORDER BY SUM(OD.Quantity) DESC
LIMIT 1;
```

**✅ Result:**

| Orders | Total Of Order |
| --- | --- |
| 10895 | 346 |


### 6) What is the revenue by country?

```sql
SELECT 
	O.ship_country As "Countries",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$'As "Sales"
FROM Orders As O
INNER JOIN Order_details As OD ON O.order_id = OD.order_id
GROUP BY O.ship_country
ORDER BY ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) DESC;
```

**✅ Result:**

| Countries | Sales |
| --- | --- |
| USA | 263566.98 $ |
| Germany | 244640.63 $ |
| Austria | 139496.63 $ |
| Brazil | 114968.48 $ |
| France | 85498.76 $ |
| Venezuela | 60814.89 $ |
| UK | 60616.51 $ |
| Sweden | 59523.70 $ |
| Ireland | 57317.39 $ |
| Canada | 55334.10 $ |

*Showing the first 10 of 21 rows.*


### 7) What is the revenue per employee?

```sql
SELECT 
	E.employee_id As "Employee_ID",
	E.first_name||' '||E.last_name As "Employe_Name",
	E.title As "role",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$'As "Sales"
FROM Employees As E
INNER JOIN Orders As O ON E.employee_id = O.employee_id
INNER JOIN Order_details As OD ON O.order_id = OD.order_id
GROUP BY E.employee_id ,E.title,E.first_name||' '||E.last_name
ORDER BY ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) DESC;
```

**✅ Result:**

| Employee_ID | Employe_Name | role | Sales |
| --- | --- | --- | --- |
| 4 | Margaret Peacock | Sales Representative | 250187.45 $ |
| 3 | Janet Leverling | Sales Representative | 213051.30 $ |
| 1 | Nancy Davolio | Sales Representative | 202143.71 $ |
| 2 | Andrew Fuller | Vice President, Sales | 177749.26 $ |
| 7 | Robert King | Sales Representative | 141295.99 $ |
| 8 | Laura Callahan | Inside Sales Coordinator | 133301.03 $ |
| 9 | Anne Dodsworth | Sales Representative | 82964.00 $ |
| 6 | Michael Suyama | Sales Representative | 78198.10 $ |
| 5 | Steven Buchanan | Sales Manager | 75567.75 $ |


### 8) What is the average time between placing an order and delivery?

```sql
SELECT 
	ROUND(AVG(shipped_date - order_date)::numeric,0)||' '||'Days' As "Average Time of delivery"
FROM Orders
WHERE shipped_date IS NOT NULL;
```

**✅ Result:**

| Average Time of delivery |
| --- |
| 8 Days |


---

## 👨‍💼 II. Customer Behavior
*Objective: understand who is buying, how often, and for what amount.*

### 9) How many active customers do we have?

```sql
SELECT 
	COUNT(customer_id) As "Number Of Customers"
FROM customers;
```

**✅ Result:**

| Number Of Customers |
| --- |
| 91 |


### 10) Which customer placed the most orders?

```sql
SELECT 
	C.Company_name As "Customer",
	COUNT(O.order_id) As "Number of Orders"
FROM customers As C
INNER JOIN Orders As O ON C.customer_id = O.customer_id
GROUP BY C.Company_name
ORDER BY COUNT(O.order_id) DESC
LIMIT 1;
```

**✅ Result:**

| Customer | Number of Orders |
| --- | --- |
| Save-a-lot Markets | 31 |


### 11) Which customers did not place an order in 1997?

```sql
SELECT 
    C.company_name AS "Customer with no orders in 1997"
FROM customers AS C	
WHERE C.customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 1997
);
```

**✅ Result:**

| Customer with no orders in 1997 |
| --- |
| Centro comercial Moctezuma |
| FISSA Fabrica Inter. Salchichas S.A. |
| La corne d'abondance |
| Paris spécialités |
| Romero y tomillo |


### 12) Which country has the largest number of customers?

```sql
SELECT 
    ship_country AS "Countries",
    COUNT(DISTINCT customer_id) AS "Number of customers"
FROM orders
GROUP BY ship_country
ORDER BY "Number of customers" DESC
LIMIT 1;
```

**✅ Result:**

| Countries | Number of customers |
| --- | --- |
| USA | 13 |


### 13) Who are the most loyal customers (those with recurring orders)?

```sql
SELECT 
   C.customer_id,
   C.company_name AS "customers",
   COUNT(O.order_id) AS "number of order"
FROM customers AS C
JOIN orders AS O ON C.customer_id = O.customer_id
GROUP BY C.customer_id, C.company_name
ORDER BY "number of order" DESC
LIMIT 10;
```

**✅ Result:**

| customer_id | customers | number of order |
| --- | --- | --- |
| SAVEA | Save-a-lot Markets | 31 |
| ERNSH | Ernst Handel | 30 |
| QUICK | QUICK-Stop | 28 |
| FOLKO | Folk och fä HB | 19 |
| HUNGO | Hungry Owl All-Night Grocers | 19 |
| RATTC | Rattlesnake Canyon Grocery | 18 |
| BERGS | Berglunds snabbköp | 18 |
| HILAA | HILARION-Abastos | 18 |
| BONAP | Bon app' | 17 |
| FRANK | Frankenversand | 15 |


### 14) What is the average basket value per customer?

```sql
SELECT 
	ROUND(AVG(sub."total of customer")::numeric, 2) AS "average basket per customer"
FROM (
  SELECT 
    C.customer_id,
    SUM(OD.unit_price * OD.quantity)::numeric / COUNT(DISTINCT O.order_id)::numeric AS "total of customer"
  FROM customers AS C
  JOIN orders AS O ON C.customer_id = O.customer_id
  JOIN order_details AS OD ON O.order_id = OD.order_id
  GROUP BY C.customer_id
) AS sub;
```

**✅ Result:**

| average basket per customer |
| --- |
| 1229.54 |


---

## 📦 III. Products & Stock
*Objective: manage inventory and identify key products.*

### 15) Which products are out of stock?

```sql
SELECT 
	Product_name As "product",
	SUM(units_in_stock) As "Quantity"
FROM Products
GROUP BY "product"
HAVING SUM(units_in_stock) = 0;
```

**✅ Result:**

| product | Quantity |
| --- | --- |
| Thüringer Rostbratwurst | 0 |
| Gorgonzola Telino | 0 |
| Chef Anton's Gumbo Mix | 0 |
| Alice Mutton | 0 |
| Perth Pasties | 0 |


### 16) Which 5 products generate the most revenue?

```sql
SELECT 
	Product_name As "Products",
	ROUND(SUM(OD.unit_price * OD.Quantity)::numeric,2)||' '|| '$' As "Quantity" 
FROM Products As P
INNER JOIN order_details As OD ON P.product_id = OD.product_id
GROUP BY "Products"
ORDER BY SUM(OD.unit_price * OD.Quantity) DESC
LIMIT 5;
```

**✅ Result:**

| Products | Quantity |
| --- | --- |
| Côte de Blaye | 149984.20 $ |
| Thüringer Rostbratwurst | 87736.40 $ |
| Raclette Courdavault | 76296.00 $ |
| Camembert Pierrot | 50286.00 $ |
| Tarte au sucre | 49827.90 $ |


### 17) What is the average price by category?

```sql
SELECT 
	Category_name As "Category",
	ROUND(AVG(unit_price)::numeric,2)||' '|| '$' As "average Price"
FROM Categories As C
INNER JOIN Products As P ON C.category_id = P.category_id
GROUP BY "Category"
ORDER BY ROUND(AVG(unit_price)::numeric,2)||' '|| '$' ASC;
```

**✅ Result:**

| Category | average Price |
| --- | --- |
| Grains/Cereals | 20.25 $ |
| Seafood | 20.68 $ |
| Condiments | 22.85 $ |
| Confections | 25.16 $ |
| Dairy Products | 28.73 $ |
| Produce | 32.37 $ |
| Beverages | 37.98 $ |
| Meat/Poultry | 54.01 $ |


### 18) Which products hardly sell at all?

```sql
SELECT 
	P.product_name As "Products",
    COALESCE(SUM(OD.quantity),0) As "Quantity"
FROM Products As P
LEFT JOIN Order_Details As OD ON P.product_id = OD.product_id	
GROUP BY P.product_name
ORDER BY COALESCE(SUM(OD.quantity),0);
```

**✅ Result:**

| Products | Quantity |
| --- | --- |
| Mishi Kobe Niku | 95 |
| Genen Shouyu | 122 |
| Gravad lax | 125 |
| Chocolade | 138 |
| Laughing Lumberjack Lager | 184 |
| Valkoinen suklaa | 235 |
| Louisiana Hot Spiced Okra | 239 |
| Röd Kaviar | 293 |
| Mascarpone Fabioli | 297 |
| Longlife Tofu | 297 |

*Showing the first 10 of 77 rows.*


### 19) What is the total value of the current inventory?

```sql
SELECT 
	ROUND(SUM(unit_price * units_in_stock)::numeric,2)||' '||'$' As "total value of the current inventory"
FROM products;
```

**✅ Result:**

| total value of the current inventory |
| --- |
| 73953.35 $ |


### 20) What products have been added recently?

> ⚠️ **This question cannot be answered with the current data.**
> - None of the tables contains an entry date column (e.g. `entry_date`).
> - A product's first sale date cannot be used, because it does not necessarily match the date the product was added to inventory.
>
> **💡 Recommendation:** add a column to the `Products` table that records the date each product was added to inventory.  This would allow us to accurately track when each product was added to inventory, and thus reliably answer questions related to recent inventory additions.

```sql
-- Suggested change (not part of the original dataset)
ALTER TABLE products ADD COLUMN date_added DATE DEFAULT CURRENT_DATE;
```

---

## 👷‍♀️ IV. Employee Performance
*Objective: track employees' contribution to sales.*

### 21) How many employees are there per position?

```sql
SELECT 
	Title As "position",
	COUNT(employee_id) As "Number of employee"
FROM employees
GROUP BY Title
ORDER BY COUNT(employee_id) DESC;
```

**✅ Result:**

| position | Number of employee |
| --- | --- |
| Sales Representative | 6 |
| Vice President, Sales | 1 |
| Inside Sales Coordinator | 1 |
| Sales Manager | 1 |


### 22) Which employee has processed the most orders?

```sql
SELECT 
	E.employee_id As "employee_id",
	E.first_name || ' ' || E.last_name AS "employee",
	E.title As "position",
	SUM(OD.Quantity) As "Total_Processed_Order"
FROM employees As E
INNER JOIN Orders As O ON E.employee_id = O.employee_id
INNER JOIN Order_Details As OD ON O.order_id = OD.order_id
GROUP BY E.employee_id,E.first_name || ' ' || E.last_name,E.title
ORDER BY SUM(OD.Quantity) DESC
LIMIT 1;
```

**✅ Result:**

| employee_id | employee | position | Total_Processed_Order |
| --- | --- | --- | --- |
| 4 | Margaret Peacock | Sales Representative | 9798 |


### 23) Who are the employees' supervisors?

```sql
SELECT 
	employee_id As "Employee_id",
	first_name || ' ' || last_name AS "employee_name",
	title As "position"
FROM employees
WHERE title NOT IN ('Sales Representative');
```

**✅ Result:**

| Employee_id | employee_name | position |
| --- | --- | --- |
| 2 | Andrew Fuller | Vice President, Sales |
| 5 | Steven Buchanan | Sales Manager |
| 8 | Laura Callahan | Inside Sales Coordinator |


### 24) What is the average length of service for employees?

```sql
SELECT 
   ROUND(AVG(EXTRACT(YEAR FROM(AGE(CURRENT_DATE, hire_date)))),0)||' '|| 'years' AS "Average_Length_of_Service"
FROM employees;
```

**✅ Result:**

| Average_Length_of_Service |
| --- |
| 33 years |

*Computed on 12 Nov 2026: the value grows with the run date.*


> The calculation uses `CURRENT_DATE`, so the result depends on the date the query is run.

### 25) Which employees work in the same city?

```sql
SELECT 
  city,
  STRING_AGG(first_name || ' ' || last_name, ', ') AS "employees"
FROM employees
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY city;
```

**✅ Result:**

| city | employees |
| --- | --- |
| London | Steven Buchanan, Michael Suyama, Robert King, Anne Dodsworth |
| Seattle | Nancy Davolio, Laura Callahan |


---

## 🚚 V. Suppliers
*Objective: identify the best suppliers offering competitive prices.*

### 26) How many suppliers are there?

```sql
SELECT
	COUNT(company_name) As "Number of suppliers"
FROM suppliers;
```

**✅ Result:**

| Number of suppliers |
| --- |
| 29 |


### 27) Which 5 suppliers offer the most products?

```sql
SELECT S.company_name As "suppliers",
	   COUNT(DISTINCT(P.product_name)) As "number of products"
FROM suppliers As S
INNER JOIN Products As P ON S.supplier_id = P.supplier_id
GROUP BY S.company_name
ORDER BY "number of products" DESC
LIMIT 5;
```

**✅ Result:**

| suppliers | number of products |
| --- | --- |
| Pavlova, Ltd. | 5 |
| Specialty Biscuits, Ltd. | 5 |
| Plutzer Lebensmittelgroßmärkte AG | 5 |
| New Orleans Cajun Delights | 4 |
| Grandma Kelly's Homestead | 3 |


### 28) Which product category is most widely represented among suppliers?

```sql
SELECT 
	C.category_name As "product category",
	COUNT(DISTINCT(P.product_name)) As "Total of products"
FROM Categories As C
INNER JOIN Products As P ON C.category_id = P.category_id
INNER JOIN Order_Details As OD ON P.product_id = OD.product_id
GROUP BY C.category_name
ORDER BY "Total of products" DESC
LIMIT 1;
```

**✅ Result:**

| product category | Total of products |
| --- | --- |
| Confections | 13 |


### 29) Which 10 suppliers offer the most competitive prices?

```sql
SELECT 
	S.Company_name As "supplier",
	ROUND(AVG(OD.unit_price)::numeric,2) ||' '||'$' As "Average Price"
FROM Suppliers As S
INNER JOIN Products As P ON S.supplier_id = P.Supplier_id
INNER JOIN Order_Details As OD ON OD.product_id = P.product_id
GROUP BY S.Company_name
ORDER BY ROUND(AVG(OD.unit_price)::numeric,2) ASC
LIMIT 10;
```

**✅ Result:**

| supplier | Average Price |
| --- | --- |
| Refrescos Americanas LTDA | 4.24 $ |
| Zaanse Snoepfabriek | 9.75 $ |
| Lyngbysild | 10.47 $ |
| Mayumi's | 11.57 $ |
| Escargots Nouveaux | 12.66 $ |
| New England Seafood Cannery | 12.94 $ |
| PB Knäckebröd AB | 13.32 $ |
| Ma Maison | 14.26 $ |
| Bigfoot Breweries | 15.32 $ |
| Exotic Liquids | 16.08 $ |


## 💡 Data Gap & Recommendation (Q20)

The question *"What products have been added recently?"* cannot be answered reliably: no table contains an entry date, and the first sale date of a product does not equal the date it was added to inventory.

**Recommendation:** add a `date_added` column to the `products` table to track when each product enters the inventory.

## 🚀 How to Run the Project

**Prerequisites:** PostgreSQL and a client (pgAdmin, DBeaver or `psql`).


## 🛠️ Tools

- **PostgreSQL** – database engine
- **DBeaver / pgAdmin** – SQL client and ERD
- **GitHub** – version control and documentation

## 👤 Author

**Jean Rodrigue Awono** – Business Intelligence & Data Analyst, moving toward Data Engineering

🔗 [LinkedIn](https://www.linkedin.com/) · 💻 [GitHub Portfolio](https://github.com/Jean-Rodrigue-Awono)
