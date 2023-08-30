/****** Object:  Procedure [dbo].[ZipCodes-Combined-Insert-Fdl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ZipCodes-Combined-Insert-Fdl]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ZipCodes-Combined]
SELECT         *
FROM            [dbo].[ZipCodes-Fdl]
END
