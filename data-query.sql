-- using https://www.mysqltutorial.org/tryit/

-- display all columns from all rows
select * from employees;

-- select <column names>
SELECT firstName, lastName,email FROM employees;

-- select column and rename them
SELECT firstname AS 'First Name', lastName as 'Last Name' FROM employees;

-- select row where officeCode is 1
SELECT * FROM employees WHERE officeCode = 1;
--only show first name, last name, email and office code for rows where office code is 1
SELECT firstName, lastName, email, officeCode FROM employees WHERE officeCode = 1;
-- offices eg.
SELECT city,addressLine1,addressLine2 FROM offices WHERE country = "USA";

-- use LIKE with wildcard(%) to match partial strings
-- %sales% will match as long as the word 'sales' appear anywhere in jobTitle
SELECT * FROM employees WHERE jobTitle LIKE "%Sales%";
-- %sales will match as long as the job title starts with sales;
SELECT * FROM employees WHERE jobTitle LIKE "Sale%"; 
-- %sales will match as long as the job title ends with sales;
SELECT * FROM employees WHERE jobTitle LIKE "%Sales";
-- eg. from products
-- find all products which names begins with 1969
SELECT * FROM products WHERE productName LIKE "1969%";
-- find all products which name contains string 'Davidson'
SELECT * FROM products WHERE productName LIKE "%Davidson%";

--filter for multiple conditions  using logical operators
SELECT * FROM employees WHERE officeCode = 1 AND jobTitle LIKE 'Sales Rep';
--find all employees from office code 1 or office code 2
SELECT * FROM employees WHERE officeCode = 1 OR officeCode = 2;

-- show all the sales rep from office code 1 or office code 2
-- OR has lower priority than AND
SELECT * FROM employees WHERE jobTitlte LIKE "Sales Rep" AND (officeCode = 1 OR officeCode = 2);

-- show all the customers from the USA in the state NV
-- who has credit limit more than 5000 OR all customers from any country
-- which credit limit more than 10000
SELECT * FROM customers WHERE (country="USA" AND state="NV" AND creditLIMIT > 5000) OR (creditLimit > 10000)

--join employee and offices table by office code
SELECT firstName, lastName, city, addressLine1, addressLine2 FROM employees JOIN offices
	ON employees.officeCode = offices.officeCode
	WHERE country="USA";

-- show customerName along with firstName, lastName and email of their sales rep
select customerName, firstName, lastName, email FROM customers JOIN employees
	ON customers.salesRepEmployeeNumber = employees.employeeNumber;

    --LEFT JOIN
    -- all rows on the left guaranteed to have a result regardless of whether null for sales rep
    -- will show up for all customers regardless of whether they have sales rep

    --RIGHT JOIN
    --will show up for all employees regardless of whether they have customers

-- for each customer, show their country and the name of their sales rep and office number
-- for customers in USA
SELECT customerName AS "Customer Name", customers.country AS "Customer Country", firstName AS 'Sales Rep first name', lastName AS 'Sales Rep last name', offices.phone AS 'Office phone' FROM customers JOIN employees
	ON customers.salesRepEmployeeNumber = employees.employeeNumber
	JOIN offices ON employees.officeCode = offices.OfficeCode
	WHERE customers.country = "USA"

-- Date manipulation

-- tell you currrent date on server
SELECT curdate();

-- date and time
SELECT now();
-- payments for date after 2003-06-30
SELECT * FROM payments WHERE paymentDate > "2003-06-30"

-- show all payments between 01 Jan 2003 and 20 Jun 2003
SELECT * from payments WHERE paymentDate >= "2003-01-01" AND paymentDate <= "2003-06-30"
SELECT * from payments WHERE paymentDate BETWEEN "2003-01-01" AND "2003-06-30"

-- display year where payment was made
-- show all payments made in the year 2003
SELECT checkNumber, YEAR(paymentDate) from payments where YEAR(paymentDate) =2003;

-- show by year, month and day
SELECT checkNumber, YEAR(paymentDate), MONTH(paymentDate), DAY(PaymentDate) from payments

