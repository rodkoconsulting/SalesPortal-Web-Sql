/****** Object:  Table [dbo].[dev_PortalInactiveSampleItems_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[dev_PortalInactiveSampleItems_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[Brand] [varchar](50) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Vintage] [varchar](4) NOT NULL,
	[Uom] [varchar](4) NOT NULL,
	[BottleSize] [varchar](10) NOT NULL,
	[DamagedNotes] [varchar](30) NOT NULL,
	[SampleFocus] [varchar](1) NOT NULL,
	[Region] [varchar](40) NOT NULL,
	[MasterVendor] [varchar](40) NOT NULL,
	[Country] [varchar](20) NOT NULL,
	[Appellation] [varchar](50) NOT NULL,
 CONSTRAINT [PK__dev_PortalIn__8DDEE42D65A1E6AD] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ItemCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
