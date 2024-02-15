-- Calculating Duplicates
SELECT COUNT(*), customers.* FROM customers
GROUP BY customernumber
HAVING COUNT(*) > 1;

SELECT COUNT(*), employees.* FROM employees
GROUP BY employeenumber
HAVING COUNT(*) > 1;

SELECT COUNT(*), offices.* FROM offices
GROUP BY officecode
HAVING COUNT(*) > 1;

SELECT COUNT(*), Orderdetails.* FROM Orderdetails
GROUP BY ordernumber, productcode
HAVING COUNT(*) > 1;

SELECT COUNT(*), ORDERS.* FROM orders
GROUP BY ordernumber
HAVING COUNT(*) > 1;

SELECT COUNT(*), payments.* FROM payments
GROUP BY customernumber, checknumber
HAVING COUNT(*) > 1;

-- Finding Sales Rep for respective customers
-- This query associates each customer with their respective sales representative, facilitating sales performance analysis and customer relationship management.
SELECT DISTINCT customername, salesrepemployeenumber
FROM Customers;


-- Since there are multiple missing address in column 'addresline2' which further makes it not much useful hence we delete it from Power BI tables.
-- Hence by below query find that almost 100 rows are missing out of 122, and I confirmed to delete the column from Power BI
SELECT * FROM 
customers 
WHERE addressLine2 IS NULL;

-- Since there are multiple missing state in column 'state' which further makes it not much useful hence we delete it from Power BI tables.
-- Hence by below query find that almost 73 rows are missing out of 122, and hence I confirmed to delete the column from Power BI
SELECT * FROM 
customers 
WHERE state IS NULL;

-- Finding null values in Postal code from customers table, since there are only 7 rows incomplete and won't be using for analysis, I kept it as it is in Power BI.
SELECT * FROM customers
WHERE postalcode IS NULL;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Unselecting (in Power BI) customers which have not placed any orders till date, but might have purchased earlier to 2003
-- These below queried customer were an road block on Dashboard as they had no orders placed and were mentioned as "Blank" on orders section/KPI/Charts. 
SELECT c.customernumber, c.customername,c.creditlimit,  COUNT(o.ordernumber) as Count_of_Orders 
FROM customers c
left join ORDERS o using(customernumber)
GROUP BY c.customernumber
HAVING COUNT(o.ordernumber) <=0
ORDER BY customerNumber;

-- Finding customers with creditlimit as "0"
SELECT * FROM CUSTOMERS
WHERE CREDITLIMIT = 0;

-- From above queries we confirm that customers who have not placed any orders are customers who have 0 creditlimit or they might have placed orders earlier to 2003 
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- What are the different Status modes?
SELECT DISTINCT STATUS FROM 
ORDERS;

-- Total number of orders as per current order Status
SELECT Status, COUNT(OrderNumber) as Total_Orders
FROM ORDERS
GROUP BY Status;

-- ---------------------------------------------------------------------
-- Top 10 Customers by Sales Revenue:
-- Identifying top customers by sales revenue helps prioritize relationship management and target high-value customers for retention efforts.

SELECT C.CustomerNumber, C.CustomerName, C.Country, SUM(od.quantityOrdered * od.priceEach) as Sales_Revenue
FROM Customers c 
LEFT JOIN Orders o USING(CustomerNumber)
LEFT JOIN Orderdetails od USING(OrderNumber)
GROUP BY C.CustomerNumber, C.CustomerName, C.Country
ORDER BY Sales_Revenue DESC
LIMIT 10;

-- Top 10 countries by Sales
-- This query highlights the countries contributing the most to sales revenue, aiding in international market analysis and strategic planning.

SELECT C.Country, SUM(od.quantityOrdered * od.priceEach) as Sales_Revenue
FROM Customers c 
LEFT JOIN Orders o USING(CustomerNumber)
LEFT JOIN Orderdetails od USING(OrderNumber)
GROUP BY C.Country
ORDER BY Sales_Revenue DESC
LIMIT 10;

-- Product Sales by Category and Year:
-- Analyzing product sales by category and year offers insights into product line performance and helps identify trends and opportunities for product optimization.
SELECT pl.ProductLine, YEAR(OrderDate) as Year, SUM(od.QuantityOrdered) as Order_Quantity, SUM(od.quantityordered * od.priceeach) as Sales_Revenue
FROM ProductLines pl
LEFT JOIN Products p USING(productline)
LEFT JOIN Orderdetails od USING(productcode)
INNER JOIN Orders o USING(ordernumber)
GROUP BY pl.ProductLine, Year
ORDER BY pl.ProductLine, Year;

-- Sales Revenue by Employees
-- Associating sales revenue with employees allows for performance evaluation and incentivization based on sales contribution.
SELECT CONCAT(e.firstname," ", e.lastname) as Employee, COUNT(DISTINCT O.Ordernumber) as Orders, SUM(od.quantityordered * od.priceeach) as Sales_revenue
FROM EMPLOYEES E 
RIGHT JOIN CUSTOMERS C ON C.salesRepEmployeeNumber = E.employeenumber
RIGHT JOIN ORDERS o USING(customernumber)
INNER JOIN ORDERDETAILS od USING(ordernumber)
GROUP BY CONCAT(e.firstname," ", e.lastname)
ORDER BY Sales_revenue DESC;

-- Top 10 Selling Products
-- Identifying top-selling products helps in inventory management, marketing strategies, and product promotion planning.
SELECT od.ProductCode,p.productname, p.productline ,COUNT(od.productcode) as Total_Orders
FROM PRODUCTS p 
LEFT JOIN ORDERDETAILS od USING(productcode)
GROUP BY od.ProductCode,p.productname, p.productline
ORDER BY Total_orders DESC
LIMIT 10;

