@{
    AllNodes    = @(
        @{
            NodeName                    = '*'
            DisableIISLoopbackCheck     = $true
            PSDscAllowDomainUser        = $true
            IsInitialServer             = $false

            SPSource                    = '\\bck-uks-mgmt01\Binaries'
            SPScripts                   = '\\bck-uks-mgmt01\SPScripts'
            PSDscAllowPlainTextPassword = $true
            #CertificateFile = 'dscencryption'
            # The thumbprint of the Encryption Certificate
            # used to decrypt the credentials on target node
            #Thumbprint = '5744EB202DD4D968AD03647970F8CF8100931B1D'
        },

        @{ 
            NodeName        = 'BCK-UKS-APP01'
            FQDN            = 'BCK-UKS-APP01.BCKTEST.INTERNAL'
            RunCentralAdmin = $true
            ServerRole      = 'ApplicationWithSearch'
            IsInitialServer = $true
        },

        @{ 
            NodeName        = 'BCK-UKS-APP02'
            FQDN            = 'BCK-UKS-APP02.BCKTEST.INTERNAL'
            RunCentralAdmin = $false
            ServerRole      = 'ApplicationWithSearch'
        },

        @{ 
            NodeName        = 'BCK-UKS-FE01'
            FQDN            = 'BCK-UKS-FE01.BCKTEST.INTERNAL'
            RunCentralAdmin = $false
            ServerRole      = 'WebFrontEndWithDistributedCache'
        },     
        
        
        @{ 
            NodeName        = 'BCK-UKS-FE02'
            FQDN            = 'BCK-UKS-FE02.BCKTEST.INTERNAL'
            RunCentralAdmin = $false
            ServerRole      = 'WebFrontEndWithDistributedCache'
        }

    )

    NonNodeData = @{
        DomainDetails  = @{
            DomainName  = 'bcktest.internal'
            NetbiosName = 'bcktest'
        }
        SharePoint     = @{
            ProductKey = 'VW2FM-FN9FT-H22J4-WV9GT-H8VKF'
            Binaries   = @{
                SPSource = '\\bck-uks-mgmt01\Binaries'
                Path     = 'c:\Automation\SharePointSE\SPSE\'
                Prereqs  = @{
                    OfflineInstallDir = 'C:\Automation\SharePointSE\Prereqs\'
                }
            }
            Settings   = @{
                DatabaseServer            = 'SPSQLSVR'
                FarmConfigDatabaseName    = 'SP_Config'
                AdminContentDatabaseName  = 'SP_Admin'
                SharePointFarmAdmins      = @(
                    'BCKTEST\SG-bck-sharepoint-admins',
                    'BCKTEST\TTS-SPFarm',
                    'BCKTEST\TTS-SPAdmin',
                    'BCKTEST\bckadmin'
                )
                CacheAccounts             = @{
                    SuperUserAlias   = 'BCKTEST\tts-spsuperuser'
                    SuperReaderAlias = 'BCKTEST\tts-spsuperreader'
                }
                CentralAdmin              = @{
                    Url      = 'https://admin.bcktest.internal'
                    Name     = 'SharePoint Central Administration v4'
                    HostName = 'admin.bcktest.internal'
                    Protocol = 'https'
                    Port     = 443
                }
                HNSCWebApp                = @{
                    Name                   = 'SharePoint - HNSC'
                    ApplicationPool        = 'SharePoint - 443'
                    ApplicationPoolAccount = 'BCKTEST\TTS-SPWeb'
                    WebAppUrl              = 'https://sharepoint.bcktest.internal'
                    TimeZone               = 2
                    Protocol               = 'https'
                    Port                   = 443
                    DatabaseName           = 'SP_HNSC_Content'
                    AllowAnonymous         = $false
                    ListPermissions        = 'Manage Lists', 'Override List Behaviors', 'Add Items', 'Edit Items', 'Delete Items', 'View Items', 'Approve Items', 'Open Items', 'View Versions', 'Delete Versions', 'Create Alerts', 'View Application Pages'
                    SitePermissions        = 'Manage Permissions', 'View Web Analytics Data', 'Create Subsites', 'Manage Web Site', 'Add and Customize Pages', 'Apply Themes and Borders', 'Apply Style Sheets', 'Create Groups', 'Browse Directories', 'View Pages', 'Enumerate Permissions', 'Browse User Information', 'Manage Alerts', 'Use Remote Interfaces', 'Use Client Integration Features', 'Open', 'Edit Personal User Information'
                    PersonalPermissions    = 'Manage Personal Views', 'Add/Remove Personal Web Parts', 'Update Personal Web Parts'
                    Zone                   ='Default'
                    EnableCache            = $true
                    Location               = 'G:\BlobCache'
                    MaxSizeInGB            = 10
                    FileTypes              = '\.(gif|jpg|png|css|js)$'
                }
                HNSCSite                  = @{
                    Name             = 'HNSC Site Collection'
                    Url              = 'https://sharepoint.bcktest.internal'
                    HostName         = 'sharepoint.bcktest.internal'
                    ContentDatabase  = 'SP_HNSC_Content'
                    WarningSiteCount = 0
                    MaximumSiteCount = 1
                }
                RootSite                  = @{
                    Name             = 'Root Site Collection'
                    Url              = 'https://root.bcktest.internal'
                    HostName         = 'root.bcktest.internal'
                    ContentDatabase  = 'SP_Root_Content'
                    WarningSiteCount = 1
                    MaximumSiteCount = 2
                    Description      = 'Root Site Collection'
                    Template         = 'SITEPAGEPUBLISHING#0'
                    Group            = 'Root Site Collection Visitors'
                    User             = 'Everyone'
                    ManagedPath      = 'teams'
                }
                SearchSite                = @{
                    Name             = 'Search Site Collection'
                    Url              = 'https://search.bcktest.internal'
                    HostName         = 'search.bcktest.internal'
                    ContentDatabase  = 'SP_Search_Content'
                    WarningSiteCount = 0
                    MaximumSiteCount = 1
                    Description      = 'Search Site Collection'
                    Template         = 'SRCHCEN#0'
                    Group            = 'Search Site Collection Visitors'
                    User             = 'Everyone'
                }
                MySiteSite                = @{
                    Name             = 'MySite Site Collection'
                    Url              = 'https://my.bcktest.internal'
                    HostName         = 'my.bcktest.internal'
                    ContentDatabase  = 'SP_MySite_Content'
                    WarningSiteCount = 4000
                    MaximumSiteCount = 5000
                    Description      = 'MySite Site Collection'
                    Template         = 'SPSMSITEHOST#0'
                    ManagedPath      = 'personal'
                }
                ContentTypeHub            = @{
                    Name            = 'Content Type Hub'
                    Url             = 'https://root.bcktest.internal/sites/cth'
                    HostName        = 'root.bcktest.internal'
                    ContentDatabase = 'SP_Root_Content'
                    Description     = 'Content Type Hub'
                    Template        = 'STS#0'
                }
                ManagedMetadataServiceApp = @{
                    ApplicationPool         = 'SharePoint Service Applications'
                    ServiceAccount          = 'BCKTEST\TTS-SPServices'
                    Name                    = 'Managed Metadata Service Application'
                    DatabaseName            = 'SP_ManagedMetadata'
                    TermStoreAdministrators = @(
                        'BCKTEST\SG-bck-sharepoint-admins',
                        'BCKTEST\TTS-SPFarm',
                        'BCKTEST\TTS-SPAdmin'
                    )
                }
                UserProfileServiceApp     = @{
                    ApplicationPool              = 'User Profile Service Application'
                    ServiceAccount               = 'BCKTEST\TTS-SPServices'
                    Name                         = 'User Profile Service Application'
                    DatabaseName                 = 'SP_ManagedMetadata'
                    MySiteHostLocation           = 'https://my.bcktest.internal'
                    MySiteManagedPath            = 'personal'
                    ProfileDBName                = 'SP_UserProfiles'
                    SocialDBName                 = 'SP_Social'
                    SyncDBName                   = 'SP_ProfileSync'
                    SiteNamingConflictResolution = 'Username_CollisionError'
                    Forest                       = 'bcktest.internal'
                    SyncConnectionName           = 'BCKTEST AD'
                    UseSSL                       = $false
                    UseDisabledFilter            = $true
                    IncludedOUs                  = @('OU=sharepoint,DC=bcktest,DC=internal')
                    ConnectionType               = 'ActiveDirectory'
                    SecurityType                 = 'Administrators'
                    ProxyName                    = 'User Profile Service Application Proxy'
                    CreatePersonalSite           = @('Everyone')
                    FollowAndEditProfile         = @('Everyone')
                    UseTagsAndNotes              = @('None')
                }
                DiagnosticLogSettings     = @{
                    LogPath                                     = 'F:\SPLogs'
                    LogSpaceInGB                                = 10
                    AppAnalyticsAutomaticUploadEnabled          = $false
                    CustomerExperienceImprovementProgramEnabled = $true
                    DaysToKeepLogs                              = 7
                    DownloadErrorReportingUpdatesEnabled        = $false
                    ErrorReportingAutomaticUploadEnabled        = $false
                    ErrorReportingEnabled                       = $false
                    EventLogFloodProtectionEnabled              = $true
                    EventLogFloodProtectionNotifyInterval       = 5
                    EventLogFloodProtectionQuietPeriod          = 2
                    EventLogFloodProtectionThreshold            = 5
                    EventLogFloodProtectionTriggerPeriod        = 2
                    LogCutInterval                              = 15
                    LogMaxDiskSpaceUsageEnabled                 = $true
                    ScriptErrorReportingDelay                   = 30
                    ScriptErrorReportingEnabled                 = $true
                    ScriptErrorReportingRequireAuth             = $true
                }
                SearchServiceApp          = @{
                    ServiceAppName             = 'Search Service Application'
                    ServiceAccount             = 'BCKTEST\TTS-SPSearch'
                    PerformanceLevel           = 'Maximum'
                    DatabaseName               = 'SP_Search'
                    ApplicationPool            = 'SharePoint Service Applications'
                    ProxyName                  = 'Search Service Application Proxy'
                    SearchCenterUrl            = 'https://search.bcktest.internal/Pages'
                    AlertsEnabled              = $true
                    ErrorDeleteCountAllowed    = 10
                    ErrorDeleteIntervalAllowed = 240
                    ErrorCountAllowed          = 15
                    ErrorIntervalAllowed       = 360
                    DeleteUnvisitedMethod      = 1
                    RecrawlErrorCount          = 5
                    RecrawlErrorInterval       = 120
                    SecurityType               = 'Administrators'
                    LocalSource                = @{
                        Name                        = 'Local SharePoint sites'
                        ServiceAppName              = 'Search Service Application'
                        ContentSourceType           = 'SharePoint'
                        Addresses                   = @('https://sharepoint.bcktest.internal')
                        CrawlSetting                = 'CrawlSites'
                        FullSchedule                = $null
                        IncrementalScheduleSettings = @{
                            ScheduleType                = 'Daily'
                            StartHour                   = '0'
                            StartMinute                 = '0'
                            CrawlScheduleRepeatDuration = '1440'
                            CrawlScheduleRepeatInterval = '240'
                        }
                        Priority                    = 'Normal'
                        ContinuousCrawl             = $true
                    }
                    PeopleSource               = @{
                        Name                        = 'People'
                        ServiceAppName              = 'Search Service Application'
                        ContentSourceType           = 'SharePoint'
                        Addresses                   = @('sps3s://my.bcktest.internal')
                        CrawlSetting                = 'CrawlSites'
                        FullSchedule                = $null
                        IncrementalScheduleSettings = @{
                            ScheduleType                = 'Daily'
                            StartHour                   = '0'
                            StartMinute                 = '0'
                            CrawlScheduleRepeatDuration = '1440'
                            CrawlScheduleRepeatInterval = '240'
                        }
                        Priority                    = 'Normal'
                        ContinuousCrawl             = $true
                    }
                    Topology                   = @{
                        Admin                   = @('BCK-UKS-APP01', 'BCK-UKS-APP02')
                        Crawler                 = @('BCK-UKS-APP01', 'BCK-UKS-APP02')
                        ContentProcessing       = @('BCK-UKS-APP01', 'BCK-UKS-APP02')
                        AnalyticsProcessing     = @('BCK-UKS-APP01', 'BCK-UKS-APP02')
                        QueryProcessing         = @('BCK-UKS-APP01', 'BCK-UKS-APP02')
                        FirstPartitionDirectory = 'C:\SearchIndexes\0'
                        IndexPartition          = @('BCK-UKS-APP01', 'BCK-UKS-APP02')
                    }
                }
                DistributedCache          = @{
                    Name                 = 'AppFabricCachingService'
                    CacheSizeInMB        = 8192
                    ServiceAccount       = 'BCKTEST\TTS-SPServices'
                    ServerProvisionOrder = @('bck-uks-fe01', 'bck-uks-fe02')
                    CreateFirewallRules  = $true
                }
            }
        }
        SSLCertificate = @{
            StoreName  = 'My'
            Thumbprint = 'fce2736d424c7dbba210de32567f9be1cbc67fae'
            Path       = '\\bck-uks-mgmt01\Certificates\HNSC.pfx'
        }
        OOSBinding     = @{
            DnsName = 'oos.bcktest.internal'
            Zone    = 'internal-https'
        }
        IISSettings    = @{
            UnwantedWebAppPools = @(
                '.NET v2.0',
                '.NET v2.0 Classic',
                '.NET v4.5',
                '.NET v4.5 Classic',
                'Classic .NET AppPool',
                'DefaultAppPool'
            )
        }
        SqlServerAlias = @{
            Name              = 'SPSQLSVR'
            ServerName        = 'aglistener01'
            Protocol          = 'Tcp'
            UseDynamicTcpPort = $false
            TcpPort           = 1443
        }
    }
}
