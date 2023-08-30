/****** Object:  Table [dbo].[Web_Account_OgHeader_temp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Web_Account_OgHeader_temp](
	[ORDERNO] [bigint] NOT NULL,
	[ORDERTYPE] [varchar](20) NOT NULL,
	[ORDERSTATUS] [char](1) NOT NULL,
	[USERCODE] [char](4) NOT NULL,
	[CUSTOMERNO] [varchar](9) NOT NULL,
	[SAVEDDATE] [datetime] NOT NULL,
	[DELIVERYDAY] [datetime] NOT NULL,
	[NOTES] [varchar](150) NULL,
	[COOPCASES] [smallint] NOT NULL,
	[TOTALCASES] [smallint] NOT NULL,
	[TOTALBOTTLES] [smallint] NOT NULL,
	[TOTALQUANTITY] [decimal](16, 8) NOT NULL,
	[TOTALDOLLARS] [decimal](18, 2) NOT NULL,
	[COOPNO] [varchar](8) NULL,
	[PONO] [varchar](25) NULL,
	[ARDIVISIONNO] [char](2) NOT NULL,
 CONSTRAINT [PK__Web_Acco__4918B2C10B5CAFEA] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Web_Account_OgHeader_temp] ADD  CONSTRAINT [DF_Web_Account_OgHeader_temp_ARDIVISIONNO]  DEFAULT ('00') FOR [ARDIVISIONNO]
