/****** Object:  Procedure [dbo].[BillandHoldStatementsTotals]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BillandHoldStatementsTotals] 
	@StatementDate datetime
AS
BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	WITH line as
	(
	SELECT s.ARDivisionNo, s.CustomerNo, SUM(s.QuantityOrdered) as Quantity
	FROM BillAndHoldStatement As s
	WHERE s.OrderDate  < @StatementDate
	GROUP BY s.ARDivisionNo, s.CustomerNo
	)
	SELECT ARDivisionNo, CustomerNo, ROUND(Quantity * .74, 2) AS Fee
	FROM line
END
