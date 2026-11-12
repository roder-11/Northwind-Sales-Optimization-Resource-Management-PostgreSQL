	----------------------
----🛒 I. Sales Analysis
-- Objective: To monitor overall sales performance.
	----------------------

-- 1) What are the total annual sales? 📅

SELECT 
	EXTRACT(YEAR FROM O.order_date) As "Year",
	ROUND(SUM(OD.quantity * OD.unit_price)::numeric,2) ||' '||'$' As "Total Sale"
FROM Order_details As OD
INNER JOIN Orders As O ON O.order_id = OD.order_id
GROUP BY EXTRACT(YEAR FROM O.order_date)
ORDER BY ROUND(SUM(OD.quantity * OD.unit_price)::numeric,2) DESC;

-- 2 a) What are the monthly sales?

SELECT 
	TO_CHAR(O.order_date,'Month') As "Months",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$' As "Total Sale"
FROM Order_details As OD
INNER JOIN Orders As O ON O.order_id = OD.order_id
GROUP BY TO_CHAR(O.order_date,'Month')
ORDER BY SUM(OD.quantity * unit_Price) DESC;

-- 2 b) A graph showing monthly sales?

SELECT 
	EXTRACT(MONTH FROM O.order_date) As "Months", 
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) ||' '||'$' As "Total Sale"
FROM Order_details As OD
INNER JOIN Orders As O ON O.order_id = OD.order_id
GROUP BY EXTRACT(MONTH FROM O.order_date)
ORDER BY EXTRACT(MONTH FROM O.order_date) ASC;

-- 3) What is the best-selling product?

SELECT 
	P.product_name As "Products",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$'
FROM Products As P
INNER JOIN Order_details As OD ON P.product_id = OD.product_id
GROUP BY P.product_name
ORDER BY ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) DESC
LIMIT 1;

-- 4) Who are the top 10 customers in terms of revenue?

SELECT 
	C.company_name As "Customers",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$' As "Revenue"
FROM Customers As C
INNER JOIN Orders As O ON C.customer_id = O.customer_id	
INNER JOIN Order_details As OD ON O.order_id = OD.order_id
GROUP BY C.company_name
ORDER BY ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) DESC
LIMIT 10;

-- 5) What is the largest order ever placed?

SELECT 
	O.order_id AS "Orders",
	SUM(OD.Quantity) "Total Of Order"
FROM Orders As O
INNER JOIN  order_details As OD ON O.order_id = OD.order_id
GROUP BY O.order_id
ORDER BY SUM(OD.Quantity) DESC
LIMIT 1;

-- 6) What is the revenue by country?

SELECT 
	O.ship_country As "Countries",
	ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2)||' '||'$'As "Sales"
FROM Orders As O
INNER JOIN Order_details As OD ON O.order_id = OD.order_id
GROUP BY O.ship_country
ORDER BY ROUND(SUM(OD.quantity * OD.unit_Price)::numeric,2) DESC;

-- 7) What is the revenue per employee?

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

-- 8) What is the average time between placing an order and delivery?

SELECT 
	ROUND(AVG(shipped_date - order_date)::numeric,0)||' '||'Days' As "Average Time of delivery"
FROM Orders
WHERE shipped_date IS NOT NULL;

	----------------------
----👨‍💼 II. Customers Behavior
-- Objective: To understand who is buying, how often, and for what amount.
    ----------------------

-- 9) How many active customers do we have?

SELECT 
	COUNT(customer_id) As "Number Of Customer"
FROM customers;

-- 10) Which customer placed the most orders?

SELECT 
	C.Company_name As "Customer",
	COUNT(O.order_id) As "Number of Orders"
FROM customers As C
INNER JOIN Orders As O ON C.customer_id = O.customer_id
GROUP BY C.Company_name
ORDER BY COUNT(O.order_id) DESC
LIMIT 1;

-- 11) Which customers did not place an order in 1997?

SELECT 
    C.company_name AS "Customer with no orders in 1997"
FROM customers AS C	
WHERE C.customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 1997
);

-- 12) Which country has the largest number of customers?

SELECT 
    ship_country AS "Countries",
    COUNT(DISTINCT customer_id) AS "Number of customers"
FROM orders
GROUP BY ship_country
ORDER BY "Number of customers" DESC
LIMIT 1;

-- 13) Who are the most loyal customers (those with recurring orders)?

SELECT 
   C.customer_id,
  C.company_name AS "customers",
  COUNT(O.order_id) AS "number of order"
FROM customers AS C
JOIN orders AS O ON C.customer_id = O.customer_id
GROUP BY C.customer_id, C.company_name
ORDER BY "number of order" DESC
LIMIT 10;

-- 14) What is the average basket value per customer?

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

	----------------------
----📦 III. Produits et Stocks
-- Objectif : Gérer les stocks et identifier les produits clés.
	----------------------
	
-- 15) Which products are out of stock?

SELECT 
	Product_name As "product",
	SUM(units_in_stock) As "Quantity"
