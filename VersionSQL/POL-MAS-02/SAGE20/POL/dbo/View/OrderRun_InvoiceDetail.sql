﻿/****** Object:  View [dbo].[OrderRun_InvoiceDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[OrderRun_InvoiceDetail]
AS
SELECT     MAS_POL.dbo.SO_INVOICEDETAIL.INVOICENO, MAS_POL.dbo.SO_INVOICEDETAIL.LINEKEY, MAS_POL.dbo.SO_INVOICEDETAIL.ITEMTYPE, MAS_POL.dbo.SO_INVOICEDETAIL.QUANTITYORDERED, 
                      MAS_POL.dbo.CI_ITEM.SALESUNITOFMEASURE, MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, MAS_POL.dbo.SO_INVOICEDETAIL.ITEMCODE, MAS_POL.dbo.SO_INVOICEDETAIL.UNITPRICE, 
                      MAS_POL.dbo.SO_INVOICEDETAIL.EXTENSIONAMT, MAS_POL.dbo.CI_ITEM.UDF_VINTAGE, MAS_POL.dbo.SO_INVOICEHEADER.DISCOUNTAMT
FROM         MAS_POL.dbo.SO_INVOICEHEADER INNER JOIN
                      MAS_POL.dbo.SO_INVOICEDETAIL ON MAS_POL.dbo.SO_INVOICEHEADER.INVOICENO = MAS_POL.dbo.SO_INVOICEDETAIL.INVOICENO INNER JOIN
                      MAS_POL.dbo.CI_ITEM ON MAS_POL.dbo.SO_INVOICEDETAIL.ITEMCODE = MAS_POL.dbo.CI_ITEM.ITEMCODE
