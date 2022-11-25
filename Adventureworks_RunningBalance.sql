
USE AdventureWorks2019

--============================================================
--==============[Temp Table Employee Data]====================
--============================================================

--Temp Table [Unique Pay]
--============================================
CREATE TABLE #EmployeeCurrentPayRates
(
	 BusinessEntityID INT
	 ,RateChangeDate DATE
	 ,Rate INT
	 ,PayFrequency INT
	 ,ModifiedDate DATE
	 ,IsCurrent INT
)

INSERT INTO #EmployeeCurrentPayRates

	SELECT 
		 [Salaries].BusinessEntityID
		,[Salaries].RateChangeDate
		,[Salaries].Rate
		,[Salaries].PayFrequency
		,[Salaries].ModifiedDate
		,CASE 
			WHEN ROW_NUMBER() OVER (PARTITION BY [Salaries].[BusinessEntityID] ORDER BY [Salaries].[RateChangeDate] DESC ) = 1 THEN 1
			ELSE 0
			END	AS 'IsCurrent'
	
	FROM 
		HumanResources.EmployeePayHistory AS [Salaries]


--Temp Table [Employees]
--=========================
CREATE TABLE #TempTableEmployees
(
	 EmployeeID INT
	,DepartmentName VARCHAR(MAX)
	,HireDate DATE
	,FirstName VARCHAR(MAX)
	,LastName VARCHAR(MAX)
	,MaritalStatus VARCHAR(MAX)
	,Gender VARCHAR(MAX)
	,BirthDate DATE
	,PayRate INT
	,PayFreq INT
	,VacationHours INT
	,SickLeaveHours INT
	,PayModified DATETIME
	,IsCurrent INT

)


INSERT INTO #TempTableEmployees

	SELECT
		 --EmployeeID
		 [Employees].BusinessEntityID

		--DepartmentName
		,[Departments].GroupName

		--HireDate
		,[Employees].HireDate

		--FirstName
		,[AllPeople].FirstName

		--LastName
		,[AllPeople].LastName

		--MaritalStatus
		,[Employees].MaritalStatus

		--Gender
		,[Employees].Gender

		--Birthdate
		,[Employees].BirthDate

		--PayRate
		,[Salaries].Rate

		--PayFreq
		,[Salaries].PayFrequency

		--VacationHours
		,[Employees].VacationHours

		--SickLeaveHours
		,[Employees].SickLeaveHours

		--Pay Last Modified
		,[Salaries].ModifiedDate

		--If Current
		,[Salaries].IsCurrent


	FROM 
		-- Get all the Employees
		HumanResources.Employee		AS [Employees]

		-- Add the Employee Name
		INNER JOIN Person.Person	AS [AllPeople]
		ON [AllPeople].BusinessEntityID = [Employees].BusinessEntityID

		-- Add the Department ID number (Remove Employees No Longer Working)
		INNER JOIN HumanResources.EmployeeDepartmentHistory AS [EmployeeDepartmentLink]
		ON [Employees].BusinessEntityID = [EmployeeDepartmentLink].BusinessEntityID
		AND [EmployeeDepartmentLink].EndDate IS NULL

		-- Add the Department ID Name
		INNER JOIN HumanResources.Department AS [Departments]
		ON [EmployeeDepartmentLink].DepartmentID = [Departments].DepartmentID

		--Add Pay Details
		INNER JOIN #EmployeeCurrentPayRates AS [Salaries]
		ON [Employees].BusinessEntityID = [Salaries].BusinessEntityID
		AND [Salaries].IsCurrent = 1

DROP TABLE #EmployeeCurrentPayRates

--=================================================================================================
--=================================================================================================
--=================================================================================================


SELECT 
	 #TempTableEmployees.EmployeeID
	,#TempTableEmployees.FirstName
	,#TempTableEmployees.VacationHours
	,SUM (#TempTableEmployees.VacationHours) OVER (ORDER BY #TempTableEmployees.EmployeeID) AS RunningAgeTotal

FROM #TempTableEmployees

DROP TABLE #TempTableEmployees

