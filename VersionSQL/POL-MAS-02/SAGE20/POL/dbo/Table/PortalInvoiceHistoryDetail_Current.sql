/****** Object:  Table [dbo].[PortalInvoiceHistoryDetail_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalInvoiceHistoryDetail_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[InvoiceNo] [varchar](7) NOT NULL,
	[HSeqNo] [char](1) NOT NULL,
	[DSeqNo] [char](3) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[Quantity] [float] NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[Total] [float] NOT NULL,
 CONSTRAINT [PK__PortalIn__B9187E7842F7C8EE] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[InvoiceNo] ASC,
	[HSeqNo] ASC,
	[DSeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
