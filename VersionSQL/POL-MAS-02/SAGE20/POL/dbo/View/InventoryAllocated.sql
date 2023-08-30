/****** Object:  View [dbo].[InventoryAllocated]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[InventoryAllocated] AS
SELECT		i.ITEMCODE as ItemCode
			, i.UDF_BRAND_NAMES +' '+ i.UDF_DESCRIPTION +' '+i.UDF_VINTAGE+' ('+REPLACE(i.SalesUnitOfMeasure,'C','')+'/'
				+(CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN REPLACE(i.UDF_BOTTLE_SIZE,' ML','')
				ELSE REPLACE(i.UDF_BOTTLE_SIZE,' ','') END)+') '+i.UDF_DAMAGED_NOTES AS ItemDescription
			, inv.OnBO as OnBO
			, p.OnPO as OnPO
			, p.PoDate
			, CASE WHEN YEAR(p.RequiredDate) >  2000 THEN p.RequiredDate else '1/1/3000' end as PoETA
			, p.AvailableComment as 'Avail. Comment'
			, CASE WHEN i.UDF_COUNTRY = 'USA' THEN '1USA' ELSE i.UDF_COUNTRY END as Country
			, i.UDF_BRAND as 'Vendor'
FROM         MAS_POL.dbo.CI_Item i INNER JOIN
                      dbo.IM_InventoryAvailable inv ON i.ItemCode = inv.ITEMCODE INNER JOIN
                      dbo.Web_Inventory_PO p ON i.ItemCode = p.ItemCode    
WHERE i.UDF_RESTRICT_ALLOCATED='Y' AND p.OnPO > 0 AND ROUND(p.OnPO,2) - ROUND(inv.OnBO,2) > 0
