/****** Object:  Function [dbo].[TryConvertUom]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[TryConvertUom](@Value varchar(18))
RETURNS int
AS
BEGIN
    SET @Value = REPLACE(@Value, ',', '')
    IF ISNUMERIC(@Value + 'e0') = 0 RETURN 12
    IF ( CHARINDEX('.', @Value) > 0 AND CONVERT(bigint, PARSENAME(@Value, 1)) <> 0 ) RETURN 12
    DECLARE @I bigint =
        CASE
        WHEN CHARINDEX('.', @Value) > 0 THEN CONVERT(bigint, PARSENAME(@Value, 2))
        ELSE CONVERT(bigint, @Value)
        END
    IF ABS(@I) > 2147483647 RETURN 12
    RETURN @I
END
