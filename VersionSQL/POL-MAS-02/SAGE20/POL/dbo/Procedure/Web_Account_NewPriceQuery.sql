/****** Object:  Procedure [dbo].[Web_Account_NewPriceQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_NewPriceQuery]
    @State char(2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SELECT     
			MAS_POL.dbo.CI_ITEM.ITEMCODE AS ItemCode 
                     
FROM         MAS_POL.dbo.CI_ITEM LEFT OUTER JOIN
                      MAS_POL.dbo.IM_PriceCode ON MAS_POL.dbo.CI_ITEM.ITEMCODE = MAS_POL.dbo.IM_PriceCode.ItemCode
WHERE      (MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel = SUBSTRING(@State,2,1)) AND 
                      (MAS_POL.dbo.IM_PriceCode.ValidDate_234 > GETDATE())

END
