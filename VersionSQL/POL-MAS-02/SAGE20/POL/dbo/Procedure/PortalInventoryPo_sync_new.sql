/****** Object:  Procedure [dbo].[PortalInventoryPo_sync_new]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalInventoryPo_sync_new]
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
INSERT PortalInventoryPo_Current_new(TimeSync, RepCode, ItemCode, PurchaseOrderNo, OnPo, Eta, PoDate)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
ItemCode, PurchaseOrderNo, SUM(OnPO) as OnPO, MAX(RequiredDate) as RequiredDate, MAX(PoDate) as PoDate FROM
(SELECT     MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode,  MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, SUM(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived) as OnPo,
                      MAX(MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate) as 'RequiredDate', MAX(MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderDate) as 'PoDate'
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode
WHERE     MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'S' AND
		  MAS_POL.dbo.PO_PurchaseOrderHeader.WarehouseCode='000' AND
		  MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus<>'B' AND
		  MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP' AND
		 (MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived > 0) AND
		  MAS_POL.dbo.CI_Item.Category1 = 'Y'
GROUP BY MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo
UNION ALL
SELECT ItemCode,  PurchaseOrderNo, OnPO, RequiredDate, PoDate
FROM IM_ItemWarehouse_900) Derived GROUP BY ItemCode, PurchaseOrderNo
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalInventoryPo_Previous_new where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[ItemCode],
	[PurchaseOrderNo],
	CASE WHEN MIN(Operation)<>'D' THEN [OnPo] ELSE 0 END AS OnPo,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [Eta], 112) ELSE '' END AS Eta,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [PoDate], 112) ELSE '' END AS PoDate
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[PurchaseOrderNo],[OnPo],[Eta],[PoDate] 
  FROM dbo.PortalInventoryPo_Previous_new
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[PurchaseOrderNo],[OnPo],[Eta],[PoDate]  
  FROM dbo.PortalInventoryPo_Current_new
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ItemCode],[PurchaseOrderNo],[OnPo],[Eta],[PoDate]
   
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
	CONVERT(varchar, [Eta], 112) as 'Eta',
	CONVERT(varchar, [PoDate], 112) as 'PoDate'
  FROM PortalInventoryPo_Current_new
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalInventoryPo_Previous_new where RepCode = @RepCode
INSERT PortalInventoryPo_Previous_new(TimeSync, RepCode, ItemCode, PurchaseOrderNo,OnPo, Eta, PoDate)
SELECT
	TimeSync,
	RepCode,
	ItemCode,
	PurchaseOrderNo,
	OnPo,
	Eta,
	PoDate
FROM PortalInventoryPo_Current_new
WHERE RepCode = @RepCode
END
DELETE FROM PortalInventoryPo_Current_new where RepCode = @RepCode
END
