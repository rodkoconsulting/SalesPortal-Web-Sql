/****** Object:  Procedure [dbo].[SalesPortal_Pivot_Proc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SalesPortal_Pivot_Proc]
	@Date datetime,
	@UserCode char(4),
	@UserType char(3)
AS
BEGIN
DECLARE @PREV_YEAR int;
DECLARE @CURR_YEAR int;
DECLARE @PREV_DATE datetime;
DECLARE @CURR_DATE datetime;
SET @PREV_YEAR = YEAR(@Date) - 1;
SET @CURR_YEAR = YEAR(@Date);
SET @PREV_DATE = DATEADD(YEAR, - 1, @Date);
SET @CURR_DATE = @Date;
WITH INVOICES AS (
SELECT     MAS_POL.dbo.IM_ProductLine.ProductLineDesc AS 'ProductLine', MAS_POL.dbo.CI_Item.UDF_MASTER_VENDOR AS 'MasterVendor', 
                      MAS_POL.dbo.AP_Vendor.VendorName AS 'Vendor', MAS_POL.dbo.CI_Item.UDF_BRAND AS 'Brand', MAS_POL.dbo.CI_Item.UDF_COUNTRY AS 'Country', 
                      MAS_POL.dbo.AR_Customer.CustomerNo AS 'CustomerNo',  MAS_POL.dbo.AR_Customer.ARDivisionNo AS 'ARDivisionNo', MAS_POL.dbo.AR_Customer.SalespersonNo AS 'Rep', 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_Item.UDF_DESCRIPTION + ' (' + REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, 'C', '') 
                      + '/' + REPLACE(CASE WHEN CHARINDEX('ML', MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE) 
                      > 0 THEN RTRIM(LTRIM(REPLACE(MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE, 'ML', ''))) ELSE REPLACE(MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE, ' ', '') END + ')', ' ', 
                      '') AS 'Description', MAX(CASE WHEN MAS_POL.dbo.CI_UDT_BRANDS_GOALS.UDF_GOAL > 0 THEN 'Y' ELSE '' END) AS 'SupplierGoal', 
                      MAX(CASE WHEN MAS_POL.dbo.CI_UDT_BRANDS_GOALS.UDF_GOAL_REPS > 0 THEN 'Y' ELSE '' END) AS 'RepGoal', 
                      MAX(CASE WHEN MAS_POL.dbo.CI_Item.UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END) AS 'FocusItem', 
                      SUM(CASE WHEN YEAR(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate) = @PREV_YEAR AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= @PREV_DATE
                      THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped ELSE 0 END) AS 'PriorYrCase', 
                      SUM(CASE WHEN YEAR(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate) = @CURR_YEAR AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= @CURR_DATE THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped ELSE 0 END) 
                      AS 'CurrentYrCase', SUM(CASE WHEN YEAR(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate) = @PREV_YEAR AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= @PREV_DATE
                      THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.ExtensionAmt ELSE 0 END) AS 'PriorYrDollar', 
                      SUM(CASE WHEN YEAR(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate) = @CURR_YEAR AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= @CURR_DATE THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.ExtensionAmt ELSE 0 END) 
	                  AS 'CurrentYrDollar'
FROM         MAS_POL.dbo.AR_InvoiceHistoryDetail RIGHT OUTER JOIN
                      MAS_POL.dbo.AR_Customer LEFT OUTER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_Customer.CustomerNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo AND 
                      MAS_POL.dbo.AR_Customer.ARDivisionNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo ON 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo LEFT OUTER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode LEFT OUTER JOIN
                      MAS_POL.dbo.CI_UDT_BRANDS_GOALS ON MAS_POL.dbo.CI_Item.UDF_BRAND = MAS_POL.dbo.CI_UDT_BRANDS_GOALS.UDF_BRAND AND 
                      MAS_POL.dbo.CI_Item.UDF_DESCRIPTION = MAS_POL.dbo.CI_UDT_BRANDS_GOALS.UDF_DESCRIPTION AND 
                      @CURR_YEAR = MAS_POL.dbo.CI_UDT_BRANDS_GOALS.UDF_YEAR LEFT OUTER JOIN
                      MAS_POL.dbo.IM_ProductLine ON MAS_POL.dbo.CI_Item.ProductLine = MAS_POL.dbo.IM_ProductLine.ProductLine LEFT OUTER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo
WHERE	
	      (MAS_POL.dbo.AR_Customer.SortField LIKE 'NY%' OR MAS_POL.dbo.AR_Customer.SortField LIKE 'NJ%') AND
         ((@UserType = 'REP' AND MAS_POL.dbo.AR_Customer.SalespersonNo = @UserCode) OR @UserType = 'OFF') AND              
         (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = '1') AND
		 (MAS_POL.dbo.AR_InvoiceHistoryDetail.WarehouseCode = '000') AND 
         (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ARDivisionNo = '00') AND
         (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ModuleCode = 'S/O') AND
         ((MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate >= DATEFROMPARTS (@PREV_YEAR, 1, 1 )  AND MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= @PREV_DATE) OR
         (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate >= DATEFROMPARTS (@CURR_YEAR, 1, 1 )  AND MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= @CURR_DATE))
                                          
GROUP BY MAS_POL.dbo.IM_ProductLine.ProductLineDesc, MAS_POL.dbo.CI_Item.UDF_MASTER_VENDOR, MAS_POL.dbo.CI_Item.UDF_BRAND, 
                      MAS_POL.dbo.AP_Vendor.VendorName, MAS_POL.dbo.CI_Item.UDF_COUNTRY, MAS_POL.dbo.AR_Customer.CustomerNo, MAS_POL.dbo.AR_Customer.ARDivisionNo, 
                      MAS_POL.dbo.AR_Customer.SalespersonNo, 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES, MAS_POL.dbo.CI_Item.UDF_DESCRIPTION, MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, 
                      MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE
)
SELECT ProductLine, MasterVendor, Vendor, Brand, Country, AR_Customer.CustomerName as 'Customer', AR_Customer.UDF_AFFILIATIONS as 'Affiliations', AR_Customer.SortField as 'Premise',
 AR_Customer.SalespersonNo as 'Rep', AR_Salesperson.UDF_TERRITORY as 'Territory', AR_UDT_SHIPPING.UDF_TERRITORY as 'Cust. Region', SO_ShipToAddress.UDF_COUNTY as 'County',
 INVOICES.[Description], SupplierGoal, RepGoal, FocusItem, PriorYrCase, CurrentYrCase, PriorYrDollar, CurrentYrDollar                    
FROM         MAS_POL.dbo.AR_Salesperson RIGHT OUTER JOIN
                      MAS_POL.dbo.SO_ShipToAddress LEFT OUTER JOIN
                      MAS_POL.dbo.AR_UDT_SHIPPING ON 
                      MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE = MAS_POL.dbo.AR_UDT_SHIPPING.UDF_REGION_CODE RIGHT OUTER JOIN
                      MAS_POL.dbo.AR_Customer LEFT OUTER JOIN
                      INVOICES ON MAS_POL.dbo.AR_Customer.CustomerNo = INVOICES.CustomerNo AND 
                      MAS_POL.dbo.AR_Customer.ARDivisionNo = INVOICES.ARDivisionNo ON 
                      MAS_POL.dbo.SO_ShipToAddress.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.SO_ShipToAddress.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo AND 
                      MAS_POL.dbo.SO_ShipToAddress.ShipToCode = MAS_POL.dbo.AR_Customer.PrimaryShipToCode ON 
                      MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = MAS_POL.dbo.AR_Customer.SalespersonDivisionNo AND 
                      MAS_POL.dbo.AR_Salesperson.SalespersonNo = MAS_POL.dbo.AR_Customer.SalespersonNo
WHERE ((@UserType = 'REP' AND MAS_POL.dbo.AR_Customer.SalespersonNo = @UserCode) OR @UserType = 'OFF') AND
(MAS_POL.dbo.AR_Customer.SortField LIKE 'NY%' OR MAS_POL.dbo.AR_Customer.SortField LIKE 'NJ%')                     

END
