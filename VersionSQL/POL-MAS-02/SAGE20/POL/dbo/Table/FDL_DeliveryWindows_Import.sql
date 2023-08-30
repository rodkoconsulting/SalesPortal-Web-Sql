/****** Object:  Table [dbo].[FDL_DeliveryWindows_Import]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FDL_DeliveryWindows_Import](
	[ARDivisionNo] [varchar](2) NULL,
	[CustomerNo] [varchar](20) NULL,
	[ShipToCode] [varchar](4) NULL,
	[UDF_INSTRUCTIONS] [varchar](100) NULL,
	[UDF_DELIVERY_WINDOW_1_START] [decimal](2, 0) NULL,
	[UDF_DELIVERY_WINDOW_1_END] [decimal](2, 0) NULL,
	[UDF_DELIVERY_WINDOW_2_START] [decimal](2, 0) NULL,
	[UDF_DELIVERY_WINDOW_2_END] [decimal](2, 0) NULL
) ON [PRIMARY]
