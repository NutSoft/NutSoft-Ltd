@{
    AllNodes    = @(
        @{
            NodeName                    = '*'
            DisableIISLoopbackCheck     = $true
            PSDscAllowDomainUser        = $true
            PSDscAllowPlainTextPassword = $true
            SourcePath                  = '\\ADS01\Binaries\SPSE'
            DestinationPath             = 'C:\Automation\SPSE'
            #SetupExe                    = 'C:\Automation\SPSE\setup.exe'
            Prereqs                     = 'C:\Automation\SPSE\Prereqs\'
            SXSPath                     = 'C:\Automation\SPSE\sxs'
            ProductKey                  = 'VW2FM-FN9FT-H22J4-WV9GT-H8VKF'
            SSLCertificate              = @{
                CertCN               = 'SP SSL'
                Thumbprint           = 'ec39ec20f9e9b46f1f9e0500e031764a7abef797'
                CertificateFilePath  = '\\ADS01\Certificates\SP-SSL.pfx'
                CertificateStoreName = 'My'
            }

            SharePoint                  = @{
                DatabaseServer         = 'SPSQLSVR'
                FarmConfigDatabaseName = 'SP_Config'
                FarmAdminDatabaseName  = 'SP_Admin'
                CentralAdmin           = @{
                    Url      = 'https://ca.dev.local'
                    Name     = 'SharePoint Central Administration v4'
                    HostName = 'ca.dev.local'
                    Protocol = 'https'
                    Port     = 443
                }
                SharePointFarmAdmins   = @(
                    'dev\spAdmin',
                    'dev\administrator'
                )
            }
        },
        @{
            NodeName    = 'APP01'
            ServerRole  = 'ApplicationWithSearch'
            FirstServer = $true
        },
        @{
            NodeName    = 'APP02'
            ServerRole  = 'ApplicationWithSearch'
            FirstServer = $false
        },
        @{
            NodeName    = 'WFE01'
            ServerRole  = 'WebFrontEndWithDistributedCache'
            FirstServer = $false
        },
        @{
            NodeName    = 'WFE02'
            ServerRole  = 'WebFrontEndWithDistributedCache'
            FirstServer = $false
        }
    )
    NonNodeData = @{
        OOS            = @{
            URL         = 'https://oos.dev.local'
            FirstServer = 'OOS01'
        }
        IIS            = @{
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
            ServerName        = 'SQL01'
            Protocol          = 'Tcp'
            UseDynamicTcpPort = $false
            TcpPort           = 1433
        }
    }
}