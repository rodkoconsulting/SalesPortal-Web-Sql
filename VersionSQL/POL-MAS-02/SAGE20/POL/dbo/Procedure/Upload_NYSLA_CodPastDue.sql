/****** Object:  Procedure [dbo].[Upload_NYSLA_CodPastDue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Upload_NYSLA_CodPastDue]
AS
BEGIN
	SET NOCOUNT ON;
TRUNCATE TABLE AR_NYSLACOD
BULK INSERT AR_NYSLACOD FROM 'E:\SharedBulkInsert\CodPastDue.txt' WITH (ROWTERMINATOR='\n')
END
