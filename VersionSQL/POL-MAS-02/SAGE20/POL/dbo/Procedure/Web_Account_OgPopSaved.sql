﻿/****** Object:  Procedure [dbo].[Web_Account_OgPopSaved]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgPopSaved]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@ARDivisionNo char(2)='00',
	@Customer varchar(9),
	@CurrentMonth bit,
	@HasRows bit output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @ValidDate Datetime;
    DECLARE @NextMonth int;
    DECLARE @NextYear int;
    DECLARE @CurrentDay int;
    SET @CurrentDay=DAY(GETDATE());
    IF @CurrentMonth=1 OR @CurrentDay=1
    		BEGIN
			SET @ValidDate=GETDATE();
		END
	ELSE
		BEGIN
			SET @NextMonth=MONTH(GETDATE())+1;
			SET @NextYear=YEAR(GETDATE());
			IF @NextMonth=13
				BEGIN
					SET @NextMonth=1;
					SET @NextYear=@NextYear+1;
				END
			SET @ValidDate = CAST(CAST(@NextMonth AS varchar(5))+'/1/'+CAST(@NextYear As varchar(5)) as Datetime);
		END;
	BEGIN TRY
	BEGIN TRANSACTION
	DELETE FROM dbo.Web_Account_OgDetails WHERE ORDERNO=@OrderNo;
	WITH CURRENTPRICING AS
	(
	SELECT  ROW_NUMBER() OVER (PARTITION BY dbo.Web_Account_OgSaved.ARDivisionNo, dbo.Web_Account_OgSaved.CUSTOMERNO, dbo.Web_Account_OgSaved.ITEMCODE ORDER BY MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE desc, MAS_POL.dbo.IM_Pricecode.ValidDate_234 desc) AS 'RN'
	,dbo.Web_Account_OgSaved.ITEMCODE
	,MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS PriceCase
	,MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE,'C','') AS INT) AS PriceBottle
	,CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1
		   ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 AS DECIMAL(10,2))
		   ELSE CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS DECIMAL(10,2)) END
		   END AS DiscountCase,
		   CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure,'C','') AS INT)
		   ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 AS DECIMAL(10,2))
		   ELSE CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS DECIMAL(10,2)) END / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure,'C','') AS DECIMAL)
		   END AS DiscountBottle
	,CASE WHEN LTRIM(RTRIM(STR(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1,6,0)))= LTRIM(RTRIM(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)) THEN ''
		   ELSE LTRIM(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,LTRIM(RTRIM(STR(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1,6,0)+',')),'')) END AS DiscountList
	,MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE as LastInvoiceDate
	,SUM(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.QUANTITYSHIPPED) as LastQuantityShipped
	,MIN(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.UNITPRICE) as LastPrice
	FROM         MAS_POL.dbo.IM_PriceCode INNER JOIN
                      MAS_POL.dbo.AR_CUSTOMER INNER JOIN
                      dbo.Web_Account_OgSaved INNER JOIN
                      MAS_POL.dbo.CI_ITEM ON dbo.Web_Account_OgSaved.ITEMCODE = MAS_POL.dbo.CI_ITEM.ITEMCODE ON 
                      MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO = dbo.Web_Account_OgSaved.CUSTOMERNO and MAS_POL.dbo.AR_CUSTOMER.ARDivisionNo = dbo.Web_Account_OgSaved.ARDivisionNo ON MAS_POL.dbo.IM_PriceCode.ItemCode = MAS_POL.dbo.CI_ITEM.ITEMCODE AND 
                      MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel = MAS_POL.dbo.AR_CUSTOMER.PRICELEVEL LEFT OUTER JOIN
                      MAS_POL.dbo.AR_INVOICEHISTORYDETAIL LEFT OUTER JOIN
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER ON MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.INVOICENO = MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICENO AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.HEADERSEQNO = MAS_POL.dbo.AR_INVOICEHISTORYHEADER.HEADERSEQNO ON 
                      MAS_POL.dbo.CI_ITEM.ITEMCODE = MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMCODE AND 
                      MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO = MAS_POL.dbo.AR_INVOICEHISTORYHEADER.CUSTOMERNO AND
					  MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO = MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ARDIVISIONNO
WHERE     ((MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMCODE IS NULL and Web_Account_OgSaved.CUSTOMERNO=@Customer and Web_Account_OgSaved.ARDivisionNo=@ARDivisionNo) OR ((MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE >= DATEADD(YEAR, - 2, GETDATE())) AND (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.MODULECODE='S/O') AND (dbo.Web_Account_OgSaved.CUSTOMERNO = @Customer)  AND (dbo.Web_Account_OgSaved.ARDivisionNo=@ARDivisionNo))) and MAS_POL.dbo.IM_PriceCode.ValidDate_234<=@ValidDate
GROUP BY MAS_POL.dbo.AR_CUSTOMER.PRICELEVEL, dbo.Web_Account_OgSaved.ITEMCODE, MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE, 
                      dbo.Web_Account_OgSaved.CUSTOMERNO, Web_Account_OgSaved.ARDivisionNo, MAS_POL.dbo.IM_PriceCode.ValidDate_234, MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234, MAS_POL.dbo.IM_PriceCode.DiscountMarkup1, MAS_POL.dbo.IM_PriceCode.DiscountMarkup2, MAS_POL.dbo.IM_PriceCode.DiscountMarkup3, MAS_POL.dbo.IM_PriceCode.DiscountMarkup4, MAS_POL.dbo.IM_PriceCode.DiscountMarkup5, MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure
HAVING      (SUM(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.QUANTITYSHIPPED) > 0) OR
                      (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE IS NULL)

	)
	INSERT INTO dbo.Web_Account_OgDetails(ORDERNO,ITEMCODE,PriceCase,PriceBottle,DiscountCase,DiscountBottle,DiscountList,LastInvoiceDate,LastQuantityShipped,LastPrice,Cases,Bottles,UnitPriceCase,UnitPriceBottle,Total,MoboTotal,IsOverride,IsMix)
	SELECT @OrderNo,ITEMCODE,PriceCase,PriceBottle,DiscountCase,DiscountBottle,DiscountList,LastInvoiceDate,LastQuantityShipped,LastPrice,0,0,PriceCase,PriceBottle,0,0,0,0
	FROM CURRENTPRICING
	WHERE RN = 1
	IF @@ROWCOUNT > 0
		BEGIN
			SET @HasRows=1
		END
	ELSE
		BEGIN
			SET @HasRows=0
		END
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	DECLARE @ErrorMessage nvarchar(4000)
	DECLARE @ErrorSeverity int
	DECLARE @ErrorProcedure nvarchar(500)
	SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorSeverity=ERROR_SEVERITY(), @ErrorProcedure=ERROR_PROCEDURE()
	RAISERROR(@ErrorMessage,@ErrorSeverity,1) WITH LOG
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name='SP_Error_log',
	@recipients='admin@polanerselections.com',
	@subject='Sales Portal SQL Proc error',
	@body=@ErrorProcedure
	ROLLBACK TRAN
	END CATCH
END
