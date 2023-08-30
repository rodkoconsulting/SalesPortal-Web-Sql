/****** Object:  Procedure [dbo].[Upload_COD_NY]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Upload_COD_NY]
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'tmp_COD_NY')
    DROP TABLE tmp_COD_NY 
SELECT * INTO tmp_COD_NY
FROM COD_NY
WHERE 1=2
BULK INSERT tmp_COD_NY FROM 'E:\SharedBulkInsert\cod_ny.txt' WITH (ROWTERMINATOR='\n')
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'COD_NY')
    DROP TABLE COD_NY
EXEC sp_rename 'tmp_COD_NY', 'COD_NY'

END
