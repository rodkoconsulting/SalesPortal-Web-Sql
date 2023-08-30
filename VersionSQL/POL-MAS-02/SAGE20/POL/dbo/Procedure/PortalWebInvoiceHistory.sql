/****** Object:  Procedure [dbo].[PortalWebInvoiceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebInvoiceHistory]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName   
SELECT     
h.InvoiceNo,
CASE WHEN InvoiceType='CM' THEN 'C' ELSE 'I' END as Type,
ItemCode,
h.ARDivisionNo + h.CustomerNo as AcctNo,
CONVERT(varchar,InvoiceDate,12) as Date,
CAST(ROUND(QuantityShipped,2) AS FLOAT) AS Qty, 
CAST(ROUND(UnitPrice,2) AS FLOAT) AS Price,
CAST(ROUND(ExtensionAmt,2) AS FLOAT) AS Total,
h.Comment,
h.UDF_NJ_COOP as Coop,
c.SalespersonNo as RepAcct,
h.SalesPersonNo as RepInv
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN MAS_POL.dbo.AR_InvoiceHistoryDetail d ON h.InvoiceNo = d.InvoiceNo AND h.HeaderSeqNo = d.HeaderSeqNo
												   INNER JOIN MAS_POL.dbo.AR_Customer c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo
                  
where InvoiceDate >= DATEADD(YEAR, -2, GETDATE()) and ModuleCode = 'S/O' and ((@AccountType = 'REP' and (h.SalespersonNo = @RepCode or c.SalespersonNo = @RepCode)) or (@AccountType = 'OFF') )
ORDER BY h.InvoiceNo
END
