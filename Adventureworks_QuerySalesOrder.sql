-- Query A Sales order based on sales number
--43661, 65234, 72999

DECLARE @OrderQuery AS INT
DECLARE @ProductName AS VARCHAR(MAX)

SET 
	@OrderQuery = 72999

--SET	@OrderNumber = 43661


SELECT
	ISNULL([SaleDetail].LineTotal, 'TOTAL')
	,CAST([SaleDetail].SalesOrderID AS INT)	AS 'Order ID'
	,[Products].Name			AS 'Item Sold'
	,[SaleDetail].OrderQty		AS 'Amt Ordered'
	,[SaleDetail].LineTotal		AS 'Line Total'

FROM
	Sales.SalesOrderDetail	AS  [SaleDetail]
	INNER JOIN Production.Product AS [Products]
	ON [SaleDetail].ProductID = [Products].ProductID

WHERE	[SaleDetail].SalesOrderID  = @OrderQuery

GROUP BY ROLLUP(
	 [SaleDetail].SalesOrderID
	,[SaleDetail].LineTotal
	,[Products].Name
	,[SaleDetail].OrderQty
	,[SaleDetail].LineTotal)