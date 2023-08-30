/****** Object:  Procedure [dbo].[PortalImportLogProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalImportLogProc]
	-- Add the parameters for the stored procedure here
	@OrderNumber varchar(10),
	@Notes varchar(50)
AS
BEGIN
INSERT INTO [POL].[dbo].[PortalImportLog]
           ([ORDERNO]
           ,[TIMESTAMP]
           ,[NOTES])
     VALUES
           (@OrderNumber
           ,GETDATE()
           ,@Notes)
END
