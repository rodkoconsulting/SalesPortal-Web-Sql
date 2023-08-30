/****** Object:  View [dbo].[Web_Account_Items]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Account_Items]
AS
WITH LASTORDERED AS
(
SELECT     ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ARDIVISIONNO, MAS_POL.dbo.AR_INVOICEHISTORYHEADER.CUSTOMERNO,MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMCODE ORDER BY MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE desc, dbo.IM_PriceCode_TODAY_MAX.ValidDate_234 desc) AS 'RN'
, MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ARDIVISIONNO, MAS_POL.dbo.AR_INVOICEHISTORYHEADER.CUSTOMERNO, MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMCODE, MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE, 
                      SUM(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.QUANTITYSHIPPED) AS QuantityShipped, MIN(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.UNITPRICE) AS Price, 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMEs + ' ' + MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION + ' ' + MAS_POL.dbo.CI_ITEM.UDF_VINTAGE 
                      + ' (' + REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE, 'C', '') + '/' + (CASE WHEN CHARINDEX('ML', MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE) 
                      > 0 THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END) 
                      + ') ' + MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES AS Description, MAS_POL.dbo.CI_ITEM.UDF_COUNTRY AS 'Country', 
                      dbo.IM_PriceCode_TODAY_MAX.ValidDateDescription_234 AS 'Current Pricing', Round(CASE WHEN ISNULL(dbo.IM_InventoryAvailable.QuantityAvailable,0.00)< 0 THEN 0 ELSE ISNULL(dbo.IM_InventoryAvailable.QuantityAvailable,0.00) end,2) AS 'Available',
                      CAST(CASE WHEN ISNUMERIC(REPLACE(MAS_POL.dbo.CI_ITEM.salesUNITOFMEASURE,'C',''))=1 THEN REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE,'C','') ELSE '1' END AS INT) AS UOM
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo ON 
                      MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode LEFT OUTER JOIN
                      dbo.IM_InventoryAvailable ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE LEFT OUTER JOIN
                      dbo.IM_PriceCode_TODAY_MAX ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_PriceCode_TODAY_MAX.ItemCode AND 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.PriceLevel = dbo.IM_PriceCode_TODAY_MAX.CustomerPriceLevel
WHERE     (MAS_POL.dbo.CI_ITEM.ITEMTYPE = '1') AND (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE >= DATEADD(YEAR, - 2, GETDATE())) AND 
                      (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.MODULECODE = 'S/O') AND (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ARDIVISIONNO = '00' OR MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ARDIVISIONNO = '02')
GROUP BY MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ARDIVISIONNO, MAS_POL.dbo.AR_INVOICEHISTORYHEADER.CUSTOMERNO,MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMCODE, MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE, 
                      MAS_POL.dbo.CI_ITEM.UDF_BRAND_NAMES, MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION, MAS_POL.dbo.CI_ITEM.UDF_VINTAGE, MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE, 
                      MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES, MAS_POL.dbo.CI_ITEM.UDF_COUNTRY, 
                      dbo.IM_PriceCode_TODAY_MAX.ValidDateDescription_234, dbo.IM_InventoryAvailable.QuantityAvailable, dbo.IM_PriceCode_TODAY_MAX.ValidDate_234
HAVING      (SUM(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.QUANTITYSHIPPED) > 0)
)
SELECT ISNULL(ARDIVISIONNO,'') AS ARDIVISIONNO, ISNULL(CUSTOMERNO,'') AS CUSTOMERNO,ISNULL(ITEMCODE,'') AS ITEMCODE,INVOICEDATE, QuantityShipped, Price, [Description], Country, [Current Pricing], Available, UOM
FROM LASTORDERED
WHERE RN = 1
