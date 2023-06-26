/****** Object:  Table [dbo].[PortalWebAccounts-wh]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebAccounts-wh](
	[account_id] [varchar](22) NOT NULL,
	[account_name] [varchar](50) NOT NULL,
	[account_affiliations] [varchar](25) NOT NULL,
	[account_salesperson] [varchar](4) NOT NULL,
	[invoice_salesperson] [varchar](4) NOT NULL,
	[account_premises] [varchar](3) NOT NULL,
	[account_territory] [varchar](25) NOT NULL,
 CONSTRAINT [PK_dimAccount] PRIMARY KEY CLUSTERED 
(
	[account_id] ASC,
	[account_salesperson] ASC,
	[invoice_salesperson] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
