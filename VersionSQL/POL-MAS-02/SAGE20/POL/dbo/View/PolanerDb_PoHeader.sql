﻿/****** Object:  View [dbo].[PolanerDb_PoHeader]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PolanerDb_PoHeader]
AS
SELECT  MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo
		,MAS_POL.dbo.PO_PurchaseOrderHeader.UDF_SHIPMENT_NUM
		,MAS_POL.dbo.AP_Vendor.VendorName
		,MAS_SYSTEM.dbo.SY_Country.CountryName
		,MAS_SYSTEM.dbo.SY_Country.CountryName + ' - ' + MAS_POL.dbo.PO_PurchaseOrderHeader.UDF_SHIPMENT_NUM + ' - ' + MAS_POL.dbo.AP_Vendor.VendorName + ' - ' +  MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo  AS 'Comment'
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON
                      MAS_POL.dbo.PO_PurchaseOrderHeader.APDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND
                      MAS_POL.dbo.PO_PurchaseOrderHeader.VendorNo = MAS_POL.dbo.AP_Vendor.VendorNo INNER JOIN
                      MAS_SYSTEM.dbo.SY_Country ON
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseCountryCode = MAS_SYSTEM.dbo.SY_Country.CountryCode
WHERE     (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'S') AND
		  (MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived > 0) AND
		  (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus<>'B') AND
		  (MAS_POL.dbo.PO_PurchaseOrderDetail.WarehouseCode = '000')
GROUP BY MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, MAS_POL.dbo.PO_PurchaseOrderHeader.UDF_SHIPMENT_NUM, MAS_POL.dbo.AP_Vendor.VendorName, MAS_SYSTEM.dbo.SY_Country.CountryName                     
