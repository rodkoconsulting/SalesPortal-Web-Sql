/****** Object:  Procedure [dbo].[Web_Account_CheckQueue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_CheckQueue]
	-- Add the parameters for the stored procedure here
	@OrderNo varchar(7),
	@result int OUTPUT
AS
SELECT @result = COUNT(*) FROM dbo.Web_Account_OgHeader where ORDERNO=@OrderNo AND ORDERSTATUS='Q'
