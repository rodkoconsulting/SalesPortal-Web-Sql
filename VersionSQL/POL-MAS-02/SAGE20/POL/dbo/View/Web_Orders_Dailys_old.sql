/****** Object:  View [dbo].[Web_Orders_Dailys_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Orders_Dailys_old]
AS
SELECT *
 
FROM
 
(
 
  SELECT SALESORDERNO As 'SalesOrderNo', BILLTONAME AS 'CustomerName',ORDERDATE as 'OrderDate',EXPDATE as 'ExpDate',SHIPDATE as 'ShipDate',ARRIVALDATE as 'ArrivalDate',ORDERTYPE AS 'OrderType',HOLDCODE AS 'HoldCode',BOETA AS 'BackOrderETA',QUANTITYORDERED AS 'QtyOrdered',UNITPRICE AS 'UnitPrice',EXTENSIONAMT AS 'ExtensionAmount',ItemDescription as 'ItemDescription',ITEMCODE as 'ItemCode',UOM,Invoiced,Territory,SALESPERSONNO AS 'SalesPerson',LINEKEY as 'LINEKEY',COMMENT as 'COMMENT','1' as 'HeaderKey',Premise,CoopNo,Affiliations

  FROM dbo.Web_SalesOrders
  
  where ORDERTYPE='S' or ORDERTYPE='BHS'
 
  UNION ALL
 
  SELECT INVOICENO As 'SalesOrderNo', Customer AS 'CustomerName',Null as 'OrderDate',Null as 'ExpDate',TRANSACTIONDATE as 'ShipDate',Null as 'ArrivalDate',INVOICETYPE As 'OrderType','' AS 'HoldCode',null AS 'BackOrderETA',QUANTITYSHIPPED AS 'QtyOrdered',Price as 'UnitPrice',Total as 'ExtensionAmount',ItemDescription as 'ItemDescription',ItemCode as 'ItemCode',UOM,'x' as 'Invoiced',Territory,SALESPERSONNO AS 'SalesPerson',DETAILSEQNO AS 'LINEKEY',Comment as 'COMMENT',HEADERSEQNO as 'HeaderKey',Premise,CoopNo,Affiliations

  FROM dbo.Web_Orders_InvoiceList
  
  where TRANSACTIONDATE >= GETDATE()

  UNION ALL

  SELECT INVOICENO As 'SalesOrderNo', BILLTONAME AS 'CustomerName',OrderDate as 'OrderDate',Null as 'ExpDate',SHIPDATE as 'ShipDate',Null as 'ArrivalDate',INVOICETYPE As 'OrderType','' AS 'HoldCode',null AS 'BackOrderETA',QuantityOrdered AS 'QtyOrdered',UnitPrice as 'UnitPrice',ExtensionAmt as 'ExtensionAmount',ItemDescription as 'ItemDescription',ItemCode as 'ItemCode',UOM,'x' as 'Invoiced',Territory,SALESPERSONNO AS 'SalesPerson',LineKey AS 'LINEKEY',Comment as 'COMMENT','1' as 'HeaderKey',Premise,CoopNo,Affiliations

  FROM dbo.Web_Order_List_Batch

  where SHIPDATE >= GETDATE()
 
) tmp
