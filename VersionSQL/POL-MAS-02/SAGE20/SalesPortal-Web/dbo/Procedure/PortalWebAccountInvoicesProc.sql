/****** Object:  Procedure [dbo].[PortalWebAccountInvoicesProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountInvoicesProc]
	-- Add the parameters for the stored procedure here
	@AcctNo varchar(12)
AS
BEGIN
	DECLARE @DivisionNo char(2);
	DECLARE @CustomerNo varchar(10);
	SELECT @DivisionNo = LEFT(@AcctNo,2)
	SELECT @CustomerNo = SUBSTRING(@AcctNo,3,len(@AcctNo)-2)
SET NOCOUNT ON;
WITH History AS
(
SELECT     
		h.InvoiceNo as InvNo
		, CASE WHEN InvoiceType='CM' THEN 'C' ELSE 'I' END as [Type]
		, ItemCode as Code
		, CONVERT(varchar,InvoiceDate,12) as [Date]
		, CONVERT(DECIMAL(9,2),(ROUND(QuantityShipped,2))) as Qty
		, CONVERT(DECIMAL(9,2),(ROUND(UnitPrice,2))) as Price
		, CONVERT(DECIMAL(9,2),(ROUND(ExtensionAmt,2))) as Total
		, Comment as Cmt
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail Det ON h.InvoiceNo = Det.InvoiceNo AND h.HeaderSeqNo = Det.HeaderSeqNo   
WHERE InvoiceDate >= DATEADD(YEAR, -2, GETDATE()) and ModuleCode = 'S/O' and ARDivisionNo = @DivisionNo and CustomerNo = @CustomerNo
)
SELECT Main = (SELECT
				h.InvNo as InvNo
				, h.[Date]
				, h.[Type]
				, h.Cmt
				, h.Code
				, h.Qty
				, h.Price
				, h.Total
				FROM History h
				FOR JSON AUTO
),
Item = (SELECT DISTINCT 
			h.Code
			, UDF_BRAND_NAMES as Brand
			, UDF_DESCRIPTION as [Description]
			, UDF_VINTAGE as Vintage
			, CAST(REPLACE(SalesUnitOfMeasure, 'C', '') AS INT) AS Uom
			, UDF_BOTTLE_SIZE AS Size
			, UDF_DAMAGED_NOTES AS DamNotes
			, UDF_WINE_COLOR as [Type]
			, IsNull(v.UDF_VARIETAL,'') as Varietal
			, IsNull(r.UDF_REGION,'') as Region
			, IsNull(a.UDF_NAME,'') as App
			, UDF_MASTER_VENDOR as MVendor
			, CASE WHEN ISNULL(UDF_BM_FOCUS,'')='Y' THEN 'Y' ELSE '' END as FocusBm
			, UDF_COUNTRY AS Country
		FROM History h INNER JOIN
			MAS_POL.dbo.CI_Item i ON h.Code = i.ItemCode LEFT OUTER JOIN
			MAS_POL.dbo.CI_UDT_VARIETALS AS v ON i.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
			MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
			MAS_POL.dbo.CI_UDT_APPELLATION as a ON i.UDF_SUBREGION_T = a.UDF_APPELLATION
		WHERE ItemType = '1'
		FOR JSON PATH
 )
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
