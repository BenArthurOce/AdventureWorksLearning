-- Calling Queries Based on Request
/*
Index Invoker:
1	Get Department
2	Get Employee
3	Get Employee Department History
4	Get Employee Pay History
5	Get Job Candidates
6	Get Shift Details
*/

DECLARE @RunCode	INT
SET	@RunCode = 4



IF @RunCode = 1
	BEGIN
		SELECT * FROM [HumanResources].[Department]
	END

IF @RunCode = 2
	BEGIN
		SELECT * FROM [HumanResources].[Employee]
	END

IF @RunCode = 3
	BEGIN
		SELECT * FROM [HumanResources].[EmployeeDepartmentHistory]
	END

IF @RunCode = 4
	BEGIN
		SELECT * FROM [HumanResources].[EmployeePayHistory]
	END

IF @RunCode = 5
	BEGIN
		SELECT * FROM [HumanResources].[JobCandidate]
	END

IF @RunCode = 6
	BEGIN
		SELECT * FROM [HumanResources].[Shift]
	END
