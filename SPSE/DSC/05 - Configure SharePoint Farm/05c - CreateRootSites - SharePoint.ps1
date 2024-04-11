Configuration CreateRootSites {
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Setup")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPSetup,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Admin")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPAdmin
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SharePointDsc
    Import-DscResource -ModuleName WebAdministrationDsc

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

        # Confirm that the content DBs for the HNSCs exist

        SPContentDatabase RootContentDB {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.ContentDatabase
            DatabaseServer       = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            Ensure               = 'Present'
            PsDscRunAsCredential = $CredsSPSetup
        }
        
        SPContentDatabase SearchContentDB {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.ContentDatabase
            DatabaseServer       = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            Ensure               = 'Present'
            PsDscRunAsCredential = $CredsSPSetup
        }
        
        SPContentDatabase MySiteContentDB {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.ContentDatabase
            DatabaseServer       = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            Ensure               = 'Present'
            PsDscRunAsCredential = $CredsSPSetup
        }
        
        # Create the root HNSCs

        SPSite RootSite {
            Name                     = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Name
            Url                      = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Url
            HostHeaderWebApplication = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            OwnerAlias               = $CredsSPAdmin.UserName
            SecondaryOwnerAlias      = $CredsSPSetup.UserName
            CreateDefaultGroups      = $false
            ContentDatabase          = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.ContentDatabase
            Description              = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Description
            Template                 = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Template
            PSDSCRunAsCredential     = $CredsSPSetup
            DependsOn                = '[SPContentDatabase]RootContentDB'
        }
        
        SPSite SearchSite {
            Name                     = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.Name
            Url                      = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.Url
            HostHeaderWebApplication = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            OwnerAlias               = $CredsSPAdmin.UserName
            SecondaryOwnerAlias      = $CredsSPSetup.UserName
            CreateDefaultGroups      = $false
            ContentDatabase          = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.ContentDatabase
            Description              = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.Description
            Template                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.Template
            PSDSCRunAsCredential     = $CredsSPSetup
            DependsOn                = '[SPContentDatabase]SearchContentDB'
        }

        SPSite MySiteSite {
            Name                     = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Name
            Url                      = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Url
            HostHeaderWebApplication = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            OwnerAlias               = $CredsSPAdmin.UserName
            SecondaryOwnerAlias      = $CredsSPSetup.UserName
            CreateDefaultGroups      = $false
            ContentDatabase          = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.ContentDatabase
            Description              = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Description
            Template                 = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Template
            PSDSCRunAsCredential     = $CredsSPSetup
            DependsOn                = '[SPContentDatabase]MySiteContentDB'
        }

        # Create the HNSC web sites

        SPWeb RootSite {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Name
            Url                  = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Url
            Ensure               = 'Present'
            Description          = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Description
            Template             = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Template
            Language             = 1033
            AddToTopNav          = $true
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPSite]RootSite'
        }

        SPWeb SearchSite {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.Name
            Url                  = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.Url
            Ensure               = 'Present'
            Description          = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.Description
            Template             = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.Template
            Language             = 1033
            AddToTopNav          = $true
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPSite]SearchSite'
        }
        
        SPWeb MySiteSite {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Name
            Url                  = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Url
            Ensure               = 'Present'
            Description          = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Description
            Template             = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Template
            Language             = 1033
            AddToTopNav          = $true
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPSite]MySiteSite'
        }

        # Add required IIS bindings for HNSC web sites

        WebSite IISBindings {
            Ensure               = 'Present'
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Name
            ApplicationPool      = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.ApplicationPool
            BindingInfo          = @(
                DSC_WebBindingInformation {
                    Protocol              = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Protocol
                    Port                  = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Port
                    HostName              = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCSite.HostName
                    CertificateThumbprint = $ConfigurationData.NonNodeData.SSLCertificate.Thumbprint
                    CertificateStoreName  = $ConfigurationData.NonNodeData.SSLCertificate.StoreName
                }
                DSC_WebBindingInformation {
                    Protocol              = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Protocol
                    Port                  = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Port
                    HostName              = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.HostName
                    CertificateThumbprint = $ConfigurationData.NonNodeData.SSLCertificate.Thumbprint
                    CertificateStoreName  = $ConfigurationData.NonNodeData.SSLCertificate.StoreName
                }
                DSC_WebBindingInformation {
                    Protocol              = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Protocol
                    Port                  = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Port
                    HostName              = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchSite.HostName
                    CertificateThumbprint = $ConfigurationData.NonNodeData.SSLCertificate.Thumbprint
                    CertificateStoreName  = $ConfigurationData.NonNodeData.SSLCertificate.StoreName
                }
                DSC_WebBindingInformation {
                    Protocol              = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Protocol
                    Port                  = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.Port
                    HostName              = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.HostName
                    CertificateThumbprint = $ConfigurationData.NonNodeData.SSLCertificate.Thumbprint
                    CertificateStoreName  = $ConfigurationData.NonNodeData.SSLCertificate.StoreName
                }
            )
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = @(
                '[SPWeb]RootSite',
                '[SPWeb]SearchSite',
                '[SPWeb]MySiteSite'
            )
        }

        # Create the content type hub

        SPSite ContentTypeHub {
            Name                     = $ConfigurationData.NonNodeData.SharePoint.Settings.ContentTypeHub.Name
            Url                      = $ConfigurationData.NonNodeData.SharePoint.Settings.ContentTypeHub.Url
            HostHeaderWebApplication = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            OwnerAlias               = $CredsSPAdmin.UserName
            ContentDatabase          = $ConfigurationData.NonNodeData.SharePoint.Settings.ContentTypeHub.ContentDatabase
            Description              = $ConfigurationData.NonNodeData.SharePoint.Settings.ContentTypeHub.Description
            Template                 = $ConfigurationData.NonNodeData.SharePoint.Settings.ContentTypeHub.Template
            PsDscRunAsCredential     = $CredsSPSetup
            DependsOn                = '[SPWeb]RootSite'
        }

        # Activate the ContentTypeHub feature

        SPFeature ContentTypeSyndicationHub {
            Name                 = 'ContentTypeHub'
            Url                  = $ConfigurationData.NonNodeData.SharePoint.Settings.ContentTypeHub.Url
            FeatureScope         = 'Site'
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPSite]ContentTypeHub'
        }

        # Activate the InPlaceRecords feature - allows the creation of information management policies that
        # permit the declaration of records
        
        SPFeature ContentTypeInPlaceRecords {
            Name                 = 'InPlaceRecords'
            Url                  = $ConfigurationData.NonNodeData.SharePoint.Settings.ContentTypeHub.Url
            FeatureScope         = 'Site'
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPSite]ContentTypeHub'
        }
    }
}
