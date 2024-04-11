Configuration ConfigureSearchTopology {
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Setup")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPSetup
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SharePointDsc

    # Configurations by node in configuration data file
    
    Node $AllNodes.NodeName {

        LocalConfigurationManager {
            ConfigurationMode              = 'ApplyOnly'
            RefreshMode                    = 'PUSH'
            RebootNodeifneeded             = $True
            ConfigurationModeFrequencyMins = '15'
            CertificateId                  = $Node.Thumbprint
        }

        #**********************************************************
        # Server configuration
        #
        # This section of the configuration includes details of the
        # server level configuration, such as disks, registry
        # settings etc.
        #********************************************************** 

        # Create the Search topology

        SPSearchServiceApp SearchServiceApp {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ServiceAppName
            ApplicationPool      = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ApplicationPool
            Ensure               = 'Present'
            PsDscRunAsCredential = $credsSPSetup
        }

        SPSearchTopology LocalSearchTopology {
            DependsOn               = '[SPSearchServiceApp]SearchServiceApp'
            ServiceAppName          = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ServiceAppName
            Crawler                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.Topology.Crawler
            Admin                   = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.Topology.Admin
            ContentProcessing       = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.Topology.ContentProcessing
            AnalyticsProcessing     = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.Topology.AnalyticsProcessing
            QueryProcessing         = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.Topology.QueryProcessing
            PsDscRunAsCredential    = $credsSPSetup
            FirstPartitionDirectory = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.Topology.FirstPartitionDirectory
            IndexPartition          = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.Topology.IndexPartition
        }
    }
}
