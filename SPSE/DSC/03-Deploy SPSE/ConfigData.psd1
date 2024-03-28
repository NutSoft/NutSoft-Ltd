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
            CertCN                      = 'SP SSL'
            Thumbprint                  = 'ec39ec20f9e9b46f1f9e0500e031764a7abef797'
            CertPath                    = '\\ADS01\Certificates\SP-SSL.pfx'
        },
        @{
            NodeName   = 'APP01'
            ServerRole = 'ApplicationWithSearch'
        },
        @{
            NodeName   = 'APP02'
            ServerRole = 'ApplicationWithSearch'
        },
        @{
            NodeName   = 'WFE01'
            ServerRole = 'WebFrontEndWithDistributedCache'
        },
        @{
            NodeName   = 'WFE02'
            ServerRole = 'WebFrontEndWithDistributedCache'
        }
    )
    NonNodeData = @{
        OOS = @{
            URL         = 'https://oos.dev.local'
            FirstServer = 'OOS01'
        }
    }
}