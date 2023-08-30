/****** Object:  View [dbo].[Web_SalesOrders_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_SalesOrders_old]
AS
SELECT        MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo, MAS_POL.dbo.AR_Customer.CustomerName AS BILLTONAME, MAS_POL.dbo.SO_SalesOrderHeader.OrderDate,
                          CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'MO' OR
                         MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' THEN MAS_POL.dbo.SO_SALESORDERHEADER.SHIPEXPIREDATE ELSE NULL 
                         END AS EXPDATE, CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'MO' OR
                         MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BO' OR
                         MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' THEN NULL 
                         ELSE MAS_POL.dbo.SO_SALESORDERHEADER.SHIPEXPIREDATE END AS SHIPDATE, 
                         CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' THEN MAS_POL.dbo.SO_SALESORDERHEADER.UDF_ARRIVAL_DATE ELSE NULL
                          END AS ARRIVALDATE, CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'MO' OR
                         MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BH' THEN 'MO' WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BO' OR
                         MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' THEN 'BO' WHEN MAS_POL.dbo.SO_SalesOrderDetail.ExtensionAmt = 0 THEN 'BH' ELSE 'S' END
                          AS ORDERTYPE, CASE WHEN (MAS_POL.dbo.SO_SALESORDERHEADER.ORDERTYPE = 'S' AND MAS_POL.dbo.SO_SALESORDERHEADER.ORDERSTATUS = 'H') OR
                         MAS_POL.dbo.SO_SALESORDERHEADER.ORDERTYPE = 'B' THEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE ELSE '' END AS HOLDCODE, 
                         CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BO' THEN dbo.PO_Inventory_ETA.RequiredDate ELSE NULL END AS BOETA, 
                         MAS_POL.dbo.SO_SalesOrderDetail.QuantityOrdered, MAS_POL.dbo.SO_SalesOrderDetail.UnitPrice, MAS_POL.dbo.SO_SalesOrderDetail.ExtensionAmt, 
                         CASE WHEN MAS_POL.dbo.SO_SALESORDERDETAIL.ITEMTYPE = 1 THEN MAS_POL.dbo.CI_ITEM.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION
                          + ' ' + MAS_POL.dbo.CI_ITEM.UDF_VINTAGE + ' (' + REPLACE(MAS_POL.dbo.ci_item.SalesUnitOfMeasure, 'C', '') + '/' + (CASE WHEN CHARINDEX('ML', 
                         MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ML', '') 
                         ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END) 
                         + ') ' + MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES ELSE MAS_POL.dbo.SO_SALESORDERDETAIL.ITEMCODEDESC END AS ItemDescription, 
                         MAS_POL.dbo.SO_SalesOrderDetail.ItemCode, CAST(REPLACE(MAS_POL.dbo.SO_SalesOrderDetail.UnitOfMeasure, 'C', '') AS INT) AS UOM, 
                         CASE WHEN MAS_POL.dbo.SO_INVOICEHEADER.SALESORDERNO IS NULL THEN '' ELSE 'x' END AS Invoiced, 
                         MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY AS Territory, MAS_POL.dbo.SO_SalesOrderHeader.SalespersonNo, MAS_POL.dbo.SO_SalesOrderDetail.LineKey, 
                         MAS_POL.dbo.SO_SalesOrderHeader.Comment, CASE WHEN IsNumeric(MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP) = 1 AND CHARINDEX('.', 
                         MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP) = 0 THEN CAST(MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP AS INT) ELSE NULL 
                         END AS CoopNo, CASE WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) 
                         = 'N' THEN 'On' WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'F' THEN 'Off' ELSE '' END AS Premise
						 , MAS_POL.dbo.AR_Customer.UDF_AFFILIATIONS As Affiliations
FROM            MAS_POL.dbo.SO_SalesOrderHeader INNER JOIN
                         MAS_POL.dbo.SO_SalesOrderDetail ON MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo = MAS_POL.dbo.SO_SalesOrderDetail.SalesOrderNo INNER JOIN
                         MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.SO_SalesOrderHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                         MAS_POL.dbo.SO_SalesOrderHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo INNER JOIN
                         MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.SO_SalesOrderHeader.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                         MAS_POL.dbo.SO_SalesOrderHeader.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                         MAS_POL.dbo.CI_Item ON MAS_POL.dbo.SO_SalesOrderDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode LEFT OUTER JOIN
                         MAS_POL.dbo.SO_InvoiceHeader ON MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo = MAS_POL.dbo.SO_InvoiceHeader.SalesOrderNo LEFT OUTER JOIN
                         dbo.PO_Inventory_ETA ON MAS_POL.dbo.SO_SalesOrderDetail.ItemCode = dbo.PO_Inventory_ETA.ItemCode
WHERE        (MAS_POL.dbo.SO_SalesOrderDetail.ItemType = 1) AND (MAS_POL.dbo.SO_SalesOrderDetail.QuantityOrdered > 0) OR
                         (MAS_POL.dbo.SO_SalesOrderDetail.ItemType = 3) AND (MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = '00')
