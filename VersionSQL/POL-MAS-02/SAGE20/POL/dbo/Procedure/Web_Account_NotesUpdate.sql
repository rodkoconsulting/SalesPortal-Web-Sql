/****** Object:  Procedure [dbo].[Web_Account_NotesUpdate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_NotesUpdate]
	-- Add the parameters for the stored procedure here
	@ARDivisionNo char(2)='00',
	@CustomerNo varchar(10),
	@Notes nvarchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
BEGIN TRAN
	update dbo.Web_Accounts_RepNotes set Notes = @Notes
	where CustomerNo = @CustomerNo AND ARDivisionNo = @ARDivisionNo
	IF @@ERROR<>0
		BEGIN
			ROLLBACK TRAN
		END
	COMMIT TRAN
END
