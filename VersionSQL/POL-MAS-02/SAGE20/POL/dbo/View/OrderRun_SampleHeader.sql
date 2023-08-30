/****** Object:  View [dbo].[OrderRun_SampleHeader]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[OrderRun_SampleHeader]
AS
SELECT     MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate as PurchaseOrderDate, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.RequisitorName, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToName, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToAddress1, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToAddress2, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToAddress3 
                      AS SpecialDeliveryInstructions, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCity, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToState, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToZipCode, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipVia, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCode AS ShipTo, SUM(ROUND(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered, 2)) AS TotalQuantityFDL, 
                      ROUND(SUM(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered), 2) AS TotalQuantityPOL, MAS_POL.dbo.PO_PurchaseOrderHeader.RequisitorDepartment as Comment, 
                      MAS_POL.dbo.PO_MaterialReqHeader.BatchNo, COUNT(MAS_POL.dbo.PO_PurchaseOrderDetail.LineKey) AS ItemCount, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType, MAS_POL.dbo.PO_PurchaseOrderDetail.ItemType,
					  CASE WHEN MAS_POL.dbo.PO_PurchaseOrderHeader.UDF_GUARANTEED_AM = 'Y' THEN 'AM' ELSE '' END AS AM
FROM         MAS_POL.dbo.PO_MaterialReqHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderHeader ON 
                      MAS_POL.dbo.PO_MaterialReqHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo
GROUP BY MAS_POL.dbo.PO_MaterialReqHeader.PurchaseOrderNo, MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate, MAS_POL.dbo.PO_PurchaseOrderHeader.RequisitorName, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToName, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToAddress1, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToAddress2, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToAddress3, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCity, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToState, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToZipCode, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.ShipVia, MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCode, MAS_POL.dbo.PO_PurchaseOrderHeader.RequisitorDepartment, 
                      MAS_POL.dbo.PO_MaterialReqHeader.BatchNo, MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType, MAS_POL.dbo.PO_PurchaseOrderDetail.ItemType,MAS_POL.dbo.PO_PurchaseOrderHeader.UDF_GUARANTEED_AM 
HAVING      (MAS_POL.dbo.PO_PurchaseOrderDetail.ItemType = '1')
