/****** Object:  Procedure [dbo].[PortalWebAccountOrderCutOff]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountOrderCutOff]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT ISNULL(REPLACE([CutOffTime],NCHAR(0x00A0),' '),'4:10 pm') AS CutOff
  FROM [dbo].[Web_MasFlags]
WHERE     (ID = 1) 

END
