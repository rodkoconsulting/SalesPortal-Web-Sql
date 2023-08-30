/****** Object:  Procedure [dbo].[Web_Account_MasRevertCutOffTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Web_Account_MasRevertCutOffTime]
	-- Add the parameters for the stored procedure here
	
AS
DECLARE @Time as varchar(8)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SELECT @Time = CutOffTimeDefault FROM [POL].[dbo].[Web_MasFlags] WHERE (ID = 1) 
UPDATE [POL].[dbo].[Web_MasFlags]
	Set CutOffTime=@Time
	WHERE (ID = 1) 
