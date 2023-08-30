/****** Object:  Procedure [dbo].[ClearLogsBoMarkIn]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE ClearLogsBoMarkIn 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TodayDate datetime = GETDATE()
	DECLARE @LastWeek datetime = DATEADD(DAY,-7,@TodayDate)
	DELETE FROM dbo.PolanerDB_BoListException WHERE [TimeStamp] < @LastWeek
    DELETE FROM dbo.PolanerDB_BoTotalsListException WHERE [TimeStamp] < @LastWeek
	DELETE FROM dbo.PolanerDB_PoItemTotalsException WHERE [TimeStamp] < @LastWeek
END
