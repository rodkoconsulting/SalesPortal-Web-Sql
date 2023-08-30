/****** Object:  View [dbo].[SO_InvoiceDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SO_InvoiceDetail]
AS
SELECT     InvoiceNo, QuantityShipped, UnitOfMeasure, UnitPrice, ItemCode, ExtensionAmt, ItemType
FROM         MAS_POL.dbo.SO_InvoiceDetail
