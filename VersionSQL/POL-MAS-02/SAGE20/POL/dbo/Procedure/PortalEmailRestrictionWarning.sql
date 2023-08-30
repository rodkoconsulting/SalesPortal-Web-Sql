/****** Object:  Procedure [dbo].[PortalEmailRestrictionWarning]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalEmailRestrictionWarning]
	-- Add the parameters for the stored procedure here
	@OrderNumber varchar(10),
	@ItemNumber varchar(10),
	@QuantityOrdered varchar(1000),
	@Restriction varchar(200)
AS
BEGIN
DECLARE @emailbody varchar(2000);
SET @emailbody = 'Order Number: '+@OrderNumber+char(13)+'Item Number: '+@ItemNumber+char(13)+'Quantity Ordered: '+@QuantityOrdered+char(13)+'Restriction: '+@Restriction
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='orders@polanerselections.com',
@subject='Sales Portal restriction error',
@body=@emailbody
END
