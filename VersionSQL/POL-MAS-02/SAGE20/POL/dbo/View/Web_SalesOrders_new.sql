/****** Object:  View [dbo].[Web_SalesOrders_new]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_SalesOrders_new]
AS
SELECT       MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo
			, MAS_POL.dbo.AR_Customer.CustomerName AS BILLTONAME
			, MAS_POL.dbo.SO_SalesOrderHeader.OrderDate
			, CASE WHEN CANCELREASONCODE = 'MO' OR CANCELREASONCODE = 'IN' THEN SHIPEXPIREDATE ELSE NULL END AS EXPDATE
			, CASE WHEN CANCELREASONCODE = 'MO' OR CANCELREASONCODE = 'BO' OR CANCELREASONCODE = 'IN' THEN NULL ELSE SHIPEXPIREDATE END AS SHIPDATE
			, CASE WHEN CANCELREASONCODE = 'IN' THEN UDF_ARRIVAL_DATE ELSE NULL END AS ARRIVALDATE
			, CASE WHEN CANCELREASONCODE = 'MO' THEN 'MO'
				   WHEN CANCELREASONCODE = 'BO' OR CANCELREASONCODE = 'IN' THEN 'BO'
				   WHEN ExtensionAmt = 0 AND NOT MAS_POL.dbo.SO_SalesOrderHeader.Comment like 'B&H HOLD%' AND CANCELREASONCODE IN ('NSQTY', 'NOTE', 'PO','') THEN 'BHS'
				   WHEN ExtensionAmt = 0 AND CANCELREASONCODE IN ('NSQTY', 'APP', 'NOTE', 'CRED','BH') THEN 'BH'
				   ELSE 'S'
				   END AS ORDERTYPE
			, CASE WHEN (MAS_POL.dbo.SO_SALESORDERHEADER.ORDERTYPE = 'S' AND MAS_POL.dbo.SO_SALESORDERHEADER.ORDERSTATUS = 'H') OR
                   MAS_POL.dbo.SO_SALESORDERHEADER.ORDERTYPE = 'B' THEN CANCELREASONCODE
				   ELSE ''
				   END AS HOLDCODE
			, CASE WHEN CANCELREASONCODE = 'BO' THEN dbo.PO_Inventory_ETA.RequiredDate ELSE NULL END AS BOETA
			, QuantityOrdered
			, UnitPrice
			, ExtensionAmt
			, CASE WHEN MAS_POL.dbo.SO_SALESORDERDETAIL.ITEMTYPE = 1
			       THEN UDF_BRAND_NAMES + ' ' + UDF_DESCRIPTION + ' ' + UDF_VINTAGE + ' (' + REPLACE(SalesUnitOfMeasure, 'C', '') + '/'
				   + (CASE WHEN CHARINDEX('ML', UDF_BOTTLE_SIZE) > 0 THEN REPLACE(UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(UDF_BOTTLE_SIZE, ' ', '') END) 
                   + ') ' + UDF_DAMAGED_NOTES ELSE MAS_POL.dbo.SO_SALESORDERDETAIL.ITEMCODEDESC
				   END AS ItemDescription
			, MAS_POL.dbo.SO_SalesOrderDetail.ItemCode
			, CAST(REPLACE(UnitOfMeasure, 'C', '') AS INT) AS UOM
			, CASE WHEN MAS_POL.dbo.SO_INVOICEHEADER.SALESORDERNO IS NULL THEN '' ELSE 'x' END AS Invoiced
			, MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY AS Territory
			, MAS_POL.dbo.SO_SalesOrderHeader.SalespersonNo
			, LineKey
			, MAS_POL.dbo.SO_SalesOrderHeader.Comment
			, CASE WHEN IsNumeric(MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP) = 1 AND CHARINDEX('.', MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP) = 0
				   THEN CAST(MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP AS INT) ELSE NULL 
                   END AS CoopNo
			, CASE WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'N' THEN 'On' WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'F' THEN 'Off' ELSE '' END AS Premise
			, UDF_AFFILIATIONS As Affiliations
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
