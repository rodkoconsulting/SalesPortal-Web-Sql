/****** Object:  Procedure [dbo].[dev_PortalInventoryPo_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[dev_PortalInventoryPo_sync]
	@UserName varchar(25),
	@TimeSync datetime
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
    Set @CurrentDate=GETDATE();
    
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
ItemCode, PurchaseOrderNo, SUM(OnPO) as OnPO, MAX(RequiredDate) as Eta, MAX(PoDate) as PoDate, MAX(PoCmt) as PoCmt
INTO #temp_dev_PortalInventoryPo_Current
FROM
(SELECT     MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode,  MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, SUM(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived) as OnPo,
                      MAX(MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate) as 'RequiredDate', MAX(MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderDate) as 'PoDate'
					  , MAX(MAS_POL.dbo.PO_PurchaseOrderHeader.UDF_AVAILABLE_COMMENT) as 'PoCmt'
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
SELECT ItemCode,  PurchaseOrderNo, OnPO, '1753-01-01 00:00:00.000' as RequiredDate, '1753-01-01 00:00:00.000' as PoDate, '' as PoCmt
FROM IM_ItemWarehouse_900) Derived GROUP BY ItemCode, PurchaseOrderNo
SELECT @TimeSyncPrev = MAX(TimeSync) FROM dev_PortalInventoryPo_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[ItemCode],
	[PurchaseOrderNo],
	CAST(CASE WHEN MIN(Operation)<>'D' THEN [OnPo] ELSE 0 END AS float) AS OnPo,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [Eta], 112) ELSE '' END AS Eta,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [PoDate], 112) ELSE '' END AS PoDate,
	CASE WHEN MIN(Operation)<>'D' THEN [PoCmt] ELSE '' END AS PoCmt
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[PurchaseOrderNo],[OnPo],[Eta],[PoDate],[PoCmt]
  FROM dbo.dev_PortalInventoryPo_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[PurchaseOrderNo],[OnPo],[Eta],[PoDate],[PoCmt]
  FROM #temp_dev_PortalInventoryPo_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ItemCode],[PurchaseOrderNo],[OnPo],[Eta],[PoDate],[PoCmt]
   
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
	CAST(OnPo AS float) as OnPo,
	CONVERT(varchar, [Eta], 112) as 'Eta',
	CONVERT(varchar, [PoDate], 112) as 'PoDate',
	[PoCmt]
  FROM #temp_dev_PortalInventoryPo_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM dev_PortalInventoryPo_Previous where RepCode = @RepCode
INSERT dev_PortalInventoryPo_Previous(TimeSync, RepCode, ItemCode, PurchaseOrderNo,OnPo, Eta, PoDate, PoCmt)
SELECT
	TimeSync,
	RepCode,
	ItemCode,
	PurchaseOrderNo,
	OnPo,
	Eta,
	PoDate,
	PoCmt
FROM #temp_dev_PortalInventoryPo_Current
WHERE RepCode = @RepCode
END

END