-- HANDS ON
-- Q1
SELECT city,phone,country FROM offices;
-- Q2
SELECT * FROM orders WHERE comments LIKE "%fedex%";
-- Q3
SELECT contactFirstName, contactLastName FROM customers
	ORDER BY customerName DESC;
-- Q4
SELECT * FROM employees 
	WHERE jobTitle = "Sales Rep"
	AND (officeCode = 1 OR officeCode = 2 or officeCode =3)
	AND (firstName LIKE "%son%" OR lastName LIKE "%son%");
-- Q5
SELECT customerName, contactFirstName, contactLastName FROM customers JOIN orders
	ON customers.customerNumber = orders.customerNumber
	WHERE customers.customerNumber = 124;
-- Q6
SELECT productName, orderdetails.* FROM products JOIN orderdetails
	ON products.productCode = orderdetails.productCode;


-- count how many rows there are in employees table
SELECT count(*) from employees
-- sum: allow you to sum the value of columns across all the rows
SELECT sum(quantityOrdered) from orderdetails;

SELECT sum(quantityOrdered) from orderdetails
	WHERE productCode = "s118_1749";

-- count how mnay customers there are with sales rep
SELECT count(salesRepEmployeeNumber) from customers;
-- 2nd method
SELECT count(*) FROM customers JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber

-- find the total amount paid by customers in the month of June 2003
SELECT sum(payments.amount) from payments 
WHERE paymentDate WHERE month(paymentDate) = 6 AND YEAR(paymentDate) = 2003

-- GROUP BYs
-- count how many customers there are per country
SELECT country, count(*) from customers
GROUP BY country --group by happens first

-- show the avg credit limit and number of customers per country
SELECT country, avg(creditLimit), count(*) FROM customers --you can only select what you group by
GROUP BY country

-- 
SELECT country, firstName, lastName, email, avg(creditLimit), count(*) FROM customers
JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE salesRepEmployeeNumber = 1504
GROUP BY country, firstName, lastName, email
ORDER BY avg(creditLimit) DESC
LIMIT 3

-- HANDS ON
-- Q7
SELECT country, customers.customerNumber, customerName, sum(payments.amount) FROM customers
JOIN payments ON customers.customerNumber = payments.customerNumber
WHERE customers.country = "USA"
GROUP BY country, customers.customerNumber, customerName
-- Q8
SELECT country, state, count(*) FROM offices 
JOIN employees ON offices.officeCode = employees.officeCode
WHERE offices.country = "USA"
GROUP BY country, state
-- Q9
SELECT customerName, avg(payments.amount)
FROM customers JOIN payments
on customers.customerNumber = payments.customerNumber
GROUP BY payments.customerNumber, customerName
-- Q10
SELECT customerName, avg(payments.amount)
FROM customers JOIN payments
on customers.customerNumber = payments.customerNumber
GROUP BY customerName
HAVING  sum(payments.amount) >= 10000
-- Q11
SELECT productName, count(*) AS times_ordered FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY orderdetails.productCode, productName
ORDER BY times_ordered DESC
LIMIT 10
-- Q12
SELECT * FROM orders
WHERE YEAR(orderDate) = "2003" 
-- Q13
SELECT 

-- having happens after group
HAVING count(*) > 5


-- SUB QUERY

-- eg. product code of product with most orders
SELECT productCode FROM(
SELECT orderdetails.productCode, productName, count(*) AS times_ordered FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY orderdetails.productCode, productName
ORDER BY times_ordered DESC
LIMIT 1)
AS sub;

-- find all customers whose credit limit is above the average

-- find all product code that have no orders
-- distinct means unique
SELECT * FROM orderdetails WHERE productCode NOT IN (SELECT distinct(productCode) from orderdetails)

-- show all sales rep who made more than 10% of the payment amount
SELECT employeeNumber, firstName, lastName, sum(amount) FROM employees JOIN customers
	ON employees.employeeNumber = customers.salesRepEmployeeNumber
	JOIN payments ON customers.customerNumber = payments.customerNumber
	GROUP BY employees.employeeNumber, employees.firstName, employees.lastName
	HAVING sum(amount) > (SELECT sum(amount)*0.1 from payments)