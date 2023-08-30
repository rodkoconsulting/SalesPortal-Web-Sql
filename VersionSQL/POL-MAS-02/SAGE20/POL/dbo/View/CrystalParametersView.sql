﻿/****** Object:  View [dbo].[CrystalParametersView]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[CrystalParametersView]
AS
SELECT     distinct dbo.CrystalParameters.ReportName, dbo.CrystalParameters.ParameterName, dbo.CrystalParameters.ParameterField, 
                      dbo.CrystalParameters.ParameterTable, dbo.CrystalParameters.ParameterAll, MAS_POL.dbo.SY_ReportSetting.ReportID
FROM         dbo.CrystalParameters INNER JOIN
                      MAS_POL.dbo.SY_ReportSetting ON dbo.CrystalParameters.ReportName = MAS_POL.dbo.SY_ReportSetting.Description
where MAS_POL.dbo.SY_ReportSetting.ReportID like '%.RPT'
