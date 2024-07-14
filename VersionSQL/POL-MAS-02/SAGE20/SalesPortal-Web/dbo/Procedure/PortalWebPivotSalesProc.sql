﻿/****** Object:  Procedure [dbo].[PortalWebPivotSalesProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PivotSales_Proc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25),
	@CurrentStart varchar(8),
	@CurrentEnd varchar(8),
	@PreviousStart varchar(8),
	@PreviousEnd varchar(8)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
	DECLARE @CurrentStartDate date;
	DECLARE @CurrentEndDate date;
	DECLARE @PreviousStartDate date;
	DECLARE @PreviousEndDate date;
	SELECT @CurrentStartDate = TRY_CAST(@CurrentStart as date);
	SELECT @CurrentEndDate = TRY_CAST(@CurrentEnd as date);
	SELECT @PreviousStartDate = TRY_CAST(@PreviousStart as date);
	SELECT @PreviousEndDate = TRY_CAST(@PreviousEnd as date);
	SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
	SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName   
	SELECT Main = (
	SELECT  
			IsNull(pl.ProductLineDesc,'') as ProductLine
			, IsNull(i.UDF_MASTER_VENDOR, '') as MasterVendor
			, IsNull(v.VendorName, '') as Vendor
			, IsNull(i.UDF_BRAND, '') as Brand
			, IsNull(i.UDF_COUNTRY, '') as Country
			, IsNull(i.UDF_REGION, '') as Region
			, IsNull(i.UDF_SUBREGION_T, '') as Appellation
			, MAX(CASE WHEN IsNull(i.UDF_SAMPLE_FOCUS,'') = 'Y' THEN 'Y' ELSE '' END) as Focus
			, c.CustomerNo
			, c.CustomerName as Customer
			, c.UDF_AFFILIATIONS as Affiliations
			, c.SortField as Premise
			, sp.SalespersonNo as Rep
			, sp.UDF_TERRITORY as RepTerritory
			, s.UDF_TERRITORY AS CustTerritory
			, sh.UDF_COUNTY as County
			, c.UDF_PREMISIS_CITY as City
			, c.UDF_PREMISIS_STATE as State
			, c.UDF_PREMISIS_ZIP as Zip
			, IsNull(i.UDF_BRAND_NAMES +' '+ i.UDF_DESCRIPTION +' ('+ REPLACE(i.SalesUnitOfMeasure,'C','')+'/'+ (CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN REPLACE(i.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(i.UDF_BOTTLE_SIZE,' ','') END)+')', '') as 'Desc'
			, CONVERT(DECIMAL(9,2),(ROUND(SUM(CASE WHEN h.TransactionDate between @PreviousStartDate and @PreviousEndDate THEN d.QuantityShipped ELSE 0 END), 2))) as PriorYrCase
			, CONVERT(DECIMAL(9,2),(ROUND(SUM(CASE WHEN h.TransactionDate between @CurrentStartDate and @CurrentEndDate THEN d.QuantityShipped ELSE 0 END), 2))) as CurrentYrCase
			, CONVERT(DECIMAL(9,2),(ROUND(SUM(CASE WHEN h.TransactionDate between @PreviousStartDate and @PreviousEndDate THEN d.ExtensionAmt ELSE 0 END), 2))) as PriorYrDol
			, CONVERT(DECIMAL(9,2),(ROUND(SUM(CASE WHEN h.TransactionDate between @CurrentStartDate and @CurrentEndDate THEN d.ExtensionAmt ELSE 0 END), 2))) as CurrentYrDol
		FROM            MAS_POL.dbo.AP_Vendor v RIGHT OUTER JOIN MAS_POL.dbo.CI_Item i LEFT OUTER JOIN
                         MAS_POL.dbo.IM_ProductLine pl ON i.ProductLine = pl.ProductLine ON v.APDivisionNo = i.PrimaryAPDivisionNo AND v.VendorNo = i.PrimaryVendorNo RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_InvoiceHistoryDetail d RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_InvoiceHistoryHeader h ON d.InvoiceNo = h.InvoiceNo AND d.HeaderSeqNo = h.HeaderSeqNo ON i.ItemCode = d.ItemCode RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_Customer c LEFT OUTER JOIN
                         MAS_POL.dbo.AR_Salesperson sp ON c.SalespersonNo = sp.SalespersonNo AND c.SalespersonDivisionNo = sp.SalespersonDivisionNo ON h.ARDivisionNo = c.ARDivisionNo AND 
                         h.CustomerNo = c.CustomerNo LEFT OUTER JOIN
                         MAS_POL.dbo.AR_UDT_SHIPPING s RIGHT OUTER JOIN
                         MAS_POL.dbo.SO_ShipToAddress sh ON s.UDF_REGION_CODE = sh.UDF_REGION_CODE ON 
                         c.PrimaryShipToCode = sh.ShipToCode AND c.CustomerNo = sh.CustomerNo AND c.ARDivisionNo = sh.ARDivisionNo
		WHERE	((@AccountType = 'REP' and c.SalesPersonNo = @RepCode) or (@AccountType = 'OFF') ) AND
				(c.SortField like '%REST' OR c.SortField like '%RETAIL' OR c.SortField = 'WHOLESALE') AND
					sp.SalespersonNo != 'NC01' AND
					(
						h.InvoiceNo IS NULL OR
						(
							h.TransactionDate between @PreviousStartDate and @CurrentEndDate AND
							h.ModuleCode = 'S/O' AND
							d.ItemType = '1' AND
							d.UnitPrice > 0 AND
							d.WarehouseCode IN ('000', '902', '200') AND
							d.CostOfGoodsSoldAcctKey != '00000008M'
						)
					)
		GROUP BY pl.ProductLineDesc
				, i.UDF_MASTER_VENDOR
				, v.VendorName
				, i.UDF_BRAND
				, i.UDF_COUNTRY
				, i.UDF_REGION
				, i.UDF_SUBREGION_T
				, c.CustomerNo
				, c.CustomerName
				, c.UDF_AFFILIATIONS
				, c.SortField
				, sp.SalespersonNo
				, sp.UDF_TERRITORY
				, s.UDF_TERRITORY
				, sh.UDF_COUNTY
				, c.UDF_PREMISIS_CITY
				, c.UDF_PREMISIS_STATE
				, c.UDF_PREMISIS_ZIP
				, i.UDF_BRAND_NAMES
				, i.UDF_DESCRIPTION
				, i.SalesUnitOfMeasure
				, i.UDF_BOTTLE_SIZE
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
