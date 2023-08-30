/****** Object:  Procedure [dbo].[Upload_SLA_Inactive]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Upload_SLA_Inactive]
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'tmp_AR_NYSLA_Inactive')
    DROP TABLE tmp_AR_NYSLA_Inactive
SELECT * INTO tmp_AR_NYSLA_Inactive
FROM AR_NYSLA_Inactive
WHERE 1=2
BULK INSERT tmp_AR_NYSLA_Inactive FROM 'E:\SharedBulkInsert\sla_inactive.txt' WITH (ROWTERMINATOR='\n')
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'AR_NYSLA_Inactive')
    DROP TABLE AR_NYSLA_Inactive
EXEC sp_rename 'tmp_AR_NYSLA_Inactive', 'AR_NYSLA_Inactive'

END
