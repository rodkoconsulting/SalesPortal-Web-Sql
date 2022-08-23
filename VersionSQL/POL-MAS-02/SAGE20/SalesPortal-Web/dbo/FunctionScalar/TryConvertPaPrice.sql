/****** Object:  Function [dbo].[TryConvertPaPrice]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[TryConvertPaPrice](@Value varchar(18))
RETURNS decimal(15,6)
AS
BEGIN
    SET @Value = RTRIM(LTRIM(REPLACE(@Value, ',', '')))
    IF ISNUMERIC(@Value) = 0 RETURN 0.00
    RETURN CONVERT(decimal(15,6), @Value)
END
