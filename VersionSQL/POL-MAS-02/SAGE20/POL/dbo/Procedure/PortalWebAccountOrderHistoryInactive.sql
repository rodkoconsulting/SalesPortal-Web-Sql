/****** Object:  Procedure [dbo].[PortalWebAccountOrderHistoryInactive]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountOrderHistoryInactive]
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
				 UDF_COUNTRY AS Country,
				 CASE WHEN UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END AS Focus,
				 CASE WHEN UDF_RESTRICT_OFFSALE = 'Y' THEN 'Y' ELSE '' END AS RestrictOffSale, 
                 CASE WHEN UDF_RESTRICT_NORETAIL = 'Y' THEN 'Y' ELSE '' END AS RestrictOnPremise, 
                 UDF_RESTRICT_OFFSALE_NOTES AS RestrictOffSaleNotes,
                 CASE WHEN UDF_RESTRICT_ALLOCATED = 'Y' THEN 'Y' ELSE '' END AS RestrictAllocated,
                 CASE WHEN UDF_RESTRICT_MAX > 0 THEN CONVERT(VARCHAR(3), CONVERT(INT, UDF_RESTRICT_MAX)) ELSE '' END AS RestrictMaxCases,
                 UDF_RESTRICT_MANAGER AS RestrictApproval,
                 UDF_RESTRICT_STATE AS RestrictState,          
                 CASE WHEN UDF_RESTRICT_SAMPLES = 'Y' THEN 'Y' ELSE '' END AS RestrictSamples, 
                 CASE WHEN UDF_RESTRICT_BO = 'Y' THEN 'Y' ELSE '' END AS RestrictBo, 
                 CASE WHEN UDF_RESTRICT_MO = 'Y' THEN 'Y' ELSE '' END AS RestrictMo,
                 CASE WHEN CATEGORY3 = 'Y' THEN 'Y' ELSE '' END AS 'Core',
                 IsNull(v.UDF_VARIETAL,'') AS Varietal,
                 LEFT(UDF_ORGANIC, 1) AS Organic,
                 LEFT(UDF_BIODYNAMIC, 1) AS Biodynamic,
                 UDF_WINE_COLOR AS Type,
                 IsNull(r.UDF_REGION,'') AS Region,
                 IsNull(a.UDF_NAME,'') AS Appellation,
                 UDF_MASTER_VENDOR AS MasterVendor,
                 UDF_CLOSURE AS Closure,
                 UDF_UPC_CODE AS Upc,
                 UDF_PARKER AS ScoreWA,
                 UDF_SPECTATOR AS ScoreWS,
                 UDF_TANZER AS ScoreIWC,
                 UDF_BURGHOUND AS ScoreBH,
                 UDF_GALLONI_SCORE AS ScoreVM,
                 UDF_VFC AS ScoreOther,
                 CASE WHEN UDF_BM_FOCUS = 'Y' THEN 'Y' ELSE '' END AS FocusBm
		FROM ITEMHISTORY INNER JOIN
                      MAS_POL.dbo.CI_Item ON ITEMHISTORY.ITEMCODE =MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON ITEMHISTORY.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode  LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
 WHERE WarehouseCode= '000' AND (CATEGORY1 = 'N' OR (QuantityOnHand + QuantityOnPurchaseOrder + QuantityOnSalesOrder + QuantityOnBackOrder <= 0.04))
END



                      
                     
                     

                      
                      
                      
                       
                      
                      
                      
 
