/****** Object:  Table [dbo].[PortalWebInvoiceHeaders-wh]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebInvoiceHeaders-wh](
	[invoice_no] [varchar](7) NOT NULL,
	[invoice_sequence_no] [int] NOT NULL,
	[invoice_type] [varchar](2) NOT NULL,
	[account_id] [varchar](22) NOT NULL,
	[invoice_date] [varchar](30) NOT NULL,
	[invoice_comment] [varchar](30) NOT NULL,
	[invoice_coop_no] [varchar](10) NOT NULL,
	[invoice_salesperson] [varchar](4) NOT NULL,
	[account_salesperson] [varchar](4) NOT NULL,
 CONSTRAINT [PK_PortalWebInvoiceHeaders-wh] PRIMARY KEY CLUSTERED 
(
	[invoice_no] ASC,
	[invoice_sequence_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
