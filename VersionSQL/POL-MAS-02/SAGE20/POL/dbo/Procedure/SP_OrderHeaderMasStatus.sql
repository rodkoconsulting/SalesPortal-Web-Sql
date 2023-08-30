/****** Object:  Procedure [dbo].[SP_OrderHeaderMasStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_OrderHeaderMasStatus]
	-- Add the parameters for the stored procedure here
	@OrderNumber varchar(10)
AS
BEGIN
--DECLARE @emailbody varchar(100);
DECLARE @emailbody varchar(5100);
DECLARE @OrderNumberInt bigint;
SET @OrderNumberInt = CONVERT(bigint, @OrderNumber);
UPDATE [POL].[dbo].[Web_Account_OgHeader]
SET [ORDERSTATUS] = 'M'
WHERE ORDERNO=@OrderNumberInt
END
