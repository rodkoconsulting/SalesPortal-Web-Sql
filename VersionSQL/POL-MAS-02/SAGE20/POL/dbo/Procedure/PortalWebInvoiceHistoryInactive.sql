/****** Object:  Procedure [dbo].[PortalWebInvoiceHistoryInactive]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebInvoiceHistoryInactive]
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
	WITH INVOICEHISTORY AS
(
SELECT     
	ItemCode
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN MAS_POL.dbo.AR_InvoiceHistoryDetail d ON h.InvoiceNo = d.InvoiceNo AND h.HeaderSeqNo = d.HeaderSeqNo
												   INNER JOIN MAS_POL.dbo.AR_Customer c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo
                  
where InvoiceDate >= DATEADD(YEAR, -2, GETDATE()) and ModuleCode = 'S/O' and ((@AccountType = 'REP' and (h.SalespersonNo = @RepCode or c.SalespersonNo = @RepCode)) or (@AccountType = 'OFF') )
)
SELECT DISTINCT INVOICEHISTORY.ItemCode,
				 UDF_BRAND_NAMES as Brand,
				 UDF_DESCRIPTION as Description,
				 UDF_VINTAGE as Vintage,
				 CAST(REPLACE(SalesUnitOfMeasure, 'C', '') AS INT) AS Uom,
				 UDF_BOTTLE_SIZE AS BottleSize,
				 UDF_DAMAGED_NOTES AS DamagedNotes,
				 UDF_WINE_COLOR as Type,
				 IsNull(v.UDF_VARIETAL,'') as Varietal,
				 IsNull(r.UDF_REGION,'') as Region,
				 IsNull(a.UDF_NAME,'') as Appellation,
				 UDF_MASTER_VENDOR as MasterVendor,
				 CASE WHEN ISNULL(UDF_BM_FOCUS,'')='Y' THEN 'Y' ELSE '' END as FocusBm,
				 UDF_COUNTRY AS Country
					FROM INVOICEHISTORY INNER JOIN
                      MAS_POL.dbo.CI_Item ON INVOICEHISTORY.ITEMCODE =MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON INVOICEHISTORY.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode  LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
 WHERE WarehouseCode= '000' AND (CATEGORY1 = 'N' OR (QuantityOnHand + QuantityOnPurchaseOrder + QuantityOnSalesOrder + QuantityOnBackOrder <= 0.04)) AND CI_Item.ItemType = '1'
END