-- Analyzing sales performance over time provides insights into seasonal trends, market dynamics, and business cycle fluctuations.
-- Yearly Sales
SELECT YEAR(O.orderdate) as Year, SUM(OD.quantityordered * OD.priceeach) as Total_Revenue
FROM ORDERS O 
INNER JOIN ORDERDETAILS OD USING(ordernumber) 
GROUP BY YEAR(O.orderdate);

-- Monthly sales
SELECT YEAR(O.orderdate) as Year, MONTHNAME(O.orderdate) as Month, SUM(OD.quantityordered * OD.priceeach) as Total_Revenue
FROM ORDERS O 
INNER JOIN ORDERDETAILS OD USING(ordernumber) 
GROUP BY YEAR(O.orderdate), MONTHNAME(O.orderdate);

-- Quarterly Sales 
SELECT YEAR(O.orderdate) as Year, QUARTER(O.orderdate) as Quarter, SUM(OD.quantityordered * OD.priceeach) as Total_Revenue
FROM ORDERS O 
INNER JOIN ORDERDETAILS OD USING(ordernumber) 
GROUP BY YEAR(O.orderdate), QUARTER(O.orderdate);

-- Customer who have placed more than 1 orders (Repetetion of orders by customers)
-- This query provides insights into customer behavior by analyzing the frequency of orders placed by each customer.
SELECT o.CustomerNumber, c.Customername, COUNT(DISTINCT o.orderDate) AS Order_Numbers
FROM Orders o
INNER JOIN Customers c USING(customernumber)
GROUP BY o.customerNumber, c.customername
HAVING COUNT(DISTINCT o.orderDate) > 1
ORDER BY Order_Numbers DESC;

-- Finding Repeat Customers
WITH RepeatCustomers AS 
(
    SELECT customerNumber,COUNT(DISTINCT orderDate) AS Order_Numbers
    FROM Orders
    GROUP BY customerNumber
    HAVING COUNT(DISTINCT orderDate) > 1
)
SELECT COUNT(*) AS Number_Of_Repeated_Customers, ROUND(COUNT(*) *100.0 / (SELECT COUNT(*) FROM Customers),0) AS Customer_Repetition_Rate
FROM RepeatCustomers;

-- Maximum Sales By Year 
SELECT Year, sum(Total_Sales_Amount) AS Maximum_Sales_Amount
FROM (
    SELECT YEAR(O.Orderdate) AS Year, (OD.QUANTITYORDERED * OD.PRICEEACH) AS Total_Sales_Amount
    FROM Orders O 
    INNER JOIN ORDERDETAILS OD USING (OrderNumber)
) AS Sales_By_Year
GROUP BY Year;


-- Customer Order Frequency 
SELECT customerNumber, COUNT(orderNumber) AS Total_Orders
FROM orders
GROUP BY customerNumber
ORDER BY Total_Orders DESC;

-- Customers by Location 
SELECT country, COUNT(customerNumber) AS Total_Customers
FROM customers
GROUP BY country
ORDER BY Total_Customers DESC;

-- Product Sales Performance Over Time
SELECT productName, YEAR(orderDate) AS Year, SUM(quantityOrdered * priceEach) AS Total_Sales_Revenue
FROM products
INNER JOIN orderdetails USING(productCode)
INNER JOIN orders USING(orderNumber)
GROUP BY productName, Year
ORDER BY productName, Year;

-- Product Line Revenue / Year
SELECT productLine, YEAR(orderDate) AS Year, SUM(quantityOrdered * priceEach) AS Total_Sales_Revenue
FROM products
INNER JOIN orderdetails USING(productCode)
INNER JOIN orders USING(orderNumber)
GROUP BY productLine, Year
ORDER BY productLine, Year;

-- Employee Sales Contribution Percentage
SELECT CONCAT(firstname, ' ', lastname) AS Employee_Name, SUM(quantityordered * PRICEEACH) AS Total_Sales_Revenue,
       SUM(quantityordered * priceeach) / (SELECT SUM(QuantityOrdered * priceEach) FROM orderdetails) * 100 AS Contribution_Percentage
FROM employees
INNER JOIN CUSTOMERS ON employees.employeeNumber = customers.salesRepEmployeeNumber
INNER JOIN Orders USING(customerNumber)
INNER JOIN ORDERDETAILS USING(ORDERNUMBER)
GROUP BY Employee_Name
ORDER BY Total_Sales_Revenue DESC;

-- Which are the products often purchased together
SELECT od1.productcode AS product1, od2.productcode AS product2, COUNT(DISTINCT od1.ordernumber) AS order_count
FROM orderdetails od1
INNER JOIN orderdetails od2 ON od1.ordernumber = od2.ORDERNUMBER
WHERE od1.productCode < od2.PRODUCTCODE
GROUP BY product1, product2
ORDER BY order_count DESC;

-- This query calculates the Net Promoter Score (NPS) by subtracting the percentage of customers who reported aS Disputed orders from the percentage of customers who reported as Shipped orders.
SELECT ROUND((COUNT
				(CASE WHEN status = 'Shipped' THEN 1 END) - COUNT(CASE WHEN status = 'Disputed' THEN 1 END)) * 100.0 / COUNT(orderNumber), 2) AS NPS
FROM orders;

-- Customer Satisfication Score 
-- This query calculates the Customer Satisfaction Score (CSAT) by averaging the percentage of orders marked as 'Shipped' for each month.
SELECT YEAR(orderDate) AS Year, MONTH(orderDate) AS Month, round(AVG(CASE WHEN status = 'Shipped' THEN 1 ELSE 0 END) * 100, 2) AS CSAT
FROM orders
GROUP BY year, month;

