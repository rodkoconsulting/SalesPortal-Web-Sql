/****** Object:  View [dbo].[IM_OversoldItems]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_OversoldItems]
AS
SELECT    [Item Number], [Amount Oversold]
		FROM        IM_OversoldItems_Base
WHERE [Amount Oversold] > 0.04
