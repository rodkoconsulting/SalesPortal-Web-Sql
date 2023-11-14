/****** Object:  Procedure [dbo].[PortalWebSampleOrderCutOff]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebSampleOrderCutOff]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT ISNULL(REPLACE([CutOffTimeSamples],NCHAR(0x00A0),' '),'1:00 pm') AS CutOff
  FROM [dbo].[Web_MasFlags]
WHERE     (ID = 1) 

END
