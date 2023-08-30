/****** Object:  Table [dbo].[PortalSampleOrderTransmitHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalSampleOrderTransmitHeader](
	[ORDERNO] [bigint] IDENTITY(1,1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[SHIPTO] [varchar](4) NOT NULL,
	[DELIVERYDAY] [datetime] NOT NULL,
	[NOTES] [varchar](150) NULL,
 CONSTRAINT [PK__PortalSa__4918B2C125876198] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
