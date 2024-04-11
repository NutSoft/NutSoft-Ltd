Configuration CreateHNSCWebApplication {
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Setup")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPSetup,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Admin")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPAdmin
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

        # Create the empty web application to host the HNSCs

        SPWebApplication HNSCWebApp {
            Ensure                 = 'Present'
            Name                   = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Name
            ApplicationPool        = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.ApplicationPool
            ApplicationPoolAccount = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.ApplicationPoolAccount
            WebAppUrl              = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            Port                   = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Port
            DatabaseServer         = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            DatabaseName           = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.DatabaseName
            AllowAnonymous         = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.AllowAnonymous
            PsDscRunAsCredential   = $CredsSPSetup
        }

        SPWebAppGeneralSettings HNSCWebAppGeneralSettings {
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            TimeZone             = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.TimeZone
            DependsOn            = '[SPWebApplication]HNSCWebApp'
            PsDscRunAsCredential = $CredsSPSetup
        }

        # Set the super use and reader accounts for the specified web app. It will
        # also set the appropriate web app policies by default for these accounts.

        SPCacheAccounts SetCacheAccounts {
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            SuperUserAlias       = $ConfigurationData.NonNodeData.SharePoint.Settings.CacheAccounts.SuperUserAlias
            SuperReaderAlias     = $ConfigurationData.NonNodeData.SharePoint.Settings.CacheAccounts.SuperReaderAlias
            PsDscRunAsCredential = $CredsSPSetup
        }

        # Create the empty root site collection

        SPSite HNSCSite {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCSite.Name
            Url                  = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            OwnerAlias           = $CredsSPAdmin.UserName
            ContentDatabase      = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCSite.ContentDatabase
            PSDSCRunAsCredential = $CredsSPSetup
        }
        
        # Create the content DBs for the HNSCs

        SPContentDatabase HNSCContentDB {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCSite.ContentDatabase
            DatabaseServer       = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            Enabled              = $true
            WarningSiteCount     = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCSite.WarningSiteCount
            MaximumSiteCount     = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCSite.MaximumSiteCount
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPWebApplication]HNSCWebApp'
        }

        SPContentDatabase RootContentDB {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.ContentDatabase
            DatabaseServer       = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            Enabled              = $true
            WarningSiteCount     = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.WarningSiteCount
            MaximumSiteCount     = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.MaximumSiteCount
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPWebApplication]HNSCWebApp'
        }
        
        SPContentDatabase SearchContentDB {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.ContentDatabase
            DatabaseServer       = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            Enabled              = $true
            WarningSiteCount     = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.WarningSiteCount
            MaximumSiteCount     = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.MaximumSiteCount
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPWebApplication]HNSCWebApp'
        }
        
        SPContentDatabase MySiteContentDB {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.ContentDatabase
            DatabaseServer       = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            Enabled              = $true
            WarningSiteCount     = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.WarningSiteCount
            MaximumSiteCount     = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.MaximumSiteCount
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPWebApplication]HNSCWebApp'
        }
    }
}
