/*
Answer following questions
1.	What is a result set?
A result set is the output of a query. you can have multiple result sets from a single object call.

2.	What is the difference between Union and Union All?
UNION ALL returns all the results including duplicates. UNION don’t return the duplicate results. UNION ALL is faster than UNION.

3.	What are the other Set Operators SQL Server has? (Set operations allow the results of multiple queries to be combined into a single result set.)
UNION, UNION ALL, INTERSECT, EXCEPT

4.	What is the difference between Union and Join?
Union is a set operator that can combine the result set of two different SELECT statements. The number of columns and the data type should be the same in order to use UNION.
UNION is used to combine the result-set of two or more SELECT statements. The data combined using UNION statement is into results into new distinct rows.
JOIN is used to combine data from many tables based on a matched condition. The data combined using JOIN statement results into new columns.

5.	What is the difference between INNER JOIN and FULL JOIN?
Inner join will only return rows in which there is a match based on the join predicate.
For full join the result set will retain all of the rows from both of the tables.

6.	What is difference between left join and outer join
Outer join has left outer join, right outer join, and full outer join.Left join is as same as left outer join. 

7.	What is cross join?
Cross join produces the Cartesian product of two or more tables.

8.	What is the difference between WHERE clause and HAVING clause?
WHERE Clause is used to filter the records from the table or used while joining more than one table. Records that satisfies the specified condition in WHERE clause will be output. It can be used with SELECT, UPDATE, DELETE statements.
HAVING Clause is used to filter the records from the groups based on the given condition in the HAVING Clause. HAVING Clause can only be used with SELECT statement. 

9.	Can there be multiple group by columns?
Yes

*/

--1.	How many products can you find in the Production.Product table?
-- ANS: 504
SELECT COUNT(ProductID)
FROM Production.Product

--2.	****Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
--      The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID)
FROM Production.Product
WHERE ProductID IN 
(SELECT ProductSubcategoryID FROM Production.Product)

--3.	How many Products reside in each SubCategory? Write a query to display the results with the following titles. ProductSubcategoryID CountedProducts
SELECT ProductSubcategoryID, COUNT(ProductID) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IN 
(SELECT ProductID FROM Production.Product)
GROUP BY ProductSubcategoryID

--4.	How many products that do not have a product subcategory.
SELECT COUNT(ProductID)
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

--5.	Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT ProductID, SUM(Quantity) AS Quantity
FROM Production.ProductInventory
GROUP BY ProductID

--6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--   ProductID    TheSum
SELECT ProductID, SUM(Quantity) AS Quantity
FROM Production.ProductInventory
WHERE Quantity < 100 AND LocationID = 40
GROUP BY ProductID

--7.	Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
--      Shelf      ProductID    TheSum
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE Quantity < 100 AND LocationID = 40
GROUP BY ProductID, Shelf

--8.	Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS AverageQuantity
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

--9.	Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
--      ProductID   Shelf      TheAvg
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID,Shelf

--10.	Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
--      ProductID   Shelf      TheAvg
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID,Shelf

--11.	List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--      Color   Class 	TheCount   AvgPrice
SELECT Color, Class, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

--12.	  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
-- Country                        Province
SELECT c.Name, s.Name
FROM person.CountryRegion as c JOIN person.StateProvince as s ON(C.CountryRegionCode = S.CountryRegionCode)

--13.	Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

-- Country                        Province
---------                          ----------------------
SELECT c.Name, s.Name
FROM person.CountryRegion as c JOIN person.StateProvince as s ON (c.CountryRegionCode = s.CountryRegionCode)
WHERE c.Name = 'Germany' OR c.Name = 'Canada'

--14.	List all Products that has been sold at least once in last 25 years.
SELECT o.OrderID, od.ProductID, o.OrderDate
FROM dbo.Orders as o JOIN dbo.[Order Details] as od ON (o.OrderID = od.OrderID)
WHERE YEAR(o.OrderDate) BETWEEN (YEAR(GETDATE()) - 25) AND YEAR(GETDATE())

--15.	List top 5 locations (Zip Code) where the products sold most.
SELECT TOP(5) ShipPostalCode, COUNT(OrderID) AS CountOrder
FROM DBO.Orders
WHERE ShipPostalCode IS NOT NULL
GROUP BY ShipPostalCode
ORDER BY COUNT(OrderID) DESC


--16.	List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP(5) ShipPostalCode, COUNT(OrderID) AS CountOrder
FROM DBO.Orders
WHERE ShipPostalCode IS NOT NULL AND (YEAR(OrderDate) BETWEEN (YEAR(GETDATE()) - 25) AND YEAR(GETDATE()))
GROUP BY ShipPostalCode
ORDER BY COUNT(OrderID) DESC


