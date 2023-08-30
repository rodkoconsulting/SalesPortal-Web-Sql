/****** Object:  Procedure [dbo].[PortalWebAccountItemHistoryFull]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountItemHistoryFull]
	-- Add the parameters for the stored procedure here
	@AcctNo varchar(12),
	@Code varchar(30)
AS
BEGIN
	DECLARE @DivisionNo char(2);
	DECLARE @CustomerNo varchar(10);
SELECT @DivisionNo = LEFT(@AcctNo,2)
SELECT @CustomerNo = SUBSTRING(@AcctNo,3,len(@AcctNo)-2)
	SET NOCOUNT ON;
SELECT   CONVERT(varchar,InvoiceDate,12) as InvoiceDate,
		 Cast(Round(SUM(QuantityShipped),2) as Float) AS Qty, 
         Cast(Round(MAX(UnitPrice),2) as Float) AS Price
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo
where ItemCode = @Code and InvoiceDate >= DATEADD(YEAR, -2, GETDATE()) and ARDivisionNo = @DivisionNo and CustomerNo = @CustomerNo and UnitPrice > 0
group by InvoiceDate
HAVING SUM(QuantityShipped) > 0
END