FROM Products
GROUP BY "product"
HAVING SUM(units_in_stock) = 0

-- 16) Which 5 products generate the most revenue?

SELECT 
	Product_name As "Products",
	ROUND(SUM(OD.unit_price * OD.Quantity)::numeric,2)||' '|| '$' As "Quantity" 
FROM Products As P
INNER JOIN order_details As OD ON P.product_id = OD.product_id
GROUP BY "Products"
ORDER BY SUM(OD.unit_price * OD.Quantity) DESC
LIMIT 5;

-- 17) What is the average price by category?

SELECT 
	Category_name As "Category",
	ROUND(AVG(unit_price)::numeric,2)||' '|| '$' As "average Price"
FROM Categories As C
INNER JOIN Products As P ON C.category_id = P.category_id
GROUP BY "Category"
ORDER BY ROUND(AVG(unit_price)::numeric,2)||' '|| '$' ASC;

-- 18) Which products hardly sell at all?

SELECT 
	P.product_name As "Products",
    COALESCE(SUM(OD.quantity),0) As "Quantity"
FROM Products As P
LEFT JOIN Order_Details As OD ON P.product_id = OD.product_id	
GROUP BY P.product_name
ORDER BY COALESCE(SUM(OD.quantity),0)


-- 19) What is the total value of the current inventory?

SELECT 
		ROUND(SUM(unit_price * units_in_stock)::numeric,2)||' '||'$' As "total value of the current inventory"
FROM products;
	
-- 20) What products have been added recently?

/*
	There are several reasons why we cannot answer this question:

- None of our tables contain an “Entry_date” column, i.e., “Date Entered”;
- We cannot rely on a product’s first sale date, because the first sale date of a
product does not necessarily correspond to the date it was added to inventory.

	SUGGESTION: To answer this question correctly and track recently added products,
I recommend adding a new column to the Products table that records the date
the product was added to inventory.
    This would allow us to accurately track when each product was added to inventory,
and thus reliably answer questions related to recent inventory additions.

-- Suggested change (not part of the original dataset)
ALTER TABLE products ADD COLUMN date_added DATE DEFAULT CURRENT_DATE;

*/

	----------------------
----👷‍♀️ 4. Employee Performance
-- Objective: Track employees' contribution to sales.
	----------------------
	
-- 21) How many employees are there per management position in this company?

SELECT 
	Title As "position",
	COUNT(employee_id) As "Number of employee"
FROM employees
GROUP BY Title
ORDER BY COUNT(employee_id) DESC;


-- 22) Which employee has processed the most orders?

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

-- 23) Who are the employees' supervisors?

SELECT 
	employee_id As "Employee_id",
	first_name || ' ' || last_name AS "employee_name",
	title As "position"
FROM employees
WHERE title NOT IN ('Sales Representative')

-- 24) What is the average length of service for employees?

SELECT 
   ROUND(AVG(EXTRACT(YEAR FROM(AGE(CURRENT_DATE, hire_date)))),0)||' '|| 'years' AS "Average_Length_of_Service"
FROM employees;

 /*Since I didn't have the hire date, I used the CURRENT_DATE function,
which returns the current date (a day in May 2025)*/

-- 25) Which employees work in the same city?

SELECT 
  city,
  STRING_AGG(first_name || ' ' || last_name, ', ') AS "employees"
FROM employees
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY city;

    ----------------------
----🚚 5. Suppliers
-- Objective: Identify the best suppliers offering competitive prices.
    ----------------------

-- 26) How many suppliers are there?

SELECT
		COUNT(company_name) As "Number of suppliers"
FROM suppliers;
	
-- 27) Which 5 suppliers offer the most products?

SELECT S.company_name As "suppliers",
		COUNT(DISTINCT(P.product_name)) As "number of products"
FROM suppliers As S
INNER JOIN Products As P ON S.supplier_id = P.supplier_id
GROUP BY S.company_name
ORDER BY "number of products" DESC
LIMIT 5;

-- 28) Which product category is most widely represented among suppliers?

SELECT 
		C.category_name As "product category",
		COUNT(DISTINCT(P.product_name)) As "Total of products"
FROM Categories As C
INNER JOIN Products As P ON C.category_id = P.category_id
INNER JOIN Order_Details As OD ON P.product_id = OD.product_id
GROUP BY C.category_name
ORDER BY "Total of products" DESC
LIMIT 1;

-- 29) Which 10 suppliers offer the most competitive prices?

SELECT 
		S.Company_name As "supplier",
		ROUND(AVG(OD.unit_price)::numeric,2)||' '||'$' As "Average Price"
FROM Suppliers As S
INNER JOIN Products As P ON S.supplier_id = P.Supplier_id
INNER JOIN Order_Details As OD ON OD.product_id = P.product_id
GROUP BY S.Company_name
ORDER BY ROUND(AVG(OD.unit_price)::numeric,2) ASC
LIMIT 10;




