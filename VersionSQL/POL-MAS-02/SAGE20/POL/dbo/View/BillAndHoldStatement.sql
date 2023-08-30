/****** Object:  View [dbo].[BillAndHoldStatement]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[BillAndHoldStatement]
AS
SELECT  
a.ARDivisionNo      
, a.CustomerNo
, a.CustomerName
, a.UDF_LICENSE_NUM
, a.UDF_CORP_NAME
, a.AddressLine1
, a.AddressLine2
, a.AddressLine3
, a.City
, a.State
, a.ZipCode
, c.EmailAddress
, h.SalesOrderNo
, h.OrderDate
, h.ShipExpireDate
, d.ItemCode
, CEILING(d.QuantityOrdered) AS QuantityOrdered
FROM            MAS_POL.dbo.SO_SalesOrderHeader AS h INNER JOIN
                         MAS_POL.dbo.SO_SalesOrderDetail AS d ON h.SalesOrderNo = d.SalesOrderNo INNER JOIN
                         MAS_POL.dbo.AR_Customer AS a ON h.ARDivisionNo = a.ARDivisionNo AND h.CustomerNo = a.CustomerNo LEFT OUTER JOIN
						 MAS_POL.dbo.AR_CustomerContact c on a.ContactCode = c.ContactCode and a.ARDivisionNo = c.ARDivisionNo and a.CustomerNo = c.CustomerNo
WHERE        (h.CancelReasonCode = 'BH') AND (d.QuantityOrdered > 0)

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
         Begin Table = "h"
            Begin Extent = 
               Top = 64
               Left = 73
               Bottom = 312
               Right = 346
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 46
               Left = 861
               Bottom = 275
               Right = 1095
            End
            DisplayFlags = 280
            TopColumn = 46
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 219
               Left = 451
               Bottom = 349
               Right = 746
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'BillAndHoldStatement'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'BillAndHoldStatement'
