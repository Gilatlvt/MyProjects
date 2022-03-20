

---PROJECT SQL/GILAT lEVIT-----

--1

select ProductID,Name,color,ListPrice,Size
from Production.Product PP 
where pp.ProductID not in 
						(select ProductID
						from Sales.SalesOrderDetail) 

--2
update sales.customer set personid=customerid 
 where customerid <=290
update sales.customer set personid=customerid+1700 
 where customerid >= 300 and customerid<=350
update sales.customer set personid=customerid+1700 
 where customerid >= 352 and customerid<=701 select SC.CustomerID, ISNULL(P.LastName,'UNKNOWN') as 'Last Name', ISNULL(P.FirstName,'UNKNOWN') AS 'first Name'     from  Sales.Customer SC left JOIN person.Person P on P.BusinessEntityID=SC.PersonID  where SC.CustomerID  not in (select CustomerID from Sales.SalesOrderHeader) order by CustomerID --3select top 10 SC.CustomerID ,P.FirstName,P.LastName, count(SalesOrderID)as 'Count of Orders'from  Sales.Customer SC  JOIN person.Person P on P.BusinessEntityID=SC.PersonID JOIN Sales.SalesOrderHeader SOH on SOH.CustomerID=SC.CustomerID group by SC.CustomerID,P.FirstName,P.LastNameorder by 'Count of Orders' desc--4select P.FirstName,P.LastName,HR.JobTitle,HR.HireDate,count(*) over (partition by HR.JobTitle)AS 'Count Of Title'from Person.Person P JOIN HumanResources.Employee HR on p.BusinessEntityID=HR.BusinessEntityID--6select  YEAR,SalesOrderID, LastName,FirstName,Total	from (	select YEAR(SOH.OrderDate) AS YEAR,	SOH.SalesOrderID,	PP. LastName, 	PP.FirstName,	sum(SOD.LineTotal) as Total,	ROW_NUMBER() OVER(partition by YEAR(SOH.OrderDate) ORDER BY sum(SOD.LineTotal) DESC ) AS RN	from Sales.SalesOrderDetail SOD	JOIN Sales.SalesOrderHeader SOH on SOD.SalesOrderID=SOH.SalesOrderID	JOIN Sales.Customer SC on SOH.CustomerID=SC.CustomerID 	JOIN Person.Person PP on SC.PersonID=PP.BusinessEntityID	group by SOH.SalesOrderID, PP. LastName, PP.FirstName, YEAR(SOH.OrderDate))Awhere RN=1--7select *from (		select month(orderdate) AS 'MONTH',		year(orderdate) AS 'YEAR',		SalesOrderID		from Sales.SalesOrderHeader)Apivot(count(SalesOrderID)for YEAR in ([2011],[2012],[2013],[2014])) pivorder by 1--8SELECT cast(OrderYear as varchar(20)) as 'Year',
cast (OrderMonth as varchar (20)) as 'Month',
cast (total as decimal(20,2)) as 'Sum Price',
cast (sum(total) over (partition by OrderYear order by OrderMonth) as decimal(20,2)) AS 'Money'
FROM (
		SELECT
		year(OrderDate) AS OrderYear,
		month(OrderDate) AS OrderMonth,
		SUM(LineTotal) AS total
		FROM   Sales.SalesOrderDetail D JOIN Sales.SalesOrderHeader H on D.SalesOrderID=H.SalesOrderID
		GROUP BY year(OrderDate),month(OrderDate)
     ) A
	 UNION
	 select year(OrderDate),'Grand Total',NULL,cast (sum(LineTotal)over( partition by year(OrderDate))as decimal(20,2)) 
	 from Sales.SalesOrderDetail D 
	 JOIN Sales.SalesOrderHeader H on D.SalesOrderID=H.SalesOrderID
	 ORDER BY  Year ,Money--9select D.Name AS 'DepartmentName',E.BusinessEntityID AS 'Employeeid',P.FirstName+P.LastName AS 'Emps Name',E.HireDate,Datediff(M,E.HireDate, getdate()) AS 'Senyoraty',LAG(P.FirstName+P.LastName) OVER (partition by D.Name order by E.HireDate) AS 'PrevEmpName',lAG(E.HireDate)over ( partition by D.Name order by E.HireDate) AS 'Prev HireDate',DATEDIFF(d,lag(E.HireDate)over (order by D.Name),E.HireDate) AS 'DiffDays'from HumanResources.Department D JOIN HumanResources.EmployeeDepartmentHistory ED ON D.DepartmentID=ED.DepartmentID JOIN HumanResources.Employee E ON E.BusinessEntityID=ED.BusinessEntityIDJOIN Person.Person P ONE.BusinessEntityID=P.BusinessEntityIDwhere EndDate is NULLorder by D.Name ,E.HireDate desc ,'Senyoraty' ,'Prev HireDate' desc--10select E.HireDate,ED.DepartmentID,STRING_AGG (cast( P.BusinessEntityID as varchar (20))+'  '+ P.LastName+' '+ P.FirstName, ',')from HumanResources.Department DJOIN HumanResources.EmployeeDepartmentHistory ED ON D.DepartmentID=ED.DepartmentID JOIN HumanResources.Employee E ON E.BusinessEntityID=ED.BusinessEntityID JOIN Person.Person P ONE.BusinessEntityID=P.BusinessEntityIDwhere EndDate is NULLgroup by E.HireDate,ED.DepartmentIDorder by E.HireDate--Thank you 