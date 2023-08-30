/****** Object:  Procedure [dbo].[Web_Account_OgItemHistory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgItemHistory]
	-- Add the parameters for the stored procedure here
	@ARDivisionNo char(2)='00',
	@Customer varchar(9),
	@ItemCode varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
WITH LASTORDERED AS
(
    -- Insert statements for procedure here
	SELECT     ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.CI_ITEM.ITEMCODE ORDER BY POL.dbo.AR_INVOICEHISTORYHEADER_Union.INVOICEDATE desc) AS 'RN',
			   POL.dbo.AR_INVOICEHISTORYHEADER_Union.INVOICEDATE as LastInvoiceDate, SUM(POL.dbo.AR_INVOICEHISTORYDETAIL_Union.QUANTITYSHIPPED) AS LastQuantityShipped, 
                      MIN(POL.dbo.AR_INVOICEHISTORYDETAIL_Union.UNITPRICE) AS LastPrice
FROM         MAS_POL.dbo.CI_ITEM LEFT OUTER JOIN
                      POL.dbo.AR_INVOICEHISTORYDETAIL_Union LEFT OUTER JOIN
                      POL.dbo.AR_INVOICEHISTORYHEADER_Union ON POL.dbo.AR_INVOICEHISTORYDETAIL_Union.INVOICENO = POL.dbo.AR_INVOICEHISTORYHEADER_Union.INVOICENO AND 
                      POL.dbo.AR_INVOICEHISTORYDETAIL_Union.HEADERSEQNO = POL.dbo.AR_INVOICEHISTORYHEADER_Union.HEADERSEQNO ON 
                      MAS_POL.dbo.CI_ITEM.ITEMCODE = POL.dbo.AR_INVOICEHISTORYDETAIL_Union.ITEMCODE
WHERE     MAS_POL.dbo.CI_ITEM.ITEMCODE=@ItemCode and POL.dbo.AR_INVOICEHISTORYHEADER_Union.CUSTOMERNO=@Customer and POL.dbo.AR_INVOICEHISTORYHEADER_Union.ARDivisionNo=@ARDivisionNo AND POL.dbo.AR_INVOICEHISTORYHEADER_Union.INVOICEDATE >= DATEADD(YEAR, - 2, GETDATE())
GROUP BY MAS_POL.dbo.CI_ITEM.ITEMCODE, POL.dbo.AR_INVOICEHISTORYHEADER_Union.INVOICEDATE
                     
HAVING SUM(POL.dbo.AR_INVOICEHISTORYDETAIL_Union.QUANTITYSHIPPED)>0
)
SELECT LastInvoiceDate,LastQuantityShipped,LastPrice
	FROM LASTORDERED
	WHERE RN = 1
END
