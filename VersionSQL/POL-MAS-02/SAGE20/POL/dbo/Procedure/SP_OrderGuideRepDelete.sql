/****** Object:  Procedure [dbo].[SP_OrderGuideRepDelete]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_OrderGuideRepDelete] 
	@SalesPersonNo varchar(4)
AS
BEGIN
 delete from [pol].[dbo].web_account_ogSaved where customerno in (select customerno
  FROM [POL].[dbo].[SP_OrderGuideReps]
  where salespersonno =@SalesPersonNo)
delete from [pol].[dbo].Web_UserMappings where repcode=@SalesPersonNo
delete from [pol].dbo.PortalAccountAddresses_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalAccountItemHistory_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalAccountList_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInactiveItems_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInactiveSampleItems_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInventoryDesc_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInventoryPo_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInventoryPrice_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInventoryQty_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInvoiceHistoryDetail_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInvoiceHistoryHeader_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderDetail_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderHeader_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalSampleAddresses_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalSampleOrderDetail_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalSampleOrderHeader_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderDetail_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderDetail_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderDetail_Previous where repcode=@SalesPersonNo
delete from [pol].dbo.PortalAccountAddresses_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalAccountItemHistory_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalAccountList_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInactiveItems_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInactiveSampleItems_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInventoryDesc_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInventoryPo_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInventoryPrice_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInventoryQty_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInvoiceHistoryDetail_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalInvoiceHistoryHeader_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderDetail_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderHeader_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalSampleAddresses_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalSampleOrderDetail_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalSampleOrderHeader_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderDetail_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderDetail_Current where repcode=@SalesPersonNo
delete from [pol].dbo.PortalOrderDetail_Current where repcode=@SalesPersonNo

END
