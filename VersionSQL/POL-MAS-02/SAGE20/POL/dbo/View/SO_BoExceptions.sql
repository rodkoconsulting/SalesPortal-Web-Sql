/****** Object:  View [dbo].[SO_BoExceptions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SO_BoExceptions]
AS
WITH d as (
SELECT      DISTINCT  sh.SalesOrderNo
			, sd.ItemCode
			, ph.UDF_CONTAINER_NUM as 'Container #'
FROM            MAS_POL.dbo.SO_SalesOrderHeader sh INNER JOIN
                         MAS_POL.dbo.SO_SalesOrderDetail sd ON sh.SalesOrderNo = sd.SalesOrderNo LEFT OUTER JOIN
                         MAS_POL.dbo.PO_PurchaseOrderDetail pd ON sd.ItemCode = pd.ItemCode LEFT OUTER JOIN
                         MAS_POL.dbo.PO_PurchaseOrderHeader ph ON pd.PurchaseOrderNo = ph.PurchaseOrderNo
WHERE	  sh.CancelReasonCode = 'BO'
	 and  ph.OrderStatus = 'O'
	 and ph.UDF_CONTAINER_NUM <> '' 
),
s as (
SELECT        sh.SalesOrderNo
			, COUNT(DISTINCT(ph.UDF_CONTAINER_NUM)) as 'Container Count'
FROM            MAS_POL.dbo.SO_SalesOrderHeader sh INNER JOIN
                         MAS_POL.dbo.SO_SalesOrderDetail sd ON sh.SalesOrderNo = sd.SalesOrderNo LEFT OUTER JOIN
                         MAS_POL.dbo.PO_PurchaseOrderDetail pd ON sd.ItemCode = pd.ItemCode LEFT OUTER JOIN
                         MAS_POL.dbo.PO_PurchaseOrderHeader ph ON pd.PurchaseOrderNo = ph.PurchaseOrderNo
WHERE	  sh.CancelReasonCode = 'BO'
	 and  ph.OrderStatus = 'O'
	 and ph.UDF_CONTAINER_NUM <> '' 
GROUP BY sh.SalesOrderNo
HAVING COUNT(DISTINCT(ph.UDF_CONTAINER_NUM)) > 1
)
SELECT d.SalesOrderNo, d.ItemCode, STUFF((SELECT ',' + [Container #]
	FROM d [d2]
	WHERE d2.SalesOrderNo = d.SalesOrderNo AND d2.ItemCode = d.ItemCode
	FOR XML PATH('')), 1, 1,'') as Containers
FROM d INNER JOIN
	s ON  d.SalesOrderNo = s.SalesOrderNo

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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SO_BoExceptions'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SO_BoExceptions'
