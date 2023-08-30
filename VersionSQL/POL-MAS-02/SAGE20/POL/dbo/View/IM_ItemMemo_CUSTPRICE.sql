/****** Object:  View [dbo].[IM_ItemMemo_CUSTPRICE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_ItemMemo_CUSTPRICE]
AS
SELECT        MAS_POL.dbo.IM_ItemMemo.*
FROM            MAS_POL.dbo.IM_ItemMemo
WHERE MemoCode = 'CUSTPRICE'
