Configuration SPDistributedCache {
    param(
        [Parameter(Mandatory = $true, HelpMessage = 'Enter the credentials for SP Setup')] [ValidateNotNullorEmpty()] [PsCredential] $credsSPSetup
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SharePointDsc

    Node $AllNodes.NodeName {
        if ($Node.ServerRole -eq 'WebFrontEndWithDistributedCache') {
            SPDistributedCacheService EnableDistributedCache {
                Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.DistributedCache.Name
                CacheSizeInMB        = $ConfigurationData.NonNodeData.SharePoint.Settings.DistributedCache.CacheSizeInMB
                ServiceAccount       = $ConfigurationData.NonNodeData.SharePoint.Settings.DistributedCache.ServiceAccount
                ServerProvisionOrder = $ConfigurationData.NonNodeData.SharePoint.Settings.DistributedCache.ServerProvisionOrder
                CreateFirewallRules  = $ConfigurationData.NonNodeData.SharePoint.Settings.DistributedCache.CreateFirewallRules
                PsDscRunAsCredential = $credsSPSetup
            }

            SPBlobCacheSettings BlobCacheSettings {
                WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
                Zone                 = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Zone
                EnableCache          = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.EnableCache
                Location             = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Location
                MaxSizeInGB          = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.MaxSizeInGB
                FileTypes            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.FileTypes
                PsDscRunAsCredential = $credsSPSetup
            }
        }
    }
}