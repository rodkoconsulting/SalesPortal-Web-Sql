/****** Object:  Table [dbo].[PortalWebInvoiceDetails-wh-new]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebInvoiceDetails-wh-new]
(
	[invoice_no] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[invoice_sequence_no] [int] NOT NULL,
	[invoice_line_sequence_no] [int] NOT NULL,
	[item_description] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[item_id] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[item_quantity] [decimal](9, 5) NOT NULL,
	[item_price] [decimal](7, 2) NOT NULL,
	[item_total] [decimal](7, 2) NOT NULL,

 CONSTRAINT [PortalWebInvoiceDetails-wh_primaryKey]  PRIMARY KEY NONCLUSTERED HASH 
(
	[invoice_no],
	[invoice_sequence_no],
	[invoice_line_sequence_no]
)WITH ( BUCKET_COUNT = 262144)
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )
