
DECLARE 
	@TodaysDate DATETIME = GETDATE()

-- [Table: Employee Data]
-- Method: CONSTRUCT
-- ================================
CREATE TABLE #TempEmployeeList
(
	 Bussiness_ID_Ref	INT				--'(t1) Bussiness ID Ref'
	,Employee_ID		INT				--'(t1) Employee ID'
	,First_Name			VARCHAR(MAX)	--'(t2) First Name'
	,Middle_Name		VARCHAR(MAX)	--'(t2) Middle Name'
	,Last_Name			VARCHAR(MAX)	--'(t2) Last Name'
	,Date_of_Birth		DATETIME		--'(t1) Date of Birth'
	,Department			VARCHAR(MAX)	--'(t4) Department'
	,Date_Hired			DATETIME		--'(t1) Date Hired'
	,Leave_Vacation		INT				--'(t1) Leave - Vacation'
	,Leave_Sick			INT				--'(t1) Leave - Sick'
)

-- [Table: Employee Data]
-- Method: POPULATE
-- ================================
EXEC spGenerateTempEmployees


-- [Table: Age, Birthday Data]
-- Method: CONSTRUCT
-- ================================
CREATE TABLE #AgeTempTable
(
	 Employee_ID		INT
	,Date_Of_Birth		DATETIME
	,ThisYear_Birthday	DATETIME
	,NextYear_Birthday	DATETIME
	,Days_To_Birthday1	INT
	,Days_To_Birthday2	INT
)

-- [Table: Age, Birthday Data]
-- Method: POPULATE
-- ================================
INSERT INTO #AgeTempTable
	SELECT
		 -- Employee ID
		 #TempEmployeeList.Employee_ID

		 -- Employee Date of Birth
		 ,#TempEmployeeList.Date_of_Birth													

		 -- Date of Birthday This Year
		 ,CAST([dbo].fnThisYearBirthday(#TempEmployeeList.Date_Of_Birth) AS DATETIME)

		-- Date of Birthday Next Year
		 ,CAST([dbo].fnNextYearBirthday(#TempEmployeeList.Date_Of_Birth) AS DATETIME)

		-- Days to Birthday in Current Year
		,DATEDIFF(DD
			,@TodaysDate
			,CAST([dbo].fnThisYearBirthday(#TempEmployeeList.Date_Of_Birth) AS DATETIME))

		-- Days to Birthday in Next Year
		,DATEDIFF(DD
			,@TodaysDate
			,CAST([dbo].fnNextYearBirthday(#TempEmployeeList.Date_Of_Birth) AS DATETIME))

	FROM
		#TempEmployeeList

--SELECT *
--FROM #AgeTempTable

-- [Table: Final Result]
-- Method: GENERATE
-- ================================

	SELECT 
		 [#TempEmployeeList].Employee_ID			AS 'Employee ID'
		,[#TempEmployeeList].First_Name				AS 'First Name'
		,[#TempEmployeeList].Last_Name				AS 'Last Name'
		,[#TempEmployeeList].Date_of_Birth			AS 'Date of Birth'
		,CASE
			WHEN [#AgeTempTable].Days_To_Birthday1 >= 0 
				THEN [#AgeTempTable].Days_To_Birthday1
			ELSE
				[#AgeTempTable].Days_To_Birthday2
			END										AS 'Days to Next Birthday'

	FROM [#TempEmployeeList]
		INNER JOIN [#AgeTempTable] 
		ON [#TempEmployeeList].Employee_ID = [#AgeTempTable] .Employee_ID




DROP TABLE #AgeTempTable
DROP TABLE #TempEmployeeList