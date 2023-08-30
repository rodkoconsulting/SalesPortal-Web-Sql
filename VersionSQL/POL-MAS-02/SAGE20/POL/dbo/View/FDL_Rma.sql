/****** Object:  View [dbo].[FDL_Rma]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[FDL_Rma]
AS
SELECT      'pickup' as OrderType
			, h.RMANo
			, h.RMADate
			, 'DOUPOL' AS FdlCustNo
			, 'DP' + h.CustomerNo + 'L' + h.ShipToCode AS Id
			, h.ShipToName AS 'Name'
			, CASE WHEN len(h.ShipToAddress3) > 0 THEN h.ShipToAddress1 + ', ' + h.ShipToAddress2 + ', ' + h.ShipToAddress3
					WHEN len(h.ShipToAddress2) > 0 THEN h.ShipToAddress1 + ', ' + h.ShipToAddress2
					ELSE h.ShipToAddress1 END AS 'Address'
			, h.ShipToCity AS City
			, h.ShipToState AS [State]
			, h.ShipToZipCode AS Zip
			, h.EmailAddress AS Email
			, h.Comment
			, ROUND(SUM(d.QuantityReturned),4) AS Quantity
			, ROUND(SUM((CASE WHEN LEN(i.ShipWeight) > 0 THEN i.ShipWeight ELSE 36 END) * d.QuantityReturned),2) as Weight
FROM            MAS_POL.dbo.RA_ReturnHeader AS h INNER JOIN
                         MAS_POL.dbo.RA_ReturnDetail AS d ON h.RMANo = d.RMANo INNER JOIN
						 MAS_POL.dbo.CI_Item AS i on d.ItemCode = i.ItemCode
WHERE h.ReturnShipVia = 'FDL'
GROUP BY h.RMANo, h.RMADate, h.CustomerNo, h.ShipToName, h.ShipToAddress1, h.ShipToAddress2, h.ShipToAddress3, h.ShipToCity, h.ShipToState, h.ShipToZipCode, h.ShipToCode, h.EmailAddress, h.Comment

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
               Top = 6
               Left = 38
               Bottom = 136
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 313
               Bottom = 136
               Right = 579
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FDL_Rma'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FDL_Rma'
