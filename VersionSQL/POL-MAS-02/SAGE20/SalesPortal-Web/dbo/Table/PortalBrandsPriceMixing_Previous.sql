/****** Object:  Table [dbo].[PortalBrandsPriceMixing_Previous]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PortalBrandsPriceMixing_Previous](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[Brand] [varchar](50) NOT NULL,
 CONSTRAINT [PK__PortalBrandsPriceMixing_Previous] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[Brand] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
