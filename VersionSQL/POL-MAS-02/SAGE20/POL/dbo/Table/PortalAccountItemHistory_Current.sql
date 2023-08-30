/****** Object:  Table [dbo].[PortalAccountItemHistory_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalAccountItemHistory_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ARDivisionNo] [varchar](2) NOT NULL,
	[CustomerNo] [varchar](20) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[LastDate] [datetime] NOT NULL,
	[LastShipped] [decimal](15, 6) NOT NULL,
	[LastPrice] [decimal](15, 6) NOT NULL,
 CONSTRAINT [PK__PortalAc__2D2E18B325476A76] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ARDivisionNo] ASC,
	[CustomerNo] ASC,
	[ItemCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
