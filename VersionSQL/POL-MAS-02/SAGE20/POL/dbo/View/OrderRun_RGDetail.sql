/****** Object:  View [dbo].[OrderRun_RGDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[OrderRun_RGDetail]
AS
SELECT     MAS_POL.dbo.PO_ReturnHeader.ReturnNo, MAS_POL.dbo.PO_ReturnDetail.ItemCode, MAS_POL.dbo.PO_ReturnDetail.ItemType, MAS_POL.dbo.PO_ReturnDetail.QuantityOrdered, 
                      MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE, MAS_POL.dbo.CI_Item.UDF_VINTAGE
FROM         MAS_POL.dbo.PO_ReturnHeader INNER JOIN
                      MAS_POL.dbo.PO_ReturnDetail ON MAS_POL.dbo.PO_ReturnHeader.ReturnNo = MAS_POL.dbo.PO_ReturnDetail.ReturnNo AND 
                      MAS_POL.dbo.PO_ReturnHeader.ReturnType = MAS_POL.dbo.PO_ReturnDetail.ReturnType INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.PO_ReturnDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode
where MAS_POL.dbo.CI_Item.ItemType=1
