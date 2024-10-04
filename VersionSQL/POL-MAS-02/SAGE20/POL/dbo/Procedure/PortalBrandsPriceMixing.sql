/****** Object:  Procedure [dbo].[PortalBrandsPriceMixing]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalBrandsPriceMixing]
AS
BEGIN
		SELECT UDF_BRAND_NAME as [Brand]
		FROM [MAS_POL].[dbo].[CI_UDT_BRANDS]
		WHERE UDF_BRAND_MIXING = 'Y'
END
