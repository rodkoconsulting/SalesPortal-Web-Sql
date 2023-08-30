/****** Object:  Table [dbo].[PortalInventoryQty_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalInventoryQty_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[QuantityAvailable] [float] NOT NULL,
	[QtyOnHand] [float] NOT NULL,
	[OnSO] [float] NOT NULL,
	[OnMO] [float] NOT NULL,
	[OnBO] [float] NOT NULL,
 CONSTRAINT [PK__PortalIn__8DDEE42D5B2E79DB] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ItemCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
