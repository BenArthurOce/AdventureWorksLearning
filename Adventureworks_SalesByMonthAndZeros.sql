
/* 
Purpose:
To get number of individual sales per month depending on what year requested
The sales must be grouped by month
If there were no sales that month, the number must be 0
*/


--TABLE PURPOSE:	AllDatesInYear
--TABLE PROCEDURE:	DECLARE VARIABLES
--====================================
DECLARE @RequiredYear INT
SET @RequiredYear = '2013'

DECLARE @StartDate DATE
SET @StartDate = DATEFROMPARTS(@RequiredYear, 01, 01) 

DECLARE @EndDate DATE
SET @EndDate = DATEFROMPARTS(@RequiredYear, 12, 31) 

DECLARE @CurrentDate DATE


--TABLE PURPOSE:	AllDatesInYear
--TABLE PROCEDURE:	CREATE TABLE
--====================================
CREATE TABLE #AllDates
(
	 DateKey VARCHAR(MAX)
	,DateDate DATE
	,DateYear INT
	,DateMonth INT
	,MonthString VARCHAR(MAX)
	,DateDay INT
)

--TABLE PURPOSE:	AllDatesInYear
--TABLE PROCEDURE:	POPULATE TABLE
--====================================    
SET @CurrentDate = @StartDate

    -- go through each date of the year, create a line for each day
    WHILE @CurrentDate <=  @EndDate
        BEGIN
            INSERT INTO #AllDates 

			 VALUES(
				Convert(CHAR(8),@CurrentDate,112)
				,@CurrentDate
				,YEAR(@CurrentDate)
				,MONTH(@CurrentDate)
				,DATENAME( month , DateAdd( month , MONTH(@CurrentDate) , 0 ) - 1 )
				,DAY(@CurrentDate)
				)
            SET @CurrentDate = dateadd(DD, 1, @CurrentDate)
        END

--===========================================================================
--===========================================================================


--TABLE PURPOSE:	EverySaleID
--TABLE PROCEDURE:	DECLARE VARIABLES
--====================================
DECLARE @InputYear INT
SET @InputYear = @RequiredYear


--TABLE PURPOSE:	EverySaleID
--TABLE PROCEDURE:	CREATE TABLE
--====================================
CREATE TABLE #TempTableSalesLines
(
	 TransactionID INT
	,TransactionDate DATETIME
	,TransactionYear  INT
	,TransactionMonth INT
	,TransactionDay   INT
	,TransactionMonthString   VARCHAR(MAX)
	,TransactionDateKey VARCHAR(MAX)
)

--TABLE PURPOSE:	EverySaleID
--TABLE PROCEDURE:	POPULATE TABLE
--====================================
INSERT INTO #TempTableSalesLines

	SELECT
		 [TransHistory].ReferenceOrderID
		,[TransHistory].TransactionDate				
		,YEAR([TransHistory].TransactionDate)
		,MONTH([TransHistory].TransactionDate)
		,DAY([TransHistory].TransactionDate)
		,DATENAME( month , DateAdd( month , MONTH([TransHistory].TransactionDate) , 0 ) - 1 )
		,Convert(CHAR(8),[TransHistory].TransactionDate,112)

	FROM
		[Production].[TransactionHistoryArchive] AS [TransHistory]

	WHERE @InputYear = YEAR([TransHistory].TransactionDate)


--===========================================================================
--===========================================================================


--TABLE PURPOSE:	Number of Sales Per Day
--TABLE PROCEDURE:	CREATE TABLE
--====================================
CREATE TABLE #TempTableSalesTotals
(
	 DateKey INT
	,SalesInDay INT
)

--TABLE PURPOSE:	Number of Sales Per Day
--TABLE PROCEDURE:	POPULATE TABLE
--====================================
INSERT INTO #TempTableSalesTotals

	SELECT
		#TempTableSalesLines.TransactionDateKey
		,COUNT(*)

	FROM
		#TempTableSalesLines

	GROUP BY
		#TempTableSalesLines.TransactionDateKey

	ORDER BY
		#TempTableSalesLines.TransactionDateKey


--===========================================================================
--===========================================================================


--Match the number of sales of each day to each possible day in the year
--This allows us to count for no sales in a particular day (or month, if no sales that month)
--Once Joined, group to find summary
--===================

	SELECT 
		#AllDates.MonthString
		,SUM(#TempTableSalesTotals.SalesInDay)


	FROM 
		#AllDates

	LEFT JOIN #TempTableSalesTotals
	ON #AllDates.DateKey = #TempTableSalesTotals.DateKey

	GROUP BY
		 #AllDates.MonthString
		,#AllDates.DateMonth


DROP TABLE #AllDates
DROP TABLE #TempTableSalesLines
DROP TABLE #TempTableSalesTotals