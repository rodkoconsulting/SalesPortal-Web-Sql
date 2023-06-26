/****** Object:  Table [dbo].[PortalWebInvoiceDetails-wh]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebInvoiceDetails-wh](
	[invoice_no] [varchar](7) NOT NULL,
	[invoice_sequence_no] [int] NOT NULL,
	[invoice_line_sequence_no] [int] NOT NULL,
	[item_description] [varchar](200) NOT NULL,
	[item_id] [varchar](30) NOT NULL,
	[item_quantity] [decimal](9, 5) NOT NULL,
	[item_price] [decimal](7, 2) NOT NULL,
	[item_total] [decimal](7, 2) NOT NULL,
 CONSTRAINT [PK_PortalWebInvoiceDetails-wh] PRIMARY KEY CLUSTERED 
(
	[invoice_no] ASC,
	[invoice_sequence_no] ASC,
	[invoice_line_sequence_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
