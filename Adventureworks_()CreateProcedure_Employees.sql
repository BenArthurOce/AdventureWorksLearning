USE AdventureWorks2019

GO		-- Begins a New Batch of Statements

ALTER PROC spEmployeeList
--CREATE PROC spEmployeeList

AS		-- Convert the Below Select Statement into a Procedure
BEGIN	-- Contains all of the Statments that belong to the stored procedure

-- Employee Details
SELECT 
	 [Employees].BusinessEntityID	AS '(t1) Bussiness ID Ref' 
	,[Employees].NationalIDNumber	AS '(t1) Employee ID'
	,[AllPeople].FirstName			AS '(t2) First Name'	
	,[AllPeople].MiddleName			AS '(t2) Middle Name'
	,[AllPeople].LastName			AS '(t2) Last Name'
	,[Employees].BirthDate			AS '(t1) Date of Birth'
	,[Departments].GroupName		AS '(t4) Department'
	,[Employees].HireDate			AS '(t1) Date Hired'
	,[Employees].VacationHours		AS '(t1) Leave - Vacation'
	,[Employees].SickLeaveHours		AS '(t1) Leave - Sick'
	,[Employees].rowguid

FROM 
	--	[TABLE 1]	Get a list of all the Employees
	HumanResources.Employee		AS [Employees]

	-- [TABLE 2]	Reference Employee Details from the Business ID
	INNER JOIN Person.Person	AS [AllPeople]
	ON [AllPeople].BusinessEntityID = [Employees].BusinessEntityID

	-- [TABLE 3]	Reference Department ID, Shift ID, Start/End Date from Business ID
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS [EmployeeDepartmentLink]
	ON [Employees].BusinessEntityID = [EmployeeDepartmentLink].BusinessEntityID

	-- [TABLE 4]	Reference Department Name from Table 3 ID Number
	INNER JOIN HumanResources.Department AS [Departments]
	ON [EmployeeDepartmentLink].DepartmentID = [Departments].DepartmentID


WHERE
	-- Remove Any Lines where Employment Enddate is a number (Employee Left)
	[EmployeeDepartmentLink].EndDate IS NULL

ORDER BY
	'(t1) Bussiness ID Ref' 

END
