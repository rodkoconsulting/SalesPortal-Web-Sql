/****** Object:  View [dbo].[PortalSampleDetailsView]    Committed by VersionSQL https://www.versionsql.com ******/

/* =============================================
 Author:		<Author,,Name>
 Create date: <Create Date,,>
 Description:	<Description,,>
 =============================================
 SET NOCOUNT ON added to prevent extra result sets from*/
CREATE VIEW [dbo].[PortalSampleDetailsView]
AS
SELECT     d.ORDERNO, d.ITEMCODE, d.Bottles, d.Comment, i.UOM, i.InventoryAvailable, i.NoSamples,
			i.Inactive
FROM         dbo.PortalSampleOrderTransmitDetails AS d INNER JOIN
                      dbo.PortalInventoryAvailable AS i ON d.ITEMCODE = i.ItemCode
