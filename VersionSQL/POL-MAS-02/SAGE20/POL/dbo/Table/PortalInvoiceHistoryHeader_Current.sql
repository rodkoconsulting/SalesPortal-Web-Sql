/****** Object:  Table [dbo].[PortalInvoiceHistoryHeader_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalInvoiceHistoryHeader_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ARDivisionNo] [varchar](2) NOT NULL,
	[CustomerNo] [varchar](20) NOT NULL,
	[InvoiceNo] [varchar](7) NOT NULL,
	[HSeqNo] [char](1) NOT NULL,
	[InvoiceType] [varchar](2) NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[Comment] [varchar](30) NOT NULL,
 CONSTRAINT [PK__PortalIn__B823E02B523A0C7E] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[InvoiceNo] ASC,
	[HSeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
