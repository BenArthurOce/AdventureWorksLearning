-- Which Customer Spends the Most?


SELECT 
	 CAST([Customer].CustomerID AS CHAR)		AS 'Customer ID'
	,[EachPerson].FirstName					AS 'First Name'
	,[EachPerson].LastName					AS 'Last Name'
	,SUM(CAST([EachSale].TotalDue AS INT))		AS 'Amount Spent'

FROM
	-- Obtain Every Sale
	Sales.SalesOrderHeader AS [EachSale]

	-- Obtain Customer ID by identifying the customer ID in the sale line
	INNER JOIN Sales.Customer AS [Customer]
	ON [EachSale].CustomerID = [Customer].CustomerID

	-- Obtain Customer Details by referencing the customer ID and expanding it
	INNER JOIN Person.Person AS [EachPerson]
	ON [Customer].PersonID = [EachPerson].BusinessEntityID

GROUP BY
	 [Customer].CustomerID 
	,[EachPerson].FirstName
	,[EachPerson].LastName

ORDER BY
	 'Amount Spent' desc