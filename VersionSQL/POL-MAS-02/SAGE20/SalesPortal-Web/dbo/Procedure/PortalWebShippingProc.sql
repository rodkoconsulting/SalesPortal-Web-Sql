/****** Object:  Procedure [dbo].[PortalWebShippingProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebShippingProc]
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName;  
SELECT Main = ( 
SELECT      IsNull(c.CountryName,'') as Ctry
				 , h.UDF_CONTAINER_NUM AS CntNo
				 , CASE WHEN h.UDF_SHIPMENT_NUM = '' THEN 'Unassigned' ELSE h.UDF_SHIPMENT_NUM END AS ShipNo
				 , s.ShippingCodeDesc AS Via
				 , h.UDF_FOREIGN_ENTRY AS EntryNo
				 , IsNull(h.UDF_PORT,'') as Port
				 , h.PurchaseOrderNo AS PoNo
				 , CONVERT(varchar,h.PurchaseOrderDate,23) AS PoDate
				 , CASE WHEN YEAR(h.RequiredExpireDate) > 2000 THEN CONVERT(varchar,h.RequiredExpireDate,23) ELSE '' END as AvailDate
				 , h.UDF_AVAILABLE_COMMENT as AvailCmt
				 , h.UDF_STATUS as RdyDate
				 , CASE WHEN h.UDF_ETD IS NULL THEN '' ELSE CONVERT(varchar,h.UDF_ETD,23) END AS ETD
				 , CASE WHEN h.UDF_ETA IS NULL THEN '' ELSE CONVERT(varchar,h.UDF_ETA,23) END AS ETA
				 , v.VendorName AS Vendor
				 , t.TermsCodeDesc AS Terms
				 , d.ItemCode AS ItemCode
				 , i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUnitOfMeasure, 'C', '') 
                         + '/' + (CASE WHEN CHARINDEX('ML', i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(i.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) + ') '
						  + i.UDF_DAMAGED_NOTES AS [ItemDesc]
			    , CONVERT(DECIMAL(9,2),(ROUND(d.QuantityOrdered,2))) as Qty
				, CONVERT(DECIMAL(9,2),(ROUND(i.Volume * d.QuantityOrdered,2))) as Lit
				, CONVERT(DECIMAL(9,2),(ROUND(i.Volume * i.StandardUnitCost,2))) as Cost
				, CONVERT(DECIMAL(9,2),(ROUND(d.ExtensionAmt,2))) as Tot
				, v.UDF_TTBFPID as TTB_FPID
				, v.UDF_TTB_MANUFACTURER as TTB_Manufacturer
				, CASE WHEN v.UDF_ASSIGNED = 'Y' THEN 'x' ELSE '' END as TTB_Assigned
FROM            MAS_POL.dbo.PO_PurchaseOrderHeader AS h INNER JOIN
                         MAS_POL.dbo.SO_ShippingRateHeader AS s ON h.ShipVia = s.ShippingCode INNER JOIN
                         MAS_POL.dbo.AP_Vendor AS v ON h.APDivisionNo = v.APDivisionNo AND h.VendorNo = v.VendorNo INNER JOIN
						 MAS_POL.dbo.AP_TermsCode AS t ON h.TermsCode = t.TermsCode INNER JOIN
                         MAS_POL.dbo.PO_PurchaseOrderDetail AS d ON h.PurchaseOrderNo = d.PurchaseOrderNo INNER JOIN
                         MAS_POL.dbo.CI_Item AS i ON d.ItemCode = i.ItemCode LEFT OUTER JOIN
                         MAS_POL.dbo.SY_Country c ON v.CountryCode = c.CountryCode
WHERE        (h.OrderStatus = 'O') AND (i.ItemType = '1') AND ((@AccountType = 'REP' and (1=2)) or (@AccountType = 'OFF') )
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
