/****** Object:  Procedure [dbo].[BoPriceCheck]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BoPriceCheck]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @TodayDate datetime = GETDATE()
	DECLARE @TodayMnth int = MONTH(@TodayDate);
	DECLARE @TodayYr int = YEAR(@TodayDate)
SELECT SALESORDERNO
FROM [MAS_POL].[dbo].[SO_SalesOrderHeader]
WHERE CancelReasonCode = 'BO' and (Month(ShipExpireDate) != @TodayMnth or Year(ShipExpireDate) != @TodayYr);
END
