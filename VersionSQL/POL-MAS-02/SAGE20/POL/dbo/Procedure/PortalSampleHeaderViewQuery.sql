/****** Object:  Procedure [dbo].[PortalSampleHeaderViewQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSampleHeaderViewQuery]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint
AS
BEGIN
SET NOCOUNT ON
SELECT DELIVERYDAY
		,NOTES
		,SHIPTOCODE
		,SHIPVIA
		,FULLNAME
		,CUTOFF
		,IsInactive
FROM PORTALSAMPLEHEADERVIEW WHERE ORDERNO=@OrderNo
END
