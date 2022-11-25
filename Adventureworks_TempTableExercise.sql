
--===================================================
BEGIN
CREATE TABLE #Temp_StatusOrder
(
	 StatusNumber INT			-- 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled
	,StatusName	  VARCHAR(MAX)
)

INSERT INTO #Temp_StatusOrder
VALUES (1,'In process'),(2,'Approved'),(3,'Backordered'),(4,'Rejected'),(5,'Shipped'),(6,'Cancelled')
END

--===================================================




--===================================================
BEGIN
WITH TableResult AS
(
SELECT
	 CAST([purch_PurchaseOrderHeader].	[PurchaseOrderID]	AS INT)				AS [_OrderID]
	,CAST([purch_PurchaseOrderHeader].	[VendorID]			AS INT)				AS [_VendorID]
	,CAST([purch_Vendor].				[Name]				AS VARCHAR(MAX))	AS [_VendorName]
	,CAST([purch_PurchaseOrderHeader].	[SubTotal]			AS MONEY)			AS [_SubTotal]
	,CAST([purch_PurchaseOrderHeader].	[TaxAmt]			AS MONEY)			AS [_TaxAmt]
	,CAST([purch_PurchaseOrderHeader].	[Freight]			AS MONEY)			AS [_Freight]
	,CAST([purch_PurchaseOrderHeader].	[TotalDue]			AS MONEY)			AS [_TotalDue]
	,CAST([#Temp_StatusOrder].			[StatusName]		AS VARCHAR(MAX))	AS [_Status]	

FROM 
	[Purchasing].[PurchaseOrderHeader] AS [purch_PurchaseOrderHeader]

	INNER JOIN [Purchasing].[Vendor] AS [purch_Vendor]
		ON [purch_PurchaseOrderHeader].[VendorID] = [purch_Vendor].[BusinessEntityID]

	INNER JOIN #Temp_StatusOrder AS [#Temp_StatusOrder]
		ON [purch_PurchaseOrderHeader].[Status] = [#Temp_StatusOrder].[StatusNumber]
		AND #Temp_StatusOrder.StatusNumber = 1

)

SELECT 
	-- TableResult._OrderID
	 TableResult._VendorID		AS [_OrderID]
	,TableResult._VendorName	AS [_VendorName]
	,SUM(TableResult._SubTotal)	AS [_SubTotal]
	,SUM(TableResult._TaxAmt)	AS [_TaxAmt]
	,SUM(TableResult._Freight)	AS [_Freight]
	,SUM(TableResult._TotalDue)	AS [_TotalDue]
	,TableResult._Status		AS [_Status]

FROM TableResult

GROUP BY
--	 #Temp_TransHistory._OrderID
	 TableResult._VendorID
	,TableResult._VendorName
	,TableResult._Status
END
--===================================================


DROP TABLE #Temp_StatusOrder
