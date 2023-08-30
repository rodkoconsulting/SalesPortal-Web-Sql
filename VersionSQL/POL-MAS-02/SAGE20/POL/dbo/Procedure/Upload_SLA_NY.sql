/****** Object:  Procedure [dbo].[Upload_SLA_NY]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Upload_SLA_NY]
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'tmp_AR_NYSLA')
    DROP TABLE tmp_AR_NYSLA 
SELECT * INTO tmp_AR_NYSLA
FROM AR_NYSLA
WHERE 1=2
BULK INSERT tmp_AR_NYSLA FROM 'E:\SharedBulkInsert\nysla.txt' WITH (ROWTERMINATOR='\n')
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'AR_NYSLA')
    DROP TABLE AR_NYSLA
EXEC sp_rename 'tmp_AR_NYSLA', 'AR_NYSLA'

END
