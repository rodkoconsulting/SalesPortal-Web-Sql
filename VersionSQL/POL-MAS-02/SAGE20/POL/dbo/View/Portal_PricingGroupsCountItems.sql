/****** Object:  View [dbo].[Portal_PricingGroupsCountItems]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Portal_PricingGroupsCountItems]
AS
SELECT     dbo.Portal_PricingGroups.ITEMCODE, dbo.Portal_PricingGroups.PricingGroup, dbo.Portal_PricingGroupsCount.GroupCount
FROM         dbo.Portal_PricingGroups INNER JOIN
                      dbo.Portal_PricingGroupsCount ON dbo.Portal_PricingGroups.PricingGroup = dbo.Portal_PricingGroupsCount.PricingGroup
