SELECT * FROM CUSTOMERS;

-- Analysis on Customers Table --

SELECT * FROM 
CUSTOMERS;

-- Calculating Duplicates
SELECT COUNT(*), customers.* FROM customers
GROUP BY customernumber
HAVING COUNT(*) > 1;

SELECT DISTINCT customername, salesrepemployeenumber
FROM Customers;

SELECT * FROM 
customers 
WHERE addressLine2 IS NULL;

SELECT * FROM 
customers 
WHERE state IS NULL;

SELECT * FROM customers
WHERE postalcode IS NULL;

-- Analysis on employees Table --

select * from employees;

SELECT COUNT(*), employees.* FROM employees
GROUP BY employeenumber
HAVING COUNT(*) > 1;

-- Analysis on offices Table--

SELECT * FROM offices;

SELECT COUNT(*), offices.* FROM offices
GROUP BY officecode
HAVING COUNT(*) > 1;

-- Analysis on orderdetail Table--

SELECT * FROM Orderdetails;

SELECT COUNT(*), Orderdetails.* FROM Orderdetails
GROUP BY ordernumber, productcode
HAVING COUNT(*) > 1;


-- Analysis on Orders Table--

SELECT * FROM orders;

SELECT * FROM 
orders
WHERE comments IS NULL;

SELECT COUNT(*), ORDERS.* FROM orders
GROUP BY ordernumber
HAVING COUNT(*) > 1;

-- Analysis on Payments--

SELECT * FROM payments;

SELECT COUNT(*), payments.* FROM payments
GROUP BY customernumber, checknumber
HAVING COUNT(*) > 1;


SELECT * FROM ORDERDETAILS;


SELECT * FROM PAYMENTS;

SELECT * FROM PRODUCTS;

SELECT * from PRODUCTLINEs;




-- CLV = 
-- VAR AvgPurchaseValue = AVERAGEX(SUMMARIZE('classicmodels orders', 'classicmodels orders'[customerNumber], "TotalPurchase", SUMX('classicmodels orderDetails', 'classicmodels orderDetails'[quantityOrdered] * 'classicmodels orderDetails'[priceEach])), [TotalPurchase])
-- VAR PurchaseFrequency = AVERAGEX(COUNTROWS('classicmodels orders'), [TotalOrders])
-- VAR CustomerLifespan = [End date of analysis period] - [Start date of analysis period]  // You need to replace these with actual dates
-- RETURN
--     AvgPurchaseValue * PurchaseFrequency * CustomerLifespan


-- Unselecting customers which have not placed any orders till date, bu t might have purchased earlier to 2003
SELECT c.customernumber, c.customername,c.creditlimit,  COUNT(o.ordernumber) as Count_of_Orders 
FROM customers c
left join ORDERS o using(customernumber)
GROUP BY c.customernumber
HAVING COUNT(o.ordernumber) <=0
ORDER BY customerNumber;


-- Finding total countries in offices and customeries countries


SELECT c.customernumber, c.customername, c.country, o.country
from customers c 
LEFT JOIN offices o using(country)
WHERE o.country IS NULL;


-- What are the different Status modes?
SELECT DISTINCT STATUS FROM 
ORDERS;

-- ---------------------------------------------------------------------

-- Top 10 Customers by Sales Revenue:

SELECT C.CustomerNumber, C.CustomerName, C.Country, SUM(od.quantityOrdered * od.priceEach) as Sales_Revenue
FROM Customers c 
LEFT JOIN Orders o USING(CustomerNumber)
LEFT JOIN Orderdetails od USING(OrderNumber)
GROUP BY C.CustomerNumber, C.CustomerName, C.Country
ORDER BY Sales_Revenue DESC
LIMIT 10;

-- Product Sales by Category and Year:

SELECT pl.ProductLine, YEAR(OrderDate) as Year, SUM(od.QuantityOrdered) as Order_Quantity, SUM(od.quantityordered * od.priceeach) as Sales_Revenue
FROM ProductLines pl
LEFT JOIN Products p USING(productline)
LEFT JOIN Orderdetails od USING(productcode)
INNER JOIN Orders o USING(ordernumber)
GROUP BY pl.ProductLine, Year
ORDER BY pl.ProductLine, Year;


SELECT
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    COUNT(DISTINCT o.orderNumber) AS totalOrders,
    SUM(od.quantityOrdered * od.priceEach) AS totalSalesRevenue
FROM
    employees e
JOIN
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN
    orders o ON c.customerNumber = o.customerNumber
JOIN
    orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY
    e.employeeNumber,
    e.firstName,
    e.lastName
ORDER BY
    totalSalesRevenue DESC;

-- --

SELECT * FROM ORDERS
ORDER BY ORDERDATE desc;


