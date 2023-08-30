/****** Object:  Procedure [dbo].[SP_OrderGuideCleanUpInvoiced]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_OrderGuideCleanUpInvoiced]
AS
BEGIN
	WITH LASTORDERED AS
(
    -- Insert statements for procedure here
SELECT    dbo.Web_Account_OgSaved.CUSTOMERNO, dbo.Web_Account_OgSaved.ITEMCODE, max(dbo.Portal_Account_ItemHistory.InvoiceDate) AS LastInvoiceDate
FROM         dbo.Portal_Account_ItemHistory INNER JOIN
                      dbo.Web_Account_OgSaved ON dbo.Portal_Account_ItemHistory.ItemCode = dbo.Web_Account_OgSaved.ITEMCODE AND 
                      dbo.Portal_Account_ItemHistory.CustomerNo = dbo.Web_Account_OgSaved.CUSTOMERNO
group by dbo.Web_Account_OgSaved.customerno, dbo.Web_Account_OgSaved.ITEMCODE
having max(dbo.Portal_Account_ItemHistory.InvoiceDate) <= DATEADD(YEAR, - 2, GETDATE())
)
DELETE dbo.Web_Account_OgSaved from dbo.Web_Account_OgSaved a
INNER JOIN LASTORDERED b
ON a.CUSTOMERNO = b.CUSTOMERNO and a.ITEMCODE = b.ITEMCODE
END
