/****** Object:  Procedure [dbo].[Upload_SLA_NJ]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Upload_SLA_NJ]
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'tmp_AR_NJSLA')
    DROP TABLE tmp_AR_NJSLA
SELECT * INTO tmp_AR_NJSLA
FROM AR_NJSLA
WHERE 1=2
BULK INSERT tmp_AR_NJSLA FROM 'E:\SharedBulkInsert\lic_nj.txt' WITH (ROWTERMINATOR='\n')
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'AR_NJSLA')
    DROP TABLE AR_NJSLA
EXEC sp_rename 'tmp_AR_NJSLA', 'AR_NJSLA'

END
