/****** Object:  Procedure [dbo].[Glue_FdlTransactions_Update]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Glue_FdlTransactions_Update]
@TableName NVARCHAR(128) 
WITH EXECUTE AS owner	
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Sql NVARCHAR(MAX);
	SET @Sql = N'INSERT INTO [dbo].[Glue_FdlTransactions] SELECT * FROM ' + QUOTENAME(@TableName)
TRUNCATE TABLE [dbo].[Glue_FdlTransactions]
EXECUTE sp_executesql @Sql
END
