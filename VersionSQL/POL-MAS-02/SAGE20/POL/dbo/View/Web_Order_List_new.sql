/****** Object:  View [dbo].[Web_Order_List_new]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Order_List_new]
AS
SELECT *
 
FROM
 
(
 
  SELECT SALESORDERNO As 'SalesOrderNo', BILLTONAME AS 'CustomerName',ORDERDATE as 'OrderDate',EXPDATE as 'ExpDate',SHIPDATE as 'ShipDate',ARRIVALDATE as 'ArrivalDate',ORDERTYPE AS 'OrderType',HOLDCODE AS 'HoldCode',BOETA AS 'BackOrderETA',QUANTITYORDERED AS 'QtyOrdered',UNITPRICE AS 'UnitPrice',EXTENSIONAMT AS 'ExtensionAmount',ItemDescription as 'ItemDescription',ITEMCODE as 'ItemCode',UOM,Invoiced,Territory,SALESPERSONNO AS 'SalesPerson',LINEKEY as 'LINEKEY',COMMENT as 'COMMENT','1' as 'HeaderKey',Premise,CoopNo,Affiliations

  FROM dbo.Web_SalesOrders
  
  where (ORDERTYPE='S' or ORDERTYPE='BH') and HOLDCODE<>'MO'
 
  UNION ALL

  SELECT INVOICENO As 'SalesOrderNo', BILLTONAME AS 'CustomerName',OrderDate as 'OrderDate',Null as 'ExpDate',SHIPDATE as 'ShipDate',Null as 'ArrivalDate',INVOICETYPE As 'OrderType','' AS 'HoldCode',null AS 'BackOrderETA',QuantityOrdered AS 'QtyOrdered',UnitPrice as 'UnitPrice',ExtensionAmt as 'ExtensionAmount',ItemDescription as 'ItemDescription',ItemCode as 'ItemCode',UOM,'x' as 'Invoiced',Territory,SALESPERSONNO AS 'SalesPerson',LineKey AS 'LINEKEY',Comment as 'COMMENT','1' as 'HeaderKey',Premise,CoopNo,Affiliations

  FROM dbo.Web_Order_List_Batch

  where SHIPDATE >= GETDATE()
 
) tmp
