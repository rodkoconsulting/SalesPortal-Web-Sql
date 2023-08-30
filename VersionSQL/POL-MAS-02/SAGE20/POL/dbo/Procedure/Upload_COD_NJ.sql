/****** Object:  Procedure [dbo].[Upload_COD_NJ]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Upload_COD_NJ]
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'tmp_COD_NJ')
    DROP TABLE tmp_COD_NJ 
SELECT * INTO tmp_COD_NJ
FROM COD_NJ
WHERE 1=2
BULK INSERT tmp_COD_NJ FROM 'E:\SharedBulkInsert\cod_nj.txt' WITH (ROWTERMINATOR='\n')
IF EXISTS (SELECT name FROM sys.tables
            WHERE name = 'COD_NJ')
    DROP TABLE COD_NJ
EXEC sp_rename 'tmp_COD_NJ', 'COD_NJ'

END
