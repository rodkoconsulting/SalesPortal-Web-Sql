/****** Object:  Procedure [dbo].[PortalWebSalesAnalysisProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebSalesAnalysisProc]
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @TodayDate datetime = GETDATE()
	DECLARE @TodayYr int = YEAR(@TodayDate)
	DECLARE @TodayMnth int = MONTH(@TodayDate);
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName;  
WITH InvHist AS 
(
SELECT       DISTINCT h.InvoiceNo, h.HeaderSeqNo, InvoiceType, InvoiceDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP, ItemCode, ExtensionAmt
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
				MAS_POL.dbo.AR_InvoiceHistoryDetail d on h.InvoiceNo = d.InvoiceNo and h.HeaderSeqNo = d.HeaderSeqNo
WHERE ((@AccountType = 'REP' and SalesPersonNo = @RepCode) or (@AccountType = 'OFF') ) and ModuleCode = 'S/O' and InvoiceDate >= DATEFROMPARTS ( DATEPART(yyyy, @TodayDate) - 1, 1, 1 ) and ItemType = 1
UNION ALL
SELECT        DISTINCT h.InvoiceNo, h.InvoiceNo, InvoiceType, ShipDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP, ItemCode, ExtensionAmt
FROM            MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN
				MAS_POL.dbo.SO_InvoiceDetail d on h.InvoiceNo = d.InvoiceNo
WHERE ((@AccountType = 'REP' and SalesPersonNo = @RepCode) or (@AccountType = 'OFF') ) and ItemType = 1
),
Sales AS
(
SELECT			c.CustomerName
				, COUNT(DISTINCT (CASE WHEN Year(INVOICEDATE) = @TodayYr AND Month(INVOICEDATE) = @TodayMnth THEN h.ItemCode ELSE NULL END)) AS MTD_SKU
				, COUNT(DISTINCT (CASE WHEN Year(INVOICEDATE) = @TodayYr - 1 AND Month(INVOICEDATE) = @TodayMnth THEN h.ItemCode ELSE NULL END)) AS LY_MTD_SKU
				, SUM(CASE WHEN Year(INVOICEDATE) = @TodayYr  AND Month(INVOICEDATE) = @TodayMnth THEN h.EXTENSIONAMT ELSE 0 END) AS MTD
				, SUM(CASE WHEN Year(INVOICEDATE) = @TodayYr  - 1 AND Month(INVOICEDATE) = @TodayMnth THEN h.EXTENSIONAMT ELSE 0 END) AS LY_MTD
				, SUM(CASE WHEN Year(INVOICEDATE) = @TodayYr  AND Month(INVOICEDATE) <= @TodayMnth THEN h.EXTENSIONAMT ELSE 0 END) AS YTD
				, SUM(CASE WHEN Year(INVOICEDATE) = @TodayYr  - 1 AND Month(INVOICEDATE) <= @TodayMnth THEN h.EXTENSIONAMT ELSE 0 END) AS LY_YTD
				, c.SalespersonNo
FROM            MAS_POL.dbo.AR_Salesperson s
				INNER JOIN MAS_POL.dbo.AR_Customer c ON s.SalespersonDivisionNo = c.SalespersonDivisionNo AND s.SalespersonNo = c.SalespersonNo
				INNER JOIN InvHist h ON c.CustomerNo = h.CustomerNo AND c.ARDivisionNo = h.ARDivisionNo
WHERE      c.SalespersonNo NOT LIKE 'XX%'
GROUP BY c.CustomerName, c.SalespersonNo
)
SELECT Main = (
SELECT      CustomerName AS Acct
			,CASE WHEN @AccountType = 'REP' THEN '' ELSE SalespersonNo END AS Rep
			,MTD
			,LY_MTD AS MTD_LY
			,MTD - LY_MTD AS MTD_DIFF
			,CONVERT(DECIMAL(9,2),CASE WHEN LY_MTD = 0 THEN 0 ELSE (MTD - LY_MTD) / LY_MTD * 100 END) AS MTD_PCT
			,MTD_SKU
			,LY_MTD_SKU AS MTD_SKU_LY
			,YTD
			,LY_YTD AS YTD_LY
			,YTD - LY_YTD AS YTD_DIFF
			,CONVERT(DECIMAL(9,2),CASE WHEN LY_YTD = 0 THEN 0 ELSE (YTD - LY_YTD) / LY_YTD * 100 END) AS YTD_PCT
FROM            Sales
ORDER BY SalespersonNo, Acct
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
