/****** Object:  Procedure [dbo].[PortalWebOrdersInactive]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PortalWebOrdersInactive]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName   
	SET NOCOUNT ON;
	WITH Items AS
(
SELECT     DISTINCT ItemCode
FROM         MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN MAS_POL.dbo.SO_InvoiceDetail d
				ON h.InvoiceNo = d.InvoiceNo
WHERE    SalesOrderNo = '' and ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT     DISTINCT ItemCode
FROM         MAS_POL.dbo.SO_SalesOrderHeader h INNER JOIN
                       MAS_POL.dbo.SO_SalesOrderDetail d ON h.SalesOrderNo = d.SalesOrderNo
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%')) and (CAST(ROUND(QuantityOrdered,2) AS FLOAT) > 0 or ROUND(ExtensionAmt,2) > 0)
UNION ALL
SELECT     DISTINCT ItemCode
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
                       MAS_POL.dbo.AR_InvoiceHistoryDetail d ON h.InvoiceNo = d.InvoiceNo and
					   h.HeaderSeqNo = d.HeaderSeqNo
WHERE    InvoiceDate > GETDATE() and InvoiceDate < DateAdd(YEAR, 1, GETDATE()) AND ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT	   DISTINCT ItemCode
FROM PO_PurchaseOrderHeader h
			INNER JOIN PortalPoAddress a ON h.ShipToCode = a.ShipToCode
			INNER JOIN PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo
		    WHERE h.OrderType = 'X' AND h.OrderStatus <> 'X' AND h.RequiredExpireDate > GETDATE() AND ((@AccountType = 'REP' and a.Rep = @RepCode) or @AccountType = 'OFF')
)
SELECT DISTINCT Items.ItemCode,
				 UDF_BRAND_NAMES as Brand,
				 UDF_DESCRIPTION as Description,
				 UDF_VINTAGE as Vintage,
				 CAST(REPLACE(SalesUnitOfMeasure, 'C', '') AS INT) AS Uom,
				 UDF_BOTTLE_SIZE AS BottleSize,
				 UDF_DAMAGED_NOTES AS DamagedNotes
				 FROM Items INNER JOIN
                      MAS_POL.dbo.CI_Item ON Items.ITEMCODE = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON Items.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode
 WHERE WarehouseCode= '000' AND (CATEGORY1 = 'N' OR (QuantityOnHand + QuantityOnPurchaseOrder + QuantityOnSalesOrder + QuantityOnBackOrder <= 0.04))
END
