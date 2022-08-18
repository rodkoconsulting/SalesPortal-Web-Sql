﻿/****** Object:  View [dbo].[ODataInvoices]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[ODataInvoices]
AS
WITH InvHist AS
(SELECT       h.InvoiceNo, h.HeaderSeqNo, InvoiceType, InvoiceDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP, ItemCode, ItemCodeDesc, QuantityShipped, UnitPrice, ExtensionAmt
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
				MAS_POL.dbo.AR_InvoiceHistoryDetail d on h.InvoiceNo = d.InvoiceNo and h.HeaderSeqNo = d.HeaderSeqNo
WHERE ModuleCode = 'S/O' and InvoiceDate >= DATEADD(YEAR, - 2, GETDATE()) and ItemCode != '/C'
UNION ALL
SELECT        h.InvoiceNo, h.InvoiceNo, InvoiceType, ShipDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP, ItemCode, ItemCodeDesc, QuantityShipped, UnitPrice, ExtensionAmt
FROM            MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN
				MAS_POL.dbo.SO_InvoiceDetail d on h.InvoiceNo = d.InvoiceNo
WHERE ItemCode != '/C'
)
Select 
h.InvoiceNo as 'InvNo'
, CASE WHEN h.InvoiceType = 'CM' THEN 'C' ELSE 'I' END AS Typ
, h.ItemCode as 'Item'
, c.CustomerName AS 'Acct'
, c.UDF_AFFILIATIONS AS 'Aff'
, CASE WHEN i.UDF_BRAND_NAMES = '' THEN h.ItemCodeDesc ELSE i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUNITOFMEASURE, 'C', '') 
                         + '/' + (CASE WHEN CHARINDEX('ML', i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(i.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) + ')' + i.UDF_DAMAGED_NOTES END AS 'Desc'
, h.InvoiceDate AS Date
, h.QuantityShipped AS Qty
, h.UnitPrice AS Pri
, h.ExtensionAmt AS Tot
, h.Comment as Cmt
, h.UDF_NJ_COOP AS Coop
, c.SalespersonNo AS AcctR
, h.SalespersonNo AS InvR
, i.UDF_WINE_COLOR AS ITyp
, IsNull(v.UDF_VARIETAL,'') AS Vari
, i.UDF_COUNTRY AS Ctry
, IsNull(r.UDF_REGION,'') AS Reg
, IsNull(ap.UDF_NAME,'') AS App
, i.UDF_MASTER_VENDOR AS Mv
, CASE WHEN SUBSTRING(c.CUSTOMERTYPE, 3, 2) = 'ON' THEN 'On' ELSE 'Off' END AS Prem
			, CASE WHEN i.UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END AS Foc
			, CASE WHEN i.UDF_BM_FOCUS = 'Y' THEN 'Y' ELSE '' END AS FocBm
			,  CASE WHEN s.UDF_TERRITORY = 'NY Metro' THEN 'NYM' WHEN UDF_TERRITORY = 'NY Long Island' THEN 'NYLI' WHEN UDF_TERRITORY = 'NY Upstate' THEN 'NYU' WHEN UDF_TERRITORY = 'NY Westchester / Hudson' THEN
                          'NYW' WHEN UDF_TERRITORY = 'NJ' THEN 'NJ' WHEN UDF_TERRITORY = 'Pennsylvania' THEN 'PA' ELSE 'Manager' END AS Ter
FROM InvHist h INNER JOIN
    MAS_POL.dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo INNER JOIN
    MAS_POL.dbo.CI_Item AS i ON i.ItemCode = h.ItemCode LEFT OUTER JOIN
    MAS_POL.dbo.CI_UDT_VARIETALS AS v ON i.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
    MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
    MAS_POL.dbo.CI_UDT_APPELLATION AS ap ON i.UDF_SUBREGION_T = ap.UDF_APPELLATION INNER JOIN
    MAS_POL.dbo.SO_ShipToAddress AS a ON c.ARDivisionNo = a.ARDivisionNo AND c.CustomerNo = a.CustomerNo AND c.PrimaryShipToCode = a.ShipToCode INNER JOIN
    MAS_POL.dbo.AR_UDT_SHIPPING AS s ON a.UDF_REGION_CODE = s.UDF_REGION_CODE

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ODataInvoices'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ODataInvoices'
