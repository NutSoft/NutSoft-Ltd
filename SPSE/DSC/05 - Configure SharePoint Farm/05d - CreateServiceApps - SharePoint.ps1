Configuration CreateServiceApplications {
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Enter the credentials for SP Setup')] [ValidateNotNullorEmpty()] [PsCredential] $credsSPSetup,
        [Parameter(Mandatory = $true, HelpMessage = 'Enter the credentials for SP Search')] [ValidateNotNullorEmpty()] [PsCredential] $credsSPSearch,
        [Parameter(Mandatory = $true, HelpMessage = 'Enter the credentials for SP User Profile')] [ValidateNotNullorEmpty()] [PsCredential] $credsSPUserProfile
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

        # Add the service app pool and service application
        
        SPServiceAppPool AppPool {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.ManagedMetadataServiceApp.ApplicationPool
            ServiceAccount       = $ConfigurationData.NonNodeData.SharePoint.Settings.ManagedMetadataServiceApp.ServiceAccount
            PsDscRunAsCredential = $CredsSPSetup
            Ensure               = 'Present'
        }
                
        # Deploy the Managed Metadata service app to the local SharePoint farm
        # and also include a specific list of users to be the term store administrators

        SPManagedMetaDataServiceApp ManagedMetadataServiceApp {
            Ensure                        = 'Present'
            Name                          = $ConfigurationData.NonNodeData.SharePoint.Settings.ManagedMetadataServiceApp.Name
            ApplicationPool               = $ConfigurationData.NonNodeData.SharePoint.Settings.ManagedMetadataServiceApp.ApplicationPool
            DatabaseServer                = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            DatabaseName                  = $ConfigurationData.NonNodeData.SharePoint.Settings.ManagedMetadataServiceApp.DatabaseName
            PsDscRunAsCredential          = $CredsSPSetup
            TermStoreAdministrators       = $ConfigurationData.NonNodeData.SharePoint.Settings.ManagedMetadataServiceApp.TermStoreAdministrators
            ContentTypeHubUrl             = $ConfigurationData.NonNodeData.SharePoint.Settings.ContentTypeHub.Url
            ContentTypePushdownEnabled    = $true
            ContentTypeSyndicationEnabled = $true
            DependsOn                     = '[SPServiceAppPool]AppPool'
        }

        # Create the "teams" managed path

        SPManagedPath TeamsManagedPath {
            Ensure               = 'Present'
            Explicit             = $False
            HostHeader           = $True
            PsDscRunAsCredential = $CredsSPSetup
            RelativeUrl          = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.ManagedPath
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.RootSite.Url
        }

        # Deploy the User Profile service app to the local SharePoint farm
        # and configure the synchronisation connection with AD

        SPManagedPath MySiteManagedPath {
            Ensure               = 'Present'
            Explicit             = $False
            HostHeader           = $True
            PsDscRunAsCredential = $CredsSPSetup
            RelativeUrl          = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.ManagedPath
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.MySiteSite.Url
        }

        SPServiceAppPool UserProfileServiceApplication {
            Ensure               = 'Present'
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.ApplicationPool
            PsDscRunAsCredential = $CredsSPSetup
            ServiceAccount       = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.ServiceAccount
        }

        SPUserProfileServiceApp UserProfileServiceApp {
            Name                         = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.Name
            ApplicationPool              = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.ApplicationPool
            MySiteHostLocation           = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.MySiteHostLocation
            MySiteManagedPath            = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.MySiteManagedPath
            ProfileDBName                = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.ProfileDBName
            ProfileDBServer              = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            SocialDBName                 = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.SocialDBName
            SocialDBServer               = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            SyncDBName                   = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.SyncDBName
            SyncDBServer                 = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
            EnableNetBIOS                = $false
            NoILMUsed                    = $true
            PsDscRunAsCredential         = $CredsSPSetup
            DependsOn                    = '[SPServiceAppPool]UserProfileServiceApplication'
            UpdateProxyGroup             = $true
            SiteNamingConflictResolution = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.SiteNamingConflictResolution
        }

        SPUserProfileSyncConnection MainDomain {
            UserProfileService    = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.Name
            Forest                = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.Forest
            Name                  = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.SyncConnectionName
            ConnectionCredentials = $credsSPUserProfile
            UseSSL                = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.UseSSL
            UseDisabledFilter     = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.UseDisabledFilter
            IncludedOUs           = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.IncludedOUs
            ConnectionType        = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.ConnectionType
            PsDscRunAsCredential  = $CredsSPSetup
            DependsOn             = '[SPUserProfileServiceApp]UserProfileServiceApp'
        }

        SPServiceAppSecurity UserProfileServiceSecurity {
            ServiceAppName       = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.Name
            SecurityType         = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.SecurityType
            MembersToInclude     = @(
                MSFT_SPServiceAppSecurityEntry {
                    Username     = 'BCKTEST\TTS-SPFarm'
                    AccessLevels = @('Full Control')
                }
                MSFT_SPServiceAppSecurityEntry {
                    Username     = 'BCKTEST\TTS-SPAdmin'
                    AccessLevels = @('Full Control')
                }
                MSFT_SPServiceAppSecurityEntry {
                    Username     = 'BCKTEST\TTS-SPSearch'
                    AccessLevels = @('Manage Profiles', 'Retrieve People Data for Search Crawlers', 'Manage Social Data')
                }
            )
            PsDscRunAsCredential = $CredsSPSetup
        }

        SPUserProfileServiceAppPermissions UPAPermissions {
            ProxyName            = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.ProxyName
            CreatePersonalSite   = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.CreatePersonalSite
            FollowAndEditProfile = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.FollowAndEditProfile
            UseTagsAndNotes      = $ConfigurationData.NonNodeData.SharePoint.Settings.UserProfileServiceApp.UseTagsAndNotes
            PsDscRunAsCredential = $CredsSPSetup
            DependsOn            = '[SPUserProfileServiceApp]UserProfileServiceApp'
        }

        # Web application permissions - all except 'Use Self-Service Site Creation' permitted

        SPWebAppPermissions WebApplicationPermissions {
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            ListPermissions      = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.ListPermissions
            SitePermissions      = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.SitePermissions
            PersonalPermissions  = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.PersonalPermissions
            PsDscRunAsCredential = $credsSPSetup
        }

        # Web application User Policy definition

        SPWebAppPolicy WebAppPolicy {
            WebAppUrl            = $ConfigurationData.NonNodeData.SharePoint.Settings.HNSCWebApp.WebAppUrl
            MembersToInclude     = @(
                MSFT_SPWebPolicyPermissions {
                    Username        = 'BCKTEST\TTS-SPFarm'
                    PermissionLevel = 'Full Control'
                    IdentityType    = 'Claims'
                }
                MSFT_SPWebPolicyPermissions {
                    Username        = 'BCKTEST\TTS-SPAdmin'
                    PermissionLevel = 'Full Control'
                    IdentityType    = 'Claims'
                }
                MSFT_SPWebPolicyPermissions {
                    Username        = 'BCKTEST\TTS-SPSearch'
                    PermissionLevel = 'Full Read'
                    IdentityType    = 'Claims'
                }
                MSFT_SPWebPolicyPermissions {
                    Username        = 'BCKTEST\TTS-SPSuperUser'
                    PermissionLevel = 'Full Control'
                    IdentityType    = 'Claims'
                }
                MSFT_SPWebPolicyPermissions {
                    Username        = 'BCKTEST\TTS-SPSuperReader'
                    PermissionLevel = 'Full Read'
                    IdentityType    = 'Claims'
                }
            )
            PsDscRunAsCredential = $credsSPSetup
        }

        # Set up Search service app

        SPServiceAppPool SearchServiceApplication {
            Ensure               = 'Present'
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ServiceAppName
            PsDscRunAsCredential = $CredsSPSetup
            ServiceAccount       = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ServiceAccount
        }

        SPSearchServiceSettings SearchServiceSettings {
            IsSingleInstance      = 'Yes'
            PerformanceLevel      = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PerformanceLevel
            #ContactEmail          = 'sharepoint@BCKTEST.com'
            WindowsServiceAccount = $credsSPSearch
            PsDscRunAsCredential  = $credsSPSetup
            DependsOn             = '[SPServiceAppPool]SearchServiceApplication'
        }

        SPSearchServiceApp SearchServiceApp {
            Name                        = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ServiceAppName
            DatabaseName                = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.DatabaseName
            ApplicationPool             = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ApplicationPool
            ProxyName                   = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ProxyName
            SearchCenterUrl             = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.SearchCenterUrl
            DefaultContentAccessAccount = $credsSPSearch
            AlertsEnabled               = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.AlertsEnabled
            ErrorDeleteCountAllowed     = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ErrorDeleteCountAllowed
            ErrorDeleteIntervalAllowed  = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ErrorDeleteIntervalAllowed
            ErrorCountAllowed           = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ErrorCountAllowed
            ErrorIntervalAllowed        = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ErrorIntervalAllowed
            DeleteUnvisitedMethod       = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.DeleteUnvisitedMethod
            RecrawlErrorCount           = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.RecrawlErrorCount
            RecrawlErrorInterval        = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.RecrawlErrorInterval
            Ensure                      = 'Present'
            PsDscRunAsCredential        = $credsSPSetup
            DependsOn                   = '[SPServiceAppPool]SearchServiceApplication'
        }

        SPServiceAppSecurity SearchServiceSecurity {
            ServiceAppName       = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ServiceAppName
            SecurityType         = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.SecurityType
            MembersToInclude     = @(
                MSFT_SPServiceAppSecurityEntry {
                    Username     = 'BCKTEST\TTS-SPFarm'
                    AccessLevels = @('Full Control')
                }
                MSFT_SPServiceAppSecurityEntry {
                    Username     = 'BCKTEST\TTS-SPAdmin'
                    AccessLevels = @('Full Control')
                }
                MSFT_SPServiceAppSecurityEntry {
                    Username     = 'BCKTEST\TTS-SPSearch'
                    AccessLevels = @('Full Control')
                }
            )
            PsDscRunAsCredential = $CredsSPSetup
        }

        SPSearchContentSource LocalSource {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.Name
            ServiceAppName       = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ServiceAppName
            ContentSourceType    = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.ContentSourceType
            Addresses            = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.Addresses
            CrawlSetting         = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.CrawlSetting
            IncrementalSchedule  = MSFT_SPSearchCrawlSchedule {
                ScheduleType                = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.IncrementalScheduleSettings.ScheduleType
                StartHour                   = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.IncrementalScheduleSettings.StartHour
                StartMinute                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.IncrementalScheduleSettings.StartMinute
                CrawlScheduleRepeatDuration = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.IncrementalScheduleSettings.CrawlScheduleRepeatDuration
                CrawlScheduleRepeatInterval = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.IncrementalScheduleSettings.CrawlScheduleRepeatInterval
            }
            FullSchedule         = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.FullSchedule
            Priority             = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.Priority
            ContinuousCrawl      = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.LocalSource.ContinuousCrawl
            Ensure               = 'Present'
            PsDscRunAsCredential = $CredsSPSetup
        }

        SPSearchContentSource PeopleSource {
            Name                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.Name
            ServiceAppName       = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.ServiceAppName
            ContentSourceType    = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.ContentSourceType
            Addresses            = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.Addresses
            CrawlSetting         = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.CrawlSetting
            IncrementalSchedule  = MSFT_SPSearchCrawlSchedule {
                ScheduleType                = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.IncrementalScheduleSettings.ScheduleType
                StartHour                   = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.IncrementalScheduleSettings.StartHour
                StartMinute                 = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.IncrementalScheduleSettings.StartMinute
                CrawlScheduleRepeatDuration = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.IncrementalScheduleSettings.CrawlScheduleRepeatDuration
                CrawlScheduleRepeatInterval = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.IncrementalScheduleSettings.CrawlScheduleRepeatInterval
            }
            FullSchedule         = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.FullSchedule
            Priority             = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.Priority
            ContinuousCrawl      = $ConfigurationData.NonNodeData.SharePoint.Settings.SearchServiceApp.PeopleSource.ContinuousCrawl
            Ensure               = 'Present'
            PsDscRunAsCredential = $CredsSPSetup
        }
    }
}
