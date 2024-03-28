Configuration OOS {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [pscredential]$Credential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName OfficeOnlineServerDsc
    Import-DscResource -ModuleName CertificateDSC

    Node $AllNodes.NodeName {
        LocalConfigurationManager {
            ConfigurationMode              = 'ApplyOnly'
            RefreshMode                    = 'Push'
            RebootNodeIfNeeded             = $true
            ConfigurationModeFrequencyMins = 15
            CertificateID                  = $Node.Thumbprint
        }

        File OOSInstallMedia {
            Ensure          = 'Present'
            Type            = 'Directory'
            Recurse         = $true
            MatchSource     = $true
            Force           = $true
            SourcePath      = $Node.OOSDVD
            Credential      = $Credential
            DestinationPath = $Node.DestinationPath
        }

        PfxImport OOSSSLCert {
            Ensure               = 'Present'
            Thumbprint           = $Node.Thumbprint
            Path                 = $Node.CertPath
            Location             = 'LocalMachine'
            Store                = 'My'
            Credential           = $Credential
            PsDscRunAsCredential = $Credential
        }

        $requiredFeatures = @(
            "Web-Server",
            "Web-Mgmt-Tools",
            "Web-Mgmt-Console",
            "Web-WebServer",
            "Web-Common-Http",
            "Web-Default-Doc",
            "Web-Static-Content",
            "Web-Performance",
            "Web-Stat-Compression",
            "Web-Dyn-Compression",
            "Web-Security",
            "Web-Filtering",
            "Web-Windows-Auth",
            "Web-App-Dev",
            "Web-Net-Ext45",
            "Web-Asp-Net45",
            "Web-ISAPI-Ext",
            "Web-ISAPI-Filter",
            "Web-Includes",
            "NET-Framework-Features",
            "NET-Framework-Core",
            "NET-HTTP-Activation",
            "NET-Non-HTTP-Activ",
            "NET-WCF-HTTP-Activation45",
            "Windows-Identity-Foundation"
        )

        foreach ($feature in $requiredFeatures) {
            WindowsFeature "WindowsFeature-$feature" {
                Ensure = 'Present'
                Name   = $feature
            }
        }

        $prereqDependencies = $requiredFeatures | ForEach-Object {
            return "[WindowsFeature]WindowsFeature-$_"
        }

        OfficeOnlineServerInstall InstallOOS {
            Ensure    = 'Present'
            Path      = $Node.OOSSource
            DependsOn = $prereqDependencies
        }

        if ($Node.NodeName -eq $ConfigurationData.NonNodeData.OOS.FirstServer) {
            OfficeOnlineServerFarm LocalFarm {
                InternalURL     = $ConfigurationData.NonNodeData.OOS.URL
                EditingEnabled  = $true
                AllowHttp       = $false
                CertificateName = $Node.CertCN
            }
        }
        else {
            WaitForAll WaitForOOSFarmToExist {
                ResourceName         = '[OfficeOnlineServerFarm]LocalFarm'
                NodeName             = $ConfigurationData.NonNodeData.OOS.FirstServer
                RetryIntervalSec     = 30
                RetryCount           = 60
                PsDscRunAsCredential = $Credential
            }

            OfficeOnlineServerMachine JoinFarm {
                MachineToJoin = $ConfigurationData.NonNodeData.OOS.FirstServer
                DependsOn     = '[WaitForAll]WaitForOOSFarmToExist'
            }
        }
    }
}