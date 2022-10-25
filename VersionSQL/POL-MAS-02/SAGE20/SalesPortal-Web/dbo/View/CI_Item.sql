/****** Object:  View [dbo].[CI_Item]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[CI_Item]
AS
SELECT     ItemCode,
		   ItemType,
		   Category1,
		   Category2,
		   Category3,
		   Category4,
		   SalesUnitOfMeasure,
		   PrimaryAPDivisionNo,
		   PrimaryVendorNo,
		   ProductLine,
		   Valuation,
		   CommissionRate,
		   StandardUnitCost,
		   AverageUnitCost,
		   InactiveItem,
		   ExtendedDescriptionKey,
		   Volume,
		   UDF_ALCOHOL_PCT,
		   UDF_MASTER_VENDOR,
		   UDF_VINTAGE,
		   UDF_WINE_COLOR,
		   UDF_UPC_CODE,
		   UDF_COUNTRY,
		   UDF_BOTTLE_SIZE,
		   UDF_VARIETALS_T,
		   UDF_SUBREGION_T,
		   UDF_BRAND,
		   UDF_REGION,
		   UDF_PARKER,
		   UDF_SPECTATOR,
		   UDF_TANZER,
		   UDF_BURGHOUND,
		   UDF_GALLONI_SCORE,
		   UDF_CLOSURE,
		   UDF_VFC,
		   UDF_PARKER_REVIEW,
		   UDF_SPECTATOR_REVIEW,
		   UDF_TANZER_REVIEW,
		   UDF_BURGHOUND_REVIEW,
		   UDF_GALLONI_REVIEW,
		   UDF_VIEW_REVIEW,
		   UDF_BIODYNAMIC,
		   UDF_ORGANIC,
		   UDF_RESTRICT_OFFSALE,
		   UDF_RESTRICT_OFFSALE_NOTES,
		   UDF_RESTRICT_STATE,
		   UDF_RESTRICT_ALLOCATED,
		   UDF_RESTRICT_MANAGER,
		   UDF_RESTRICT_NORETAIL,
		   UDF_RESTRICT_MAX,
		   UDF_RESTRICT_SAMPLES,
		   UDF_RESTRICT_MO,
		   UDF_RESTRICT_BO,
		   UDF_ALLOCATION,
		   UDF_DESCRIPTION,
		   UDF_SAMPLE_FOCUS,
		   UDF_DAMAGED_NOTES,
		   UDF_BRAND_NAMES,
		   UDF_NOTES_TASTING,
		   UDF_NOTES_VINEYARD,
		   UDF_NOTES_VINIFICATION,
		   UDF_NOTES_VARIETAL,
		   UDF_NOTES_PRODUCTION,
		   UDF_NOTES_AGING,
		   UDF_NOTES_ALTITUDE,
		   UDF_NOTES_ORIENTATION,
		   UDF_NOTES_SOIL,
		   UDF_PA_ITEMCODE,
		   UDF_MANAGER_GROUP
FROM         MAS_POL.dbo.CI_Item


















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
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 282
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'CI_Item'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'CI_Item'
