/****** Object:  Procedure [dbo].[PortalInventoryPo_sync_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalInventoryPo_sync_old]
	@UserName varchar(25),
	@TimeSync datetime
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @ValidDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
    Set @CurrentDate=GETDATE();
    
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName      
INSERT PortalInventoryPo_Current(TimeSync, RepCode, ItemCode, PurchaseOrderNo, OnPo, Eta)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
ItemCode, PurchaseOrderNo, SUM(OnPO) as OnPO, MAX(RequiredDate) as RequiredDate FROM
(SELECT     MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode,  MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, SUM(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived) as OnPo,
                      MAX(MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate) as 'RequiredDate'
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode
WHERE     MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'S' AND
		  MAS_POL.dbo.PO_PurchaseOrderHeader.WarehouseCode='000' AND
		  MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus<>'B' AND
		  MAS_POL.dbo.CI_Item.StandardUnitCost > 0 AND
		  MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP' AND
		 (MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived > 0) AND
		  MAS_POL.dbo.CI_Item.Category1 = 'Y'
GROUP BY MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo
UNION ALL
SELECT ItemCode,  PurchaseOrderNo, OnPO, RequiredDate
FROM IM_ItemWarehouse_900) Derived GROUP BY ItemCode, PurchaseOrderNo
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalInventoryPo_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[ItemCode],
	[PurchaseOrderNo],
	CASE WHEN MIN(Operation)<>'D' THEN [OnPo] ELSE 0 END AS OnPo,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [Eta], 112) ELSE '' END AS Eta
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[PurchaseOrderNo],[OnPo],[Eta] 
  FROM dbo.PortalInventoryPo_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[PurchaseOrderNo],[OnPo],[Eta] 
  FROM dbo.PortalInventoryPo_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ItemCode],[PurchaseOrderNo],[OnPo],[Eta]
   
HAVING COUNT(*) = 1
 
ORDER BY  [ItemCode], [PurchaseOrderNo], Operation

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[ItemCode],
	[PurchaseOrderNo],
	OnPo,
	CONVERT(varchar, [Eta], 112) as 'Eta'
  FROM PortalInventoryPo_Current
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalInventoryPo_Previous where RepCode = @RepCode
INSERT PortalInventoryPo_Previous(TimeSync, RepCode, ItemCode, PurchaseOrderNo,OnPo, Eta)
SELECT
	TimeSync,
	RepCode,
	ItemCode,
	PurchaseOrderNo,
	OnPo,
	Eta
FROM PortalInventoryPo_Current
WHERE RepCode = @RepCode
END
DELETE FROM PortalInventoryPo_Current where RepCode = @RepCode
END
