/****** Object:  Procedure [dbo].[PortalException]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalException]
	-- Add the parameters for the stored procedure here
	@OrderNumber varchar(10),
	@InnerException varchar(5000),
	@EmailSubject varchar(50)
AS
BEGIN
--DECLARE @emailbody varchar(100);
DECLARE @emailbody varchar(6000);
SET @emailbody = 'SQL Order Info: '+@OrderNumber+char(13)+'Error: '+@InnerException;
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='orders@polanerselections.com', --should remain itadmin in production
@subject=@EmailSubject,
@body=@emailbody
--EXEC [MAS_POL_REPL].[dbo].[Web_Account_OrderExport] @OrderNo=@OrderNumberInt
END
