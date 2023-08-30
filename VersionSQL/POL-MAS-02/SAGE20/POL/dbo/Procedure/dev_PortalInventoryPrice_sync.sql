/****** Object:  Procedure [dbo].[dev_PortalInventoryPrice_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[dev_PortalInventoryPrice_sync]
	@UserName varchar(25),
	@TimeSync datetime
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @ValidDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
    DECLARE @NextMonth int;
    DECLARE @NextYear int;
    DECLARE @RepCode varchar(4);
    SET @CurrentDate=GETDATE();
    SET @NextMonth=MONTH(@CurrentDate)+1;
	SET @NextYear=YEAR(@CurrentDate);
	IF @NextMonth=13
		BEGIN
			SET @NextMonth=1;
			SET @NextYear=@NextYear+1;
		END
	SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
	SET @ValidDate = CAST(CAST(@NextMonth AS varchar(5))+'/1/'+CAST(@NextYear As varchar(5)) as Datetime);
	WITH CURRENTPRICE AS
	(
SELECT     ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.IM_PriceCode.ItemCode, MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel ORDER BY MAS_POL.dbo.IM_PriceCode.ValidDate_234 desc) AS 'RN',
		   MAS_POL.dbo.CI_Item.ItemCode, 
           MAS_POL.DBO.IM_PriceCode.ValidDateDescription_234 AS ContractDescription,
           MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel AS PriceLevel,
            MAS_POL.dbo.IM_PriceCode.ValidDate_234 AS ValidDate
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
                      MAS_POL.dbo.IM_PriceCode ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_PriceCode.ItemCode
WHERE     (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (MAS_POL.dbo.CI_Item.ItemType = '1') AND (MAS_POL.dbo.CI_Item.Category1 = 'Y') AND (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000') AND 
                      (MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder
                       + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder > 0.04) AND MAS_POL.dbo.IM_PriceCode.ValidDate_234 <= @ValidDate AND MAS_POL.dbo.IM_PriceCode.PriceCodeRecord='3'
)
SELECT 
	@CurrentDate AS TimeSync,
	@RepCode AS RepCode,
	ItemCode,
	ContractDescription,
	PriceLevel,
	ValidDate
INTO #temp_dev_PortalInventoryPrice_Current
FROM CURRENTPRICE 
WHERE RN < 3
SELECT @TimeSyncPrev = MAX(TimeSync) FROM dev_PortalInventoryPrice_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[ItemCode],
	[PriceLevel],
	CONVERT(varchar, [ValidDate], 12) as ValidDate,
	CASE WHEN MIN(Operation)<>'D' THEN [ContractDescription] ELSE '' END AS ContractDescription
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[ContractDescription],[PriceLevel],[ValidDate]
  FROM dbo.dev_PortalInventoryPrice_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[ContractDescription],[PriceLevel],[ValidDate]
  FROM #temp_dev_PortalInventoryPrice_Current
  WHERE [RepCode] = @RepCode
 
) tmp
 
GROUP BY [ItemCode],[ContractDescription],[PriceLevel],[ValidDate]
   
HAVING COUNT(*) = 1
 
ORDER BY  [ItemCode], [PriceLevel], [ValidDate] desc, Operation

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[ItemCode],
	PriceLevel,
	CONVERT(varchar, [ValidDate], 12) as ValidDate,
	ContractDescription
  FROM #temp_dev_PortalInventoryPrice_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM dev_PortalInventoryPrice_Previous where RepCode = @RepCode
INSERT dev_PortalInventoryPrice_Previous(TimeSync, RepCode, ItemCode, ContractDescription, PriceLevel, ValidDate)
SELECT 
	TimeSync,
	RepCode,
	ItemCode,
	ContractDescription,
	PriceLevel,
	ValidDate
FROM #temp_dev_PortalInventoryPrice_Current
WHERE RepCode = @RepCode
END

END
