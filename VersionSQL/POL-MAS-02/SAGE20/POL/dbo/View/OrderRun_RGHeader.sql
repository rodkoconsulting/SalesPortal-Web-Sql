/****** Object:  View [dbo].[OrderRun_RGHeader]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[OrderRun_RGHeader]
AS
SELECT     MAS_POL.dbo.PO_ReturnHeader.ReturnNo, MAS_POL.dbo.PO_ReturnHeader.ReturnDate, MAS_POL.dbo.PO_ReturnHeader.ShipToName, 
                      MAS_POL.dbo.PO_ReturnHeader.ShipToAddress1, MAS_POL.dbo.PO_ReturnHeader.ShipToAddress2, 
                      MAS_POL.dbo.PO_ReturnHeader.ShipToCity, MAS_POL.dbo.PO_ReturnHeader.ShipToState, MAS_POL.dbo.PO_ReturnHeader.ShipToZipCode, 
                      MAS_POL.dbo.PO_ReturnHeader.ShipVia, MAS_POL.dbo.PO_ReturnHeader.ShipToCode, SUM(ROUND(MAS_POL.dbo.PO_ReturnDetail.QuantityOrdered, 2)) 
                      AS TotalQuantityFDL, ROUND(SUM(MAS_POL.dbo.PO_ReturnDetail.QuantityOrdered), 2) AS TotalQuantityPOL, MAS_POL.dbo.PO_ReturnHeader.Comment,
                      MAS_POL.dbo.PO_ReturnHeader.BatchNo, COUNT(MAS_POL.dbo.PO_ReturnDetail.LineKey) AS ItemCount, 
                      MAS_POL.dbo.PO_ReturnDetail.ItemType
FROM         MAS_POL.dbo.PO_ReturnHeader INNER JOIN
                      MAS_POL.dbo.PO_ReturnDetail ON MAS_POL.dbo.PO_ReturnHeader.ReturnNo = MAS_POL.dbo.PO_ReturnDetail.ReturnNo
GROUP BY MAS_POL.dbo.PO_ReturnHeader.ReturnNo, PO_ReturnHeader.Comment, MAS_POL.dbo.PO_ReturnHeader.BatchNo, 
                      MAS_POL.dbo.PO_ReturnDetail.ItemType, MAS_POL.dbo.PO_ReturnHeader.ReturnDate, MAS_POL.dbo.PO_ReturnHeader.ShipToName, 
                      MAS_POL.dbo.PO_ReturnHeader.ShipToAddress1, MAS_POL.dbo.PO_ReturnHeader.ShipToAddress2, MAS_POL.dbo.PO_ReturnHeader.ShipToCity, 
                      MAS_POL.dbo.PO_ReturnHeader.ShipToState, MAS_POL.dbo.PO_ReturnHeader.ShipToZipCode, MAS_POL.dbo.PO_ReturnHeader.ShipVia, 
                      MAS_POL.dbo.PO_ReturnHeader.ShipToCode
HAVING      (MAS_POL.dbo.PO_ReturnDetail.ItemType = '1')
