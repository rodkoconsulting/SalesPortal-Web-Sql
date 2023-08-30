/****** Object:  View [dbo].[IncentivesTally]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IncentivesTally]
AS
WITH placement AS
(SELECT        Trim(UPPER(i.UDF_BRAND_NAMES + REPLACE(' ' + TRIM(SUBSTRING(UDF_DESCRIPTION,1,CASE WHEN CHARINDEX('[',UDF_DESCRIPTION) > 0 THEN CHARINDEX('[',UDF_DESCRIPTION)-1 ELSE LEN(UDF_DESCRIPTION) END)), ' ,', ',') + ' ' + (CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN REPLACE(i.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(i.UDF_BOTTLE_SIZE,' ','') END))) AS Description, i.UDF_COUNTRY as Country, h.ARDivisionNo, h.CustomerNo, h.TransactionDate, c.SalespersonNo
                                FROM            dbo.AR_INVOICEHISTORYHEADER_2YR AS h INNER JOIN
                                                         dbo.AR_InvoiceHistoryDetail AS d ON h.InvoiceNo = d.InvoiceNo AND h.HeaderSeqNo = d.HeaderSeqNo INNER JOIN
                                                         dbo.CI_Item AS i ON d.ItemCode = i.ItemCode INNER JOIN
														 dbo.AR_Customer c ON h.CustomerNo = c.CustomerNo and h.ARDivisionNo = c.ARDivisionNo
                                WHERE        (i.ItemType = '1') AND (d.UnitPrice > 0) and h.TransactionDate >= '1/1/22' and c.SalespersonNo in ('CG01','DM01','CR01','JS02','MH01','RS01','JM02','JR04','CO01','RT02','CH01')
                                GROUP BY i.UDF_BRAND_NAMES, i.UDF_DESCRIPTION, i.UDF_BOTTLE_SIZE, i.UDF_COUNTRY, h.ARDivisionNo, h.CustomerNo, h.TransactionDate, c.SalespersonNo
                                HAVING         (SUM(d.QuantityShipped) >= 1)
),
previous AS
(SELECT       Trim(UPPER(i.UDF_BRAND_NAMES + REPLACE(' ' + TRIM(SUBSTRING(UDF_DESCRIPTION,1,CASE WHEN CHARINDEX('[',UDF_DESCRIPTION) > 0 THEN CHARINDEX('[',UDF_DESCRIPTION)-1 ELSE LEN(UDF_DESCRIPTION) END)), ' ,', ',') + ' ' + (CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN REPLACE(i.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(i.UDF_BOTTLE_SIZE,' ','') END))) AS Description, h.ARDivisionNo, h.CustomerNo, h.TransactionDate
                                FROM            dbo.AR_INVOICEHISTORYHEADER_2YR AS h INNER JOIN
                                                         dbo.AR_InvoiceHistoryDetail AS d ON h.InvoiceNo = d.InvoiceNo AND h.HeaderSeqNo = d.HeaderSeqNo INNER JOIN
                                                         dbo.CI_Item AS i ON d.ItemCode = i.ItemCode INNER JOIN
														 dbo.AR_Customer c ON h.CustomerNo = c.CustomerNo and h.ARDivisionNo = c.ARDivisionNo
                                WHERE        (i.ItemType = '1') AND (d.UnitPrice > 0) and h.TransactionDate >= '10/1/21' and h.TransactionDate < '1/1/22' and c.SalespersonNo in ('CG01','DM01','CR01','JS02','MH01','RS01','JM02','JR04','CO01','RT02','CH01')
                                GROUP BY i.UDF_BRAND_NAMES, i.UDF_DESCRIPTION, i.UDF_BOTTLE_SIZE, h.ARDivisionNo, h.CustomerNo, h.TransactionDate
								HAVING SUM(d.QuantityShipped) > 0
)
SELECT DISTINCT inc.Description
, p.Country
, SUM(CASE WHEN p.SalespersonNo = 'CG01' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'CG01'
, SUM(CASE WHEN p.SalespersonNo = 'DM01' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'DM01'
, SUM(CASE WHEN p.SalespersonNo = 'CR01' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'CR01'
, SUM(CASE WHEN p.SalespersonNo = 'JS02' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'JS02'
, SUM(CASE WHEN p.SalespersonNo = 'MH01' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'MH01'
, SUM(CASE WHEN p.SalespersonNo = 'RS01' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'RS01'
, SUM(CASE WHEN p.SalespersonNo = 'JM02' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'JM02'
, SUM(CASE WHEN p.SalespersonNo = 'JR04' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'JR04'
, SUM(CASE WHEN p.SalespersonNo = 'CH01' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'CH01'
, SUM(CASE WHEN p.SalespersonNo = 'CO01' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'CO01'
, SUM(CASE WHEN p.SalespersonNo = 'RT02' AND pr.Description IS NULL THEN 1 ELSE 0 END) AS 'RT02'
FROM dbo.Incentives inc 
LEFT OUTER JOIN placement p
ON inc.Description = p.Description
LEFT OUTER JOIN previous pr
ON p.Description = pr.Description and p.ARDivisionNo = pr.ARDivisionNo and p.CustomerNo = pr.CustomerNo
GROUP by inc.Description, p.Country


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
         Begin Table = "tally_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'IncentivesTally'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'IncentivesTally'
