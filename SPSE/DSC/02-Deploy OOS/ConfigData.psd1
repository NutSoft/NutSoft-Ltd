@{
    AllNodes    = @(
        @{
            NodeName                    = '*'
            DisableIISLoopbackCheck     = $true
            PSDscAllowDomainUser        = $true
            PSDscAllowPlainTextPassword = $true
            SourcePath                  = '\\ADS01\Binaries\OOS'
            DestinationPath             = 'C:\Automation\OOS'
            SetupExe                    = 'C:\Automation\OOS\setup.exe'
            CertCN                      = 'OOS SSL'
            Thumbprint                  = 'bcf25c7989890887fb2b3b51b53492c5b2ccf4c2'
            CertPath                    = '\\ADS01\Certificates\OOS-SSL.pfx'
        },
        @{
            NodeName = 'OOS01'
        },
        @{
            NodeName = 'OOS02'
        }
    )
    NonNodeData = @{
        OOS = @{
            URL         = 'https://oos.dev.local'
            FirstServer = 'OOS01'
        }
    }
}