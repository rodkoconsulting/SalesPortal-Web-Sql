/****** Object:  Function [dbo].[SuperTrimLeft]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[SuperTrimLeft](@str varchar(MAX)) RETURNS varchar(MAX)
 AS
 BEGIN
 IF (ASCII(LEFT(@str, 1)) < 33) BEGIN
 SET @str = STUFF(@str, 1, PATINDEX('%[^'+CHAR(0)+'-'+CHAR(32)+']%', @str) - 1, '');
END;

RETURN @str;
 END;
