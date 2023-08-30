/****** Object:  Procedure [dbo].[ZipCodes-Fdl-Insert]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[ZipCodes-Fdl-Insert]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ZipCodes-Fdl]
SELECT         F2 as 'ZipCode - Fdl'
				, Replace(dbo.PROPERCASE(F3),',','') as City
				, CASE WHEN CHARINDEX('MON', F4) > 0 OR CHARINDEX('DNT', F4) > 0 THEN 'Y' ELSE 'N' END as [Ship-Monday]
				, CASE WHEN CHARINDEX('TUE', F4) > 0 OR CHARINDEX('DNT', F4) > 0 THEN 'Y' ELSE 'N' END as [Ship-Tuesday]
				, CASE WHEN CHARINDEX('WED', F4) > 0 THEN 'Y' ELSE 'N' END as [Ship-Wednesday]
				, CASE WHEN CHARINDEX('THU', F4) > 0 OR CHARINDEX('DNT', F4) > 0 THEN 'Y' ELSE 'N' END as [Ship-Thursday]
				, CASE WHEN CHARINDEX('FRI', F4) > 0 OR CHARINDEX('DNT', F4) > 0 THEN 'Y' ELSE 'N' END as [Ship-Friday]
				, CASE WHEN CHARINDEX('JERSEY', F1) > 0 THEN 'NJ'
					WHEN CHARINDEX('NEW YORK', F1) > 0 OR CHARINDEX('BROOKLYN', F1) > 0 OR CHARINDEX('MANHATTAN', F1) > 0 THEN 'NY Metro'
					WHEN CHARINDEX('HUDSON', F1) > 0 THEN 'NY Upstate'
					WHEN CHARINDEX('HAMPTONS', F1) > 0 OR CHARINDEX('LONG ISLAND', F1) > 0 THEN 'NY Long Island'
					WHEN CHARINDEX('WESTCHESTER', F1) > 0 THEN 'NY Westchester / Hudson' END as Territory
				, CASE WHEN CHARINDEX('DNT', F4) > 0 THEN 'DNT' ELSE 'FDL' END as ShipVia
				, '' as County
				, F1 as [FDL Route]


FROM            [dbo].[ZipCodes-Fdl-Raw]
END
