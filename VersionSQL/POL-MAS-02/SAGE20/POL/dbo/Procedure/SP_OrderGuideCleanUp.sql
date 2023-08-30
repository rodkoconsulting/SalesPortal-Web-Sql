/****** Object:  Procedure [dbo].[SP_OrderGuideCleanUp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_OrderGuideCleanUp] 
AS
BEGIN
  delete from [pol].[dbo].web_account_ogSaved where customerno in (select customerno
  FROM [POL].[dbo].[SP_OrderGuideReps]
  where salespersonno like 'hs%' or salespersonno like 'xx%')
END
