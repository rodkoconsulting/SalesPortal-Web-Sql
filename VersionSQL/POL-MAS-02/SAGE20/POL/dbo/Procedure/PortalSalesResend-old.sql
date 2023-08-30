/****** Object:  Procedure [dbo].[PortalSalesResend-old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSalesResend-old]
	-- Add the parameters for the stored procedure here
	@OrderNumber bigint,
	@InnerException varchar(5000)
AS
BEGIN
DECLARE @emailbody varchar(5100);
SET @emailbody = 'SQL Order Number: '+@OrderNumber+char(13)+'Error: '+@InnerException;
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='admin@polanerselections.com', -- keep recipient for production
@subject='Sales Portal data import error',
@body=@emailbody
EXEC [POL].[dbo].[PortalOrderExport] @OrderNumber
END
