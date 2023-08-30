/****** Object:  Procedure [dbo].[PortalWebAccountItemHistory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountItemHistory]
	-- Add the parameters for the stored procedure here
	@AcctNo varchar(12)
AS
BEGIN
	DECLARE @DivisionNo char(2);
	DECLARE @CustomerNo varchar(10);
SELECT @DivisionNo = LEFT(@AcctNo,2)
SELECT @CustomerNo = SUBSTRING(@AcctNo,3,len(@AcctNo)-2)
	SET NOCOUNT ON;
	WITH ITEMHISTORY AS
(
SELECT     
ROW_NUMBER() OVER (PARTITION BY ITEMCODE ORDER BY INVOICEDATE desc) AS 'RN',
ItemCode, InvoiceDate as InvoiceDate, SUM(QuantityShipped) AS QTY, 
                      MAX(UnitPrice) AS PRICE
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo
                  
where ItemType = '1' and InvoiceDate >= DATEADD(YEAR, -2, GETDATE()) and ARDivisionNo = @DivisionNo and CustomerNo = @CustomerNo and UnitPrice > 0
group by ItemCode, InvoiceDate
HAVING SUM(QuantityShipped) > 0
)
SELECT ItemCode, CONVERT(varchar,InvoiceDate,12) as InvoiceDate, Cast(Round(Qty,2) as Float) as Qty, Cast(Round(Price,2) as Float) as Price
FROM ITEMHISTORY
WHERE RN=1
END
