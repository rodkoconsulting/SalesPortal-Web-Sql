/****** Object:  Procedure [dbo].[PortalWebAccountInvoiceHistoryInactive]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountInvoiceHistoryInactive]
	-- Add the parameters for the stored procedure here
	@AcctNo varchar(12)
AS
BEGIN
	DECLARE @DivisionNo char(2);
	DECLARE @CustomerNo varchar(10);
SELECT @DivisionNo = LEFT(@AcctNo,2)
SELECT @CustomerNo = SUBSTRING(@AcctNo,3,len(@AcctNo)-2)
	SET NOCOUNT ON;
	WITH INVOICEHISTORY AS
(
SELECT     
	ItemCode
FROM         
                      MAS_POL.dbo.AR_InvoiceHistoryHeader  INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo
WHERE     (InvoiceDate > DATEADD(year, - 2, GETDATE())) and ModuleCode = 'S/O' AND (ItemType = '1') AND 
                      ARDivisionNo = @DivisionNo and CustomerNo = @CustomerNo
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
                      MAS_POL.dbo.IM_ItemWarehouse ON INVOICEHISTORY.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
 WHERE WarehouseCode= '000' AND (CATEGORY1 = 'N' OR (QuantityOnHand + QuantityOnPurchaseOrder + QuantityOnSalesOrder + QuantityOnBackOrder <= 0.04))
END
