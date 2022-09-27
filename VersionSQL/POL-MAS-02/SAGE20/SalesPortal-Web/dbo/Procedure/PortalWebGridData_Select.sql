/****** Object:  Procedure [dbo].[PortalWebGridData_Select]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PortalWebGridData_Select] 
	-- Add the parameters for the stored procedure here
	@UserName varchar(25),
	@GridName varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT GridData from [dbo].[PortalWebGridData] WHERE username = @UserName and gridname = @GridName;
    -- Insert statements for procedure herel
END
