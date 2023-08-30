/****** Object:  Procedure [dbo].[PortalWebAccountItemHistoryInactive]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountItemHistoryInactive]
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
	ItemCode
FROM         
                      MAS_POL.dbo.AR_InvoiceHistoryHeader  INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo
WHERE     (InvoiceDate > DATEADD(year, - 2, GETDATE())) AND (ItemType = '1') AND 
                      ARDivisionNo = @DivisionNo and CustomerNo = @CustomerNo
GROUP BY InvoiceDate,ItemCode
HAVING      (SUM(QuantityShipped) > 0)
)
SELECT DISTINCT ITEMHISTORY.ItemCode,
				 UDF_BRAND_NAMES as Brand,
				 UDF_DESCRIPTION as Description,
				 UDF_VINTAGE as Vintage,
				 CAST(REPLACE(SalesUnitOfMeasure, 'C', '') AS INT) AS Uom,
				 UDF_BOTTLE_SIZE AS BottleSize,
				 UDF_DAMAGED_NOTES AS DamagedNotes,
				 UDF_COUNTRY AS Country
					FROM ITEMHISTORY INNER JOIN
                      MAS_POL.dbo.CI_Item ON ITEMHISTORY.ITEMCODE =MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON ITEMHISTORY.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode
 WHERE WarehouseCode= '000' AND (CATEGORY1 = 'N' OR (QuantityOnHand + QuantityOnPurchaseOrder + QuantityOnSalesOrder + QuantityOnBackOrder <= 0.04))
END
