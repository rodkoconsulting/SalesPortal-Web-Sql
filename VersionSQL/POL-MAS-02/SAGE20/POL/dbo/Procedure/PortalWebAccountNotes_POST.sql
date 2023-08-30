/****** Object:  Procedure [dbo].[PortalWebAccountNotes_POST]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PortalWebAccountNotes_POST] 
	-- Add the parameters for the stored procedure here
	@AcctNo varchar(12),
	@Notes nvarchar(max)
AS
BEGIN
	DECLARE @DivisionNo char(2);
	DECLARE @CustomerNo varchar(10);
SELECT @DivisionNo = LEFT(@AcctNo,2)
SELECT @CustomerNo = SUBSTRING(@AcctNo,3,len(@AcctNo)-2)
IF LEN(@Notes) = 0
	BEGIN
		DELETE FROM PortalWebAccountNotes WHERE ARDivisionNo = @DivisionNo and CustomerNo = @CustomerNo
	END
ELSE
	BEGIN
		DECLARE @CustExist varchar(10);
		SET @CustExist = (SELECT CustomerNo FROM PortalWebAccountNotes where ARDivisionNo=@DivisionNo and CustomerNo = @CustomerNo)
		IF @CustExist IS NULL
			BEGIN
				INSERT INTO PortalWebAccountNotes(ARDivisionNo,CustomerNo,Notes)
				VALUES(@DivisionNo,@CustomerNo,@Notes)
			END
		ELSE
			BEGIN
				UPDATE PortalWebAccountNotes SET Notes = @Notes WHERE ARDivisionNo=@DivisionNo and CustomerNo = @CustomerNo
			END
	END
END
SELECT 1
