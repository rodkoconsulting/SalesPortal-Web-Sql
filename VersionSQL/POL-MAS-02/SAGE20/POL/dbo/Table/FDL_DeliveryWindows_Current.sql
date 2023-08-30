/****** Object:  Table [dbo].[FDL_DeliveryWindows_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FDL_DeliveryWindows_Current](
	[Ship to ID] [varchar](27) NOT NULL,
	[Name] [varchar](30) NULL,
	[Address] [varchar](30) NULL,
	[City] [varchar](20) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[Delivery Instruction] [varchar](50) NULL,
	[Delivery Window #1 - Open] [varchar](5) NULL,
	[Delivery Window #1 - Close] [varchar](5) NULL,
	[Delivery Window #2 - Open] [varchar](5) NULL,
	[Delivery Window #2 - Close] [varchar](5) NULL
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE CLUSTERED INDEX [IDX_ShipToId] ON [dbo].[FDL_DeliveryWindows_Current]
(
	[Ship to ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
