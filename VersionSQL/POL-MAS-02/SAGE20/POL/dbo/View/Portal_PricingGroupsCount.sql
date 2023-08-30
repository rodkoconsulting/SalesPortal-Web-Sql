/****** Object:  View [dbo].[Portal_PricingGroupsCount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Portal_PricingGroupsCount]
AS
SELECT     dbo.Portal_PricingGroups.PricingGroup, COUNT(1) as 'GroupCount'
FROM         dbo.Portal_PricingGroups
GROUP BY dbo.Portal_PricingGroups.PricingGroup
