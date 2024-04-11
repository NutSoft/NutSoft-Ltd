Configuration ConfigureBaseSharePoint {
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Farm")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPFarm,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Setup")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPSetup,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Services")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPServices,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Search")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPSearch,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP Admin")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPAdmin,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for SP web")] [ValidateNotNullorEmpty()] [PsCredential] $credsSPWeb,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the credentials for Passphrase")] [ValidateNotNullorEmpty()] [PsCredential] $credsPassPhrase
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SharePointDsc
    Import-DscResource -ModuleName SqlServerDsc
    Import-DscResource -ModuleName ComputerManagementDsc
    Import-DscResource -ModuleName WebAdministrationDsc
    Import-DscResource -ModuleName CertificateDSC
    Import-DscResource -ModuleName xCredSSP

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

        # Configure CredSSP settings

        xCredSSP Server {
            Ensure = 'Present'
            Role   = 'Server'
        }

        xCredSSP Client {
            Ensure            = 'Present'
            Role              = 'Client'
            DelegateComputers = @(
                $Node.NodeName,
                $Node.FQDN
            )
        }

        File SharePointFiles {
            Ensure          = 'Present'  
            Type            = 'Directory' 
            Recurse         = $true
            MatchSource     = $true
            Force           = $true 
            SourcePath      = $Node.SpSource
            Credential      = $credsSPSetup
            DestinationPath = 'C:\Automation\SharePointSE'
        }

        if ($Node.DisableIISLoopbackCheck -eq $true) {
            Registry DisableLoopBackCheck {
                Ensure    = 'Present'
                Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
                ValueName = 'DisableLoopbackCheck'
                ValueData = '1'
                ValueType = 'Dword'
            }
        }

        # Add domain user to local administrators group
        Group LocalAdmin {
            Ensure           = 'Present'
            GroupName        = 'Administrators'
            Credential       = $credsSPSetup
            MembersToInclude = $credsSPSetup.UserName
        }

        #**********************************************************
        # Install Binaries
        #
        # This section installs SharePoint and its Prerequisites
        #**********************************************************
        
        SPInstallPrereqs SharePointPrereqInstall {
            IsSingleInstance = 'Yes'
            Ensure           = 'Present'
            InstallerPath    = (Join-Path $ConfigurationData.NonNodeData.SharePoint.Binaries.Path 'prerequisiteinstaller.exe')
            OnlineMode       = $false
            MSVCRT142        = (Join-Path $ConfigurationData.NonNodeData.SharePoint.Binaries.Prereqs.OfflineInstallDir 'vc_redist.x64.exe')
            DotNet48         = (Join-Path $ConfigurationData.NonNodeData.SharePoint.Binaries.Prereqs.OfflineInstallDir 'ndp48-web.exe')
            SXSPath          = 'C:\Automation\SharePointSE\sxs'
        }

        PendingReboot AfterPrereqInstall {
            Name                 = 'AfterPrereqInstall'
            DependsOn            = '[SPInstallPrereqs]SharePointPrereqInstall'
            PsDscRunAsCredential = $credsSPSetup
        }

        SPInstall InstallSharePoint {
            IsSingleInstance = 'Yes'
            Ensure           = 'Present'
            BinaryDir        = $ConfigurationData.NonNodeData.SharePoint.Binaries.Path
            ProductKey       = $ConfigurationData.NonNodeData.SharePoint.ProductKey
            DependsOn        = '[SPInstallPrereqs]SharePointPrereqInstall'
        }

        PendingReboot AfterInstallSharePoint {
            Name                 = 'AfterSPInstall'
            DependsOn            = '[SPInstall]InstallSharePoint'
            PsDscRunAsCredential = $credsSPSetup
        }

        # Import SSL Certificates - this should have been previously exported and the private key
        # made accessible to the SPSetup account
        # Note: this script only uses a single SSL certificate and changes would be required if more
        # than one SSL certificate is to be used.
        
        PfxImport SPSSLCert {
            Ensure               = 'Present'
            Thumbprint           = $ConfigurationData.NonNodeData.SSLCertificate.Thumbprint
            Path                 = $ConfigurationData.NonNodeData.SSLCertificate.Path
            Location             = 'LocalMachine'
            Store                = $ConfigurationData.NonNodeData.SSLCertificate.StoreName
            Credential           = $CredsSPSetup
            PsDscRunAsCredential = $CredsSPSetup
        }

        # Remove unwanted IIS application pools and default website

        $ConfigurationData.NonNodeData.IISSettings.UnwantedWebAppPools | ForEach-Object {
            WebAppPool $_ {
                Name   = $_
                Ensure = 'Absent'
            }
        }

        WebSite DefaultSite {
            Name   = 'Default Web Site'
            Ensure = 'Absent'
        }

        # Create SQL alias

        SqlAlias SPSqlALias {
            Ensure            = 'Present'
            Name              = $ConfigurationData.NonNodeData.SqlServerAlias.Name
            ServerName        = $ConfigurationData.NonNodeData.SqlServerAlias.ServerName
            Protocol          = $ConfigurationData.NonNodeData.SqlServerAlias.Protocol
            UseDynamicTcpPort = $ConfigurationData.NonNodeData.SqlServerAlias.UseDynamicTcpPort
            TcpPort           = $ConfigurationData.NonNodeData.SqlServerAlias.TcpPort
        }

        # Provision SP farm - creates the SP farm or joins the server to the SP farm if already provisioned

        if ($Node.IsInitialServer) {
            SPFarm CreateSharePointFarm {
                IsSingleInstance         = 'Yes'
                Ensure                   = 'Present'
                DatabaseServer           = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
                FarmConfigDatabaseName   = $ConfigurationData.NonNodeData.SharePoint.Settings.FarmConfigDatabaseName
                AdminContentDatabaseName = $ConfigurationData.NonNodeData.SharePoint.Settings.AdminContentDatabaseName
                FarmAccount              = $credsSPFarm
                Passphrase               = $credsPassPhrase
                ServerRole               = $Node.ServerRole
                RunCentralAdmin          = $Node.RunCentralAdmin
                CentralAdministrationUrl = $ConfigurationData.NonNodeData.SharePoint.Settings.CentralAdmin.Url
                PSDSCRunAsCredential     = $credsSPSetup
                DependsOn                = '[SPInstall]InstallSharePoint'
            }

            SPFarmAdministrators SharePointFarmAdmins {
                DependsOn            = '[SPFarm]CreateSharePointFarm'
                IsSingleInstance     = 'Yes'
                Members              = $ConfigurationData.NonNodeData.SharePoint.Settings.SharePointFarmAdmins
                PsDscRunAsCredential = $CredsSPSetup
            }

            SPDiagnosticLoggingSettings ApplyDiagnosticLogSettings {
                DependsOn                                   = '[SPFarm]CreateSharePointFarm'
                IsSingleInstance                            = 'Yes'
                LogPath                                     = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.LogPath
                LogSpaceInGB                                = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.LogSpaceInGB                               
                AppAnalyticsAutomaticUploadEnabled          = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.AppAnalyticsAutomaticUploadEnabled         
                CustomerExperienceImprovementProgramEnabled = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.CustomerExperienceImprovementProgramEnabled
                DaysToKeepLogs                              = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.DaysToKeepLogs                             
                DownloadErrorReportingUpdatesEnabled        = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.DownloadErrorReportingUpdatesEnabled       
                ErrorReportingAutomaticUploadEnabled        = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.ErrorReportingAutomaticUploadEnabled       
                ErrorReportingEnabled                       = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.ErrorReportingEnabled                      
                EventLogFloodProtectionEnabled              = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.EventLogFloodProtectionEnabled             
                EventLogFloodProtectionNotifyInterval       = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.EventLogFloodProtectionNotifyInterval      
                EventLogFloodProtectionQuietPeriod          = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.EventLogFloodProtectionQuietPeriod         
                EventLogFloodProtectionThreshold            = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.EventLogFloodProtectionThreshold           
                EventLogFloodProtectionTriggerPeriod        = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.EventLogFloodProtectionTriggerPeriod       
                LogCutInterval                              = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.LogCutInterval                             
                LogMaxDiskSpaceUsageEnabled                 = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.LogMaxDiskSpaceUsageEnabled                
                ScriptErrorReportingDelay                   = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.ScriptErrorReportingDelay                  
                ScriptErrorReportingEnabled                 = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.ScriptErrorReportingEnabled                
                ScriptErrorReportingRequireAuth             = $ConfigurationData.NonNodeData.SharePoint.Settings.DiagnosticLogSettings.ScriptErrorReportingRequireAuth            
                PsDscRunAsCredential                        = $CredsSPSetup
            }
        }

        if (!$Node.IsInitialServer) {
            WaitForAll SharePointFarmCreated {
                ResourceName     = '[SPFarm]CreateSharePointFarm'
                NodeName         = $AllNodes.Where{ $_.IsInitialServer }.NodeName
                RetryIntervalSec = 60
                RetryCount       = 30
            }

            SPFarm JoinSharePointFarm {
                IsSingleInstance         = 'Yes'
                Ensure                   = 'Present'
                DatabaseServer           = $ConfigurationData.NonNodeData.SharePoint.Settings.DatabaseServer
                FarmConfigDatabaseName   = $ConfigurationData.NonNodeData.SharePoint.Settings.FarmConfigDatabaseName
                AdminContentDatabaseName = $ConfigurationData.NonNodeData.SharePoint.Settings.AdminContentDatabaseName
                FarmAccount              = $credsSPFarm
                Passphrase               = $credsPassPhrase
                ServerRole               = $Node.ServerRole
                RunCentralAdmin          = $Node.RunCentralAdmin
                CentralAdministrationUrl = $ConfigurationData.NonNodeData.SharePoint.Settings.CentralAdmin.Url
                PSDSCRunAsCredential     = $credsSPSetup
                DependsOn                = '[WaitForAll]SharePointFarmCreated'
            }
        }
    
        WaitForAll ContinueFarmSetup {
            ResourceName     = '[SPInstall]InstallSharePoint'
            NodeName         = $AllNodes.Where{ $_.IsInitialServer }.NodeName
            RetryIntervalSec = 60
            RetryCount       = 30
        }
        
        # Add service accounts

        if ($Node.RunCentralAdmin) {
            SPManagedAccount SPFarmAccount {
                AccountName          = $credsSPFarm.UserName
                Account              = $credsSPFarm
                PSDSCRunAsCredential = $credsSPSetup
                DependsOn            = '[WaitForAll]ContinueFarmSetup'
            }

            SPManagedAccount SPServices {
                AccountName          = $credsSPServices.UserName
                Account              = $credsSPServices
                PSDSCRunAsCredential = $credsSPSetup
                DependsOn            = '[WaitForAll]ContinueFarmSetup'
            }

            SPManagedAccount SPSearch {
                AccountName          = $credsSPSearch.UserName
                Account              = $credsSPSearch
                PSDSCRunAsCredential = $credsSPSetup
                DependsOn            = '[WaitForAll]ContinueFarmSetup'
            }

            SPManagedAccount SPWebApplicationPool {
                AccountName          = $credsSPWeb.UserName
                Account              = $credsSPWeb
                PSDSCRunAsCredential = $credsSPSetup
                DependsOn            = '[WaitForAll]ContinueFarmSetup'
            }

            SPShellAdmins ShellAdmins {
                IsSingleInstance     = 'Yes'
                MembersToInclude     = $credsSPAdmin.UserName
                AllDatabases         = $true
                PSDSCRunAsCredential = $credsSPSetup
                DependsOn            = '[WaitForAll]ContinueFarmSetup'
            }

            # Add SSL certificate/bindings to Central Admin

            WebSite CentralAdminSite {
                Ensure      = 'Present'
                Name        = $ConfigurationData.NonNodeData.SharePoint.Settings.CentralAdmin.Name
                BindingInfo = @(
                    DSC_WebBindingInformation {
                        Protocol              = $ConfigurationData.NonNodeData.SharePoint.Settings.CentralAdmin.Protocol
                        Port                  = $ConfigurationData.NonNodeData.SharePoint.Settings.CentralAdmin.Port
                        HostName              = $ConfigurationData.NonNodeData.SharePoint.Settings.CentralAdmin.HostName
                        CertificateThumbprint = $ConfigurationData.NonNodeData.SSLCertificate.Thumbprint
                        CertificateStoreName  = $ConfigurationData.NonNodeData.SSLCertificate.StoreName
                    }
                )
                DependsOn   = '[WaitForAll]ContinueFarmSetup'
            }
        }
    }
}
