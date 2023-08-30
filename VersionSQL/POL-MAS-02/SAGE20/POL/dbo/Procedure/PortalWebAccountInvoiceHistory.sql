/****** Object:  Procedure [dbo].[PortalWebAccountInvoiceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountInvoiceHistory]
	-- Add the parameters for the stored procedure here
	@AcctNo varchar(12)
AS
BEGIN
	DECLARE @DivisionNo char(2);
	DECLARE @CustomerNo varchar(10);
SELECT @DivisionNo = LEFT(@AcctNo,2)
SELECT @CustomerNo = SUBSTRING(@AcctNo,3,len(@AcctNo)-2)
	SET NOCOUNT ON;
	
SELECT     
MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo,
CASE WHEN InvoiceType='CM' THEN 'C' ELSE 'I' END as Type,
ItemCode,
CONVERT(varchar,InvoiceDate,12) as Date,
CAST(ROUND(QuantityShipped,2) AS FLOAT) AS Qty, 
CAST(ROUND(UnitPrice,2) AS FLOAT) AS Price,
CAST(ROUND(ExtensionAmt,2) AS FLOAT) AS Total,
Comment
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo
                  
where InvoiceDate >= DATEADD(YEAR, -2, GETDATE()) and ModuleCode = 'S/O' and ARDivisionNo = @DivisionNo and CustomerNo = @CustomerNo
ORDER BY InvoiceNo
END
