/****** Object:  View [dbo].[COD_Customer_UpdateView]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[COD_Customer_UpdateView]
AS
SELECT     MAS_POL.dbo.AR_Customer.ARDivisionNo, MAS_POL.dbo.AR_Customer.CustomerNo, dbo.COD_ALL.TermsCode AS TermsCodeNew, 
                      dbo.COD_ALL.CreditHold AS CreditHoldNew, MAS_POL.dbo.AR_Customer.TermsCode, MAS_POL.dbo.AR_Customer.CreditHold, 
                      MAS_POL.dbo.AR_TermsCode.TermsCodeDesc AS TermsCodeDescNew, MAS_POL.dbo.AR_Customer.UDF_TERMS_DESCRIPTION AS TermsCodeDesc
FROM         dbo.COD_ALL INNER JOIN
                      MAS_POL.dbo.AR_Customer ON dbo.COD_ALL.ARDIVISIONNO = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      dbo.COD_ALL.CUSTOMERNO = MAS_POL.dbo.AR_Customer.CustomerNo INNER JOIN
                      MAS_POL.dbo.AR_TermsCode ON dbo.COD_ALL.TermsCode = MAS_POL.dbo.AR_TermsCode.TermsCode
WHERE MAS_POL.dbo.AR_Customer.ARDivisionNo = '00'

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
         Begin Table = "COD_ALL"
            Begin Extent = 
               Top = 1
               Left = 102
               Bottom = 296
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 7
               Left = 399
               Bottom = 303
               Right = 672
            End
            DisplayFlags = 280
            TopColumn = 131
         End
         Begin Table = "AR_TermsCode (MAS_POL.dbo)"
            Begin Extent = 
               Top = 51
               Left = 877
               Bottom = 159
               Right = 1091
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'COD_Customer_UpdateView'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'COD_Customer_UpdateView'
