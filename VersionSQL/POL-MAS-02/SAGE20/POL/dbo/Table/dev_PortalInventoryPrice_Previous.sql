/****** Object:  Table [dbo].[dev_PortalInventoryPrice_Previous]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[dev_PortalInventoryPrice_Previous](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[ContractDescription] [varchar](50) NULL,
	[PriceLevel] [char](1) NOT NULL,
	[ValidDate] [datetime] NOT NULL,
 CONSTRAINT [PK__dev_PortalIn__E33424BA0EE3280B] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ItemCode] ASC,
	[PriceLevel] ASC,
	[ValidDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
