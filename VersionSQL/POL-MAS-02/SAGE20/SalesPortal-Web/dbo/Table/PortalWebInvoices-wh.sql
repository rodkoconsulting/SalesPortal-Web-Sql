/****** Object:  Table [dbo].[PortalWebInvoices-wh]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebInvoices-wh](
	[invoice_no] [varchar](7) NOT NULL,
	[invoice_sequence_no] [varchar](6) NOT NULL,
	[invoice_line_sequence_no] [varchar](15) NOT NULL,
	[invoice_type] [varchar](2) NOT NULL,
	[account_id] [varchar](22) NOT NULL,
	[invoice_date] [varchar](30) NOT NULL,
	[invoice_comment] [varchar](30) NOT NULL,
	[invoice_coop_no] [varchar](10) NOT NULL,
	[invoice_salesperson] [varchar](4) NOT NULL,
	[account_salesperson] [varchar](4) NOT NULL,
	[item_description] [varchar](8000) NOT NULL,
	[item_id] [varchar](30) NOT NULL,
	[item_quantity] [decimal](15, 6) NOT NULL,
	[item_price] [decimal](15, 6) NOT NULL,
	[item_total] [decimal](11, 2) NOT NULL,
 CONSTRAINT [PK_PortalWebInvoices-wh] PRIMARY KEY CLUSTERED 
(
	[invoice_no] ASC,
	[invoice_sequence_no] ASC,
	[invoice_line_sequence_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
