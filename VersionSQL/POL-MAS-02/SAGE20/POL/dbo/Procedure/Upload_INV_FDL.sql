/****** Object:  Procedure [dbo].[Upload_INV_FDL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Upload_INV_FDL]
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'tmp_FDL_INV')
    DROP TABLE tmp_FDL_INV
SELECT * INTO tmp_FDL_INV
FROM FDL_INV
WHERE 1=2
BULK INSERT tmp_FDL_INV FROM 'E:\SharedBulkInsert\fdl_inv.txt' WITH (ROWTERMINATOR='\n')
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'FDL_INV')
    DROP TABLE FDL_INV
EXEC sp_rename 'tmp_FDL_INV', 'FDL_INV'

END
