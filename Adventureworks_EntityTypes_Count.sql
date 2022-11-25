
-- Contact ID, Business ID
-- Entity Type (Sellor, Vendor, Employee, Customer, Business)

-- Person.BusinessEntity AS [EveryEntityID]
-- connects vendors, customers, and employees with address and contact information.



SELECT 
	 [EveryEntityID].BusinessEntityID					AS 'ID Number'
	,CASE
		WHEN [Customers].AccountNumber IS NOT NULL		THEN 'CUSTOMER' 
		WHEN [Employees].NationalIDNumber IS NOT NULL	THEN 'EMPLOYEE' 
		WHEN [Stores].Name IS NOT NULL					THEN 'STORE' 
		WHEN [Vendors].AccountNumber IS NOT NULL		THEN 'VENDOR'
														ELSE 'NOT FOUND' 
		END												AS 'Entity Type'
	,COUNT('Entity Type')						

FROM Person.BusinessEntity AS [EveryEntityID]

	-- NOT CURRENTLY USED IN ABOVE 'SELECT' CODE
	LEFT JOIN Person.Person AS [Person] 
	ON [EveryEntityID].BusinessEntityID = [Person].BusinessEntityID


	-- NOT CURRENTLY USED IN ABOVE 'SELECT' CODE
	LEFT JOIN Sales.Store AS [SalesPeople]
	ON [EveryEntityID].BusinessEntityID = [SalesPeople].BusinessEntityID


	LEFT JOIN [Sales].[Customer] AS [Customers]
	ON [EveryEntityID].BusinessEntityID = [Customers].PersonID


	LEFT JOIN HumanResources.Employee AS [Employees]
	ON [EveryEntityID].BusinessEntityID = [Employees].BusinessEntityID


	LEFT JOIN Sales.Store AS [Stores]
	ON [EveryEntityID].BusinessEntityID = [Stores].BusinessEntityID


	LEFT JOIN Purchasing.Vendor AS [Vendors]
	ON [EveryEntityID].BusinessEntityID = [Vendors].BusinessEntityID

GROUP BY 'Entity Type'
ORDER BY 'ID Number'