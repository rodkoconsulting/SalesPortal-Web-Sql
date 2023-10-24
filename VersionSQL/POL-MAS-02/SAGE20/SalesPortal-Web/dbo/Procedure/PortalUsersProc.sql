/****** Object:  Procedure [dbo].[PortalUsersProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalUsersProc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON   
SELECT Right([state],1) as [state]
FROM Web_ActiveUsers where UserName=@UserName
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
