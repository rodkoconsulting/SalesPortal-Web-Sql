/****** Object:  View [dbo].[SO_ShipToAddress_Multiple]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SO_ShipToAddress_Multiple]
AS
WITH SHIP_TO AS (SELECT        c.ARDivisionNo, c.CustomerNo, COUNT(s.ShipToCode) AS QtyShipTo
                                          FROM            MAS_POL.dbo.SO_ShipToAddress AS s INNER JOIN
                                                                   MAS_POL.dbo.AR_Customer AS c ON s.ARDivisionNo = c.ARDivisionNo AND s.CustomerNo = c.CustomerNo
                                          WHERE        (c.ARDivisionNo = '00') AND (c.SalespersonNo NOT LIKE 'XX%') AND (c.CustomerNo NOT LIKE 'ZZ%') AND (c.UDF_CUST_ACTIVE_STAT = 'Y') AND (s.UDF_INACTIVE <> 'Y')
                                          GROUP BY c.ARDivisionNo, c.CustomerNo
                                          HAVING         (COUNT(s.ShipToCode) > 1))
    SELECT        s.ARDivisionNo, s.CustomerNo, s.ShipToCode, CASE WHEN c.PrimaryShipToCode = s.ShipToCode THEN 'x' ELSE '' END AS PrimaryShipTo, s.ShipToName, s.UDF_REGION AS 'Region', 
                              CASE WHEN s.UDF_DELIVERY_MON = 'Y' THEN 'x' ELSE '' END AS 'Monday', CASE WHEN s.UDF_DELIVERY_TUES = 'Y' THEN 'x' ELSE '' END AS 'Tuesday', 
                              CASE WHEN s.UDF_DELIVERY_WED = 'Y' THEN 'x' ELSE '' END AS 'Wednesday', CASE WHEN s.UDF_DELIVERY_THURS = 'Y' THEN 'x' ELSE '' END AS 'Thursday', 
                              CASE WHEN s.UDF_DELIVERY_THURS = 'Y' THEN 'x' ELSE '' END AS 'Friday'
     FROM            MAS_POL.dbo.SO_ShipToAddress AS s INNER JOIN
                              SHIP_TO AS s1 ON s.ARDivisionNo = s1.ARDivisionNo AND s.CustomerNo = s1.CustomerNo INNER JOIN
                              MAS_POL.dbo.AR_Customer AS c ON s.ARDivisionNo = c.ARDivisionNo AND s.CustomerNo = c.CustomerNo
     WHERE        (s.UDF_INACTIVE <> 'Y')


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
         Begin Table = "SO_ShipToAddress (MAS_POL.dbo)"
            Begin Extent = 
               Top = 7
               Left = 104
               Bottom = 241
               Right = 411
            End
            DisplayFlags = 280
            TopColumn = 23
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SO_ShipToAddress_Multiple'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SO_ShipToAddress_Multiple'
