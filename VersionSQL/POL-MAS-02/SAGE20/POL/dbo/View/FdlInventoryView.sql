/****** Object:  View [dbo].[FdlInventoryView]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[FdlInventoryView]
AS
SELECT        ItemCode, ISNULL(TRY_CONVERT(float, replace(Quantity,',','')),0) AS Quantity
FROM            dbo.FDL_INV
