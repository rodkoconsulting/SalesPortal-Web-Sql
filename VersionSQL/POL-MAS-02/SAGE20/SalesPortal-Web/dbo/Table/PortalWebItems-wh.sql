/****** Object:  Table [dbo].[PortalWebItems-wh]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebItems-wh](
	[item_id] [varchar](30) NOT NULL,
	[item_description] [varchar](200) NOT NULL,
	[item_type] [varchar](20) NOT NULL,
	[item_varietal] [varchar](25) NOT NULL,
	[item_country] [varchar](25) NOT NULL,
	[item_region] [varchar](25) NOT NULL,
	[item_appellation] [varchar](50) NOT NULL,
	[item_master_vendor] [varchar](25) NOT NULL,
	[item_organic] [varchar](10) NOT NULL,
	[item_biodynamic] [varchar](10) NOT NULL,
	[item_focus] [varchar](1) NOT NULL,
	[invoice_salesperson] [varchar](4) NOT NULL,
	[account_salesperson] [varchar](4) NOT NULL,
 CONSTRAINT [PK_PortalWebItems-wh] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC,
	[account_salesperson] ASC,
	[invoice_salesperson] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
