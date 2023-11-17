/****** Object:  Table [dbo].[PortalInvoiceHistoryDetail_Previous]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalInvoiceHistoryDetail_Previous](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[InvoiceNo] [varchar](7) NOT NULL,
	[HSeqNo] [char](1) NOT NULL,
	[DSeqNo] [char](3) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[Quantity] [decimal](15, 6) NOT NULL,
	[UnitPrice] [decimal](15, 6) NOT NULL,
	[Total] [decimal](11, 2) NOT NULL,
 CONSTRAINT [PK__PortalInvoiceHistoryDetail_Previous] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[InvoiceNo] ASC,
	[HSeqNo] ASC,
	[DSeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
