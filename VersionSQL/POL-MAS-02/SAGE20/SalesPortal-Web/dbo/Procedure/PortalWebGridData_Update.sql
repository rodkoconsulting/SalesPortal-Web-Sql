/****** Object:  Procedure [dbo].[PortalWebGridData_Update]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PortalWebGridData_Update] 
	-- Add the parameters for the stored procedure here
	@UserName varchar(25),
	@GridName varchar(25),
	@GridData varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DELETE [dbo].[PortalWebGridData] WHERE username = @UserName and gridname = @GridName;
    -- Insert statements for procedure herel
	INSERT INTO [dbo].[PortalWebGridData](username,gridname,griddata)
	VALUES(@UserName,@GridName,@GridData)
	SELECT 1
END
