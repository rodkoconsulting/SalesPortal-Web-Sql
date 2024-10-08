﻿/****** Object:  View [dbo].[SO_SalesOrders_PricesChanging]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SO_SalesOrders_PricesChanging]
AS
WITH Orders AS (SELECT        h.ShipExpireDate,
								h.SalesOrderNo,
								CASE WHEN h.CancelReasonCode = 'IN' THEN 'BO-IN'
									WHEN h.CancelReasonCode in ('MO','BO') THEN h.CancelReasonCode
									ELSE 'S' END as 'Order Type',
								c.PriceLevel as 'State',
								h.ARDivisionNo,
								h.CustomerNo, d.ItemCode, d.QuantityOrdered, d.UnitPrice, c.PriceLevel
                                     FROM            dbo.SO_SalesOrderHeader AS h INNER JOIN
                                                               dbo.SO_SalesOrderDetail AS d ON h.SalesOrderNo = d.SalesOrderNo INNER JOIN
                                                               dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo
                                     WHERE        (d.QuantityOrdered > 0) AND (d.UnitPrice > 0) AND (h.WarehouseCodeHeader <> '002') AND (MONTH(h.ShipExpireDate) <> MONTH(GETDATE())) OR
                                                               (d.QuantityOrdered > 0) AND (d.UnitPrice > 0) AND (h.WarehouseCodeHeader <> '002') AND (h.CancelReasonCode = 'BO'))
,Pricing as
(
    SELECT        o.SalesOrderNo, o.[Order Type], o.State, CONCAT(o.ARDivisionNo,'-',o.CustomerNo) AS CustomerNo, o.ItemCode, o.QuantityOrdered, o.UnitPrice, p.Pricing as NewPricing, t.QuantityTotal,
                              CASE WHEN o.QuantityOrdered <= p.BreakQuantity1 THEN p.DiscountMarkup1 WHEN o.QuantityOrdered <= p.BreakQuantity2 THEN p.DiscountMarkup2 WHEN o.QuantityOrdered <= p.BreakQuantity3 THEN p.DiscountMarkup3
                               WHEN o.QuantityOrdered <= p.BreakQuantity4 THEN p.DiscountMarkup4 WHEN o.QuantityOrdered <= p.BreakQuantity5 THEN p.DiscountMarkup5 ELSE 0 END AS NewUnitPrice
     FROM            Orders AS o INNER JOIN
                              dbo.IM_PriceCode_Change_NextMonth AS p ON o.PriceLevel = p.CustomerPriceLevel AND o.ItemCode = p.ItemCode INNER JOIN
							  dbo.SO_SalesOrderTotals t ON o.SalesOrderNo = t.SalesOrderNo
 )
 Select p.SalesOrderNo, p.[Order Type], p.State, p.CustomerNo, p.ItemCode, p.QuantityOrdered, p.UnitPrice, p.NewPricing, p.QuantityTotal, p.NewUnitPrice
 from Pricing p
 --where p.[Order Type] = 'S' or (p.[Order Type] != 'S' and p.NewUnitPrice != p.UnitPrice)
 where p.NewUnitPrice != p.UnitPrice

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
         Begin Table = "o"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 254
               Bottom = 136
               Right = 448
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SO_SalesOrders_PricesChanging'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SO_SalesOrders_PricesChanging'
