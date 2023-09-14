-- 딜리버리 그룹 또는 카탈로그 별로 검색하는 방식
-- Copyright ⓒ Leedk. All rights reserved.
-- Date 2023-09-14
Use [SiteDB명]
SELECT REPLACE(CONCAT('XDHyp:\Connections\',B.HypervisorConnectionName,REPLACE(C.RootPath, '/', '\'),'\',A.HostedMachineName,'.vm'), '\\','\') AS "[VirtualMachinePath]" , 
CONCAT (A.Name , '$') AS "[ADComputerAccount]",
REPLACE(A.AssociatedUserNames, ',', '; ') AS "[AssignedUsers]",
CASE WHEN A.AgentVersion IS NULL OR A.AgentVersion = '' THEN 'Unknown' ELSE A.AgentVersion END AS "[VDAVersion]"
, E.DisplayName AS "[CatalogsName]"
FROM [MonitoringDB명].[MonitorData].[Machine] A
LEFT OUTER JOIN [HostingUnitServiceSchema].[HypervisorConnection] B ON A.HypervisorId = B.HypervisorConnectionUid
LEFT OUTER JOIN [HostingUnitServiceSchema].[HostingUnit] C ON B.HypervisorConnectionUid = C.HypervisorConnectionUid
LEFT OUTER JOIN [chb_Config].[DesktopGroups] D ON A.DesktopGroupId = D.UUID
LEFT OUTER JOIN [chb_Config].[Catalogs] E ON A.CatalogId = E.UUID
-- WHERE D.Name='TEST-Group'       -- 딜리버리 그룹으로 검색 시
-- WHERE E.DisplayName='TEST-Dedicated'   -- 카탈로그로 검색 시
-- GROUP BY REPLACE(CONCAT('XDHyp:\Connections\',B.HypervisorConnectionName,REPLACE(C.RootPath, '/', '\'),'\',A.HostedMachineName,'.vm'), '\\','\');
