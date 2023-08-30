/****** Object:  Procedure [dbo].[Upload_INV_PA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Upload_INV_PA]
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'tmp_AR_PA_INV')
    DROP TABLE tmp_AR_PA_INV
SELECT * INTO tmp_AR_PA_INV
FROM AR_PA_INV
WHERE 1=2
BULK INSERT tmp_AR_PA_INV FROM 'E:\SharedBulkInsert\pa_inv.txt' WITH (ROWTERMINATOR='\n')
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'AR_PA_INV')
    DROP TABLE AR_PA_INV
EXEC sp_rename 'tmp_AR_PA_INV', 'AR_PA_INV'

END
