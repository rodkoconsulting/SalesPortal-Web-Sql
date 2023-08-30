/****** Object:  View [dbo].[PO_Shipping]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_Shipping]
AS
SELECT 
				 IsNull(c.CountryName,'') as Country
				 , h.UDF_CONTAINER_NUM AS [ContainerNo]
				 , CASE WHEN h.UDF_SHIPMENT_NUM = '' THEN 'Unassigned' ELSE h.UDF_SHIPMENT_NUM END AS [ShipmentNo]
				 , s.ShippingCodeDesc AS [ShipVia]
				 , h.UDF_FOREIGN_ENTRY AS [CustomsEntryNo]
				 , IsNull(h.UDF_PORT,'') as Port
				 , h.PurchaseOrderNo AS [PoNo]
				 , h.PurchaseOrderDate 
				 , CASE WHEN YEAR(h.RequiredExpireDate) < 2000 THEN NULL ELSE h.RequiredExpireDate END as Available
				 , h.UDF_AVAILABLE_COMMENT as [AvailableComment]
				 , h.UDF_STATUS as [ReadyDate]
				 , h.UDF_ETD AS ETD
				 , h.UDF_ETA AS ETA
				 , v.VendorName AS Vendor
				 , t.TermsCodeDesc AS Terms
				 , d.ItemCode AS [ItemCode]
				 , i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUnitOfMeasure, 'C', '') 
                         + '/' + (CASE WHEN CHARINDEX('ML', i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(i.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) + ') '
						  + i.UDF_DAMAGED_NOTES AS [ItemDescription]
				, d.QuantityOrdered as Cases
				, i.Volume * d.QuantityOrdered as Liters
				, i.StandardUnitCost as UnitCost
				, d.ExtensionAmt as Total
				, v.UDF_TTBFPID as TTB_FPID
				, v.UDF_TTB_MANUFACTURER as TTB_Manufacturer
				, CASE WHEN v.UDF_ASSIGNED = 'Y' THEN 'x' ELSE '' END as TTB_Assigned
FROM            MAS_POL.dbo.PO_PurchaseOrderHeader AS h INNER JOIN
                         MAS_POL.dbo.SO_ShippingRateHeader AS s ON h.ShipVia = s.ShippingCode INNER JOIN
                         MAS_POL.dbo.AP_Vendor AS v ON h.APDivisionNo = v.APDivisionNo AND h.VendorNo = v.VendorNo INNER JOIN
						 MAS_POL.dbo.AP_TermsCode AS t ON h.TermsCode = t.TermsCode INNER JOIN
                         MAS_POL.dbo.PO_PurchaseOrderDetail AS d ON h.PurchaseOrderNo = d.PurchaseOrderNo INNER JOIN
                         MAS_POL.dbo.CI_Item AS i ON d.ItemCode = i.ItemCode LEFT OUTER JOIN
                         MAS_POL.dbo.SY_Country c ON v.CountryCode = c.CountryCode
WHERE        (h.OrderStatus = 'O') AND (i.ItemType = '1')


EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[77] 4[10] 2[6] 3) )"
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
               Top = 248
               Left = 44
               Bottom = 578
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 441
               Left = 863
               Bottom = 571
               Right = 1092
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v"
            Begin Extent = 
               Top = 220
               Left = 730
               Bottom = 389
               Right = 978
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 29
               Left = 323
               Bottom = 159
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 0
               Left = 659
               Bottom = 130
               Right = 920
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SY_Country (MAS_POL.dbo)"
            Begin Extent = 
               Top = 253
               Left = 1119
               Bottom = 383
               Right = 1327
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
 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PO_Shipping'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'        Table = 1170
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PO_Shipping'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PO_Shipping'