--17.	 List all city names and number of customers in that city.  
SELECT TOP(5) ord.ShipPostalCode, cus.City, COUNT(cus.CustomerID) AS NumofCustomer, COUNT(ord.OrderID) AS CountOrder
FROM DBO.Orders AS ord JOIN dbo.Customers AS cus ON (ORD.ShipPostalCode = cus.PostalCode)
WHERE ShipPostalCode IS NOT NULL AND (YEAR(OrderDate) BETWEEN (YEAR(GETDATE()) - 25) AND YEAR(GETDATE()))
GROUP BY ShipPostalCode, cus.City
ORDER BY COUNT(ord.OrderID) DESC

--18. List city names which have more than 2 customers, and number of customers in that city 
SELECT TOP(5) ord.ShipPostalCode, cus.City, COUNT(cus.CustomerID) AS NumofCustomer, COUNT(ord.OrderID) AS CountOrder
FROM DBO.Orders AS ord JOIN dbo.Customers AS cus ON (ORD.ShipPostalCode = cus.PostalCode)
WHERE ShipPostalCode IS NOT NULL AND (YEAR(OrderDate) BETWEEN (YEAR(GETDATE()) - 25) AND YEAR(GETDATE()))
GROUP BY ShipPostalCode, cus.City
HAVING COUNT(cus.CustomerID) > 2
ORDER BY COUNT(ord.OrderID) DESC

--19.	List the names of customers who placed orders after 1/1/98 with order date.
SELECT CUST.CompanyName
FROM Customers AS CUST JOIN Orders AS ORD ON (CUST.CustomerID = ORD.CustomerID)
WHERE ORD.OrderDate BETWEEN '1998/01/01' AND GETDATE()

--20.	List the names of all customers with most recent order dates 
SELECT CUS.CompanyName, MAX(ORD.OrderDate) AS RecentOrderDate
FROM DBO.Orders AS ORD JOIN DBO.Customers AS CUS ON (ORD.CustomerID = CUS.CustomerID)
GROUP BY CUS.CompanyName

--21.	Display the names of all customers  along with the  count of products they bought 
SELECT CUST.CompanyName, SUM(ORDET.Quantity) AS CountofProduct
FROM DBO.[Order Details] AS ORDET JOIN DBO.Orders AS ORD ON (ORDET.OrderID = ORD.OrderID)
JOIN DBO.Customers AS CUST ON (CUST.CustomerID = ORD.CustomerID)
GROUP BY CUST.CompanyName

--22.	Display the customer ids who bought more than 100 Products with count of products.
SELECT CUST.CustomerID, SUM(ORDET.Quantity) AS CountofProduct
FROM DBO.[Order Details] AS ORDET JOIN DBO.Orders AS ORD ON (ORDET.OrderID = ORD.OrderID)
JOIN DBO.Customers AS CUST ON (CUST.CustomerID = ORD.CustomerID)
GROUP BY  CUST.CustomerID
HAVING SUM(ORDET.Quantity) > 100

-- 23.	List all of the possible ways that suppliers can ship their products. Display the results as below */
SELECT CompanyName
FROM DBO.Shippers

--24.	Display the products order each day. Show Order date and Product Name.
SELECT ORD.OrderDate, PROD.ProductName
FROM DBO.Orders AS ORD JOIN DBO.[Order Details] AS ORDET ON (ORD.OrderID = ORDET.OrderID)
JOIN DBO.Products AS PROD ON (ORDET.ProductID = PROD.ProductID)
   
--25.	Displays pairs of employees who have the same job title.
SELECT T1.EMPLOYEEID, T1.FIRSTNAME, T1.LASTNAME, T2.EMPLOYEEID, T2.FIRSTNAME, T2.LASTNAME
FROM DBO.Employees AS T1, DBO.Employees AS T2
WHERE T1.Title = T2.Title AND T1.EmployeeID <> T2.EmployeeID

--26.	Display all the Managers who have more than 2 employees reporting to them.
SELECT EmployeeID, LastName, FirstName
FROM DBO.Employees
WHERE EmployeeID IN 
(SELECT ReportsTo
FROM DBO.Employees
GROUP BY ReportsTo
HAVING COUNT(ReportsTo) > 2)

--27.	Display the customers and suppliers by city. The results should have the following columns
SELECT T1.CITY, T1.CompanyName, T1.CONTACTNAME, 'Customer' AS Type
FROM DBO.Customers AS T1
UNION
SELECT T2.CITY, T2.CompanyName, T2.CONTACTNAME, 'Supplier' AS Type
FROM DBO.Suppliers AS T2

--28 Have two tables T1 and T2
/*
SELECT *
FROM T1 AS TABLE1 JOIN T2 AS TABLE2 ON (TABLE1.F1 = TABLE2.F2)

F1.T1 F2.T2
2       2
3       3
*/

--29. Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
/*
SELECT *
FROM T1 AS TABLE1 LEFT JOIN T2 AS TABLE2 ON (TABLE1.F1 = TABLE2.F2)
F1.T1 F2.T2
1       NULL
2       2
3       3
*/