-- 딜리버리 그룹별로 정렬
-- 뉴타닉스 호스팅은 VM패스 값 중간에 VirtualMachines.folder 붙게 설정
-- Copyright ⓒ Leedk. All rights reserved.
-- Date 2023-09-20
Use [SiteDB명]   --> SiteDB명 지정
SELECT 
    REPLACE(CONCAT('XDHyp:\Connections\',B.HypervisorConnectionName,REPLACE(C.RootPath, '/', '\'),'\',
	CASE WHEN B.PluginId like 'Acropolis%' THEN 'VirtualMachines.folder\' END,A.HostedMachineName,'.vm'), '\\','\') AS "[VirtualMachinePath]",
    MIN(CONCAT (A.Name , '$')) AS "[ADComputerAccount]",
    MIN(REPLACE(A.AssociatedUserNames, ',', '; ')) AS "[AssignedUsers]",
    MIN(CASE WHEN A.AgentVersion IS NULL OR A.AgentVersion = '' THEN 'Unknown' ELSE A.AgentVersion END) AS "[VDAVersion]",
    MIN(D.Name) AS "[DeliveryGroup]"
FROM [MonitorDB명].[MonitorData].[Machine] A   --> MonitoringDB명 지정
LEFT OUTER JOIN 
    [HostingUnitServiceSchema].[HypervisorConnection] B ON A.HypervisorId = B.HypervisorConnectionUid
LEFT OUTER JOIN 
    [HostingUnitServiceSchema].[HostingUnit] C ON B.HypervisorConnectionUid = C.HypervisorConnectionUid
LEFT OUTER JOIN 
    [chb_Config].[DesktopGroups] D ON A.DesktopGroupId = D.UUID
LEFT OUTER JOIN 
    [chb_Config].[Catalogs] E ON A.CatalogId = E.UUID
WHERE D.Name in (SELECT D.Name FROM [chb_Config].[DesktopGroups]) AND A.CatalogId IS NOT NULL
GROUP BY REPLACE(CONCAT('XDHyp:\Connections\',B.HypervisorConnectionName,REPLACE(C.RootPath, '/', '\'),'\',CASE WHEN B.PluginId like 'Acropolis%' THEN 'VirtualMachines.folder\' END,A.HostedMachineName,'.vm'), '\\','\')
