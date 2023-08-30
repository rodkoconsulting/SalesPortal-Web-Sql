/****** Object:  View [dbo].[Portal_PricingGroups]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Portal_PricingGroups]
AS
SELECT     MAS_POL.dbo.CI_ITEM.ITEMCODE, CASE WHEN CHARINDEX('[', MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) = 0
	THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_VINTAGE + MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + UDF_DESCRIPTION, ' ', '')
	ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_VINTAGE + MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + LEFT(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION, CHARINDEX('[', MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) - 1), ' ', '') END AS PricingGroup
FROM         MAS_POL.dbo.CI_ITEM 
