/****** Object:  Table [dbo].[PortalWebSavedHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebSavedHeader](
	[ORDERNO] [bigint] IDENTITY(1,1) NOT NULL,
	[USERNAME] [varchar](15) NOT NULL,
	[DATE_SAVED] [datetime] NOT NULL,
	[ORDERTYPE] [varchar](3) NULL,
	[CUSTOMERNO] [varchar](9) NOT NULL,
	[DATE_DELIVERY] [datetime] NOT NULL,
	[NOTES] [varchar](150) NULL,
	[COOPNO] [varchar](8) NULL,
	[PONO] [varchar](25) NULL,
	[SHIPTO] [varchar](4) NOT NULL,
 CONSTRAINT [PK__PortalWebSavedHeader] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
