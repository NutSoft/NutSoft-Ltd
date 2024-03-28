Configuration SPSE {
    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Enter the credentials for SP Farm"
        )]
        [ValidateNotNullorEmpty()]
        [PsCredential]$CredentialSPFarm,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Enter the credentials for SP Setup"
        )]
        [ValidateNotNullorEmpty()]
        [PsCredential]$CredentialSetup,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Enter the credentials for SP Services"
        )]
        [ValidateNotNullorEmpty()]
        [PsCredential]$CredentialSPServices,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Enter the credentials for SP Search"
        )]
        [ValidateNotNullorEmpty()]
        [PsCredential]$CredentialSPSearch,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Enter the credentials for SP Admin"
        )]
        [ValidateNotNullorEmpty()]
        [PsCredential]$CredentialSPAdmin,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Enter the credentials for SP web"
        )]
        [ValidateNotNullorEmpty()]
        [PsCredential]$CredentialSPWeb,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Enter the credentials for Passphrase"
        )]
        [ValidateNotNullorEmpty()]
        [PsCredential]$CredentialPassPhrase
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SharePointDsc
    Import-DscResource -ModuleName SqlServerDsc
    Import-DscResource -ModuleName ComputerManagementDsc
    Import-DscResource -ModuleName WebAdministrationDsc
    Import-DscResource -ModuleName CertificateDSC
    Import-DscResource -ModuleName xCredSSP

    Node $AllNodes.NodeName {

        LocalConfigurationManager {
            ConfigurationMode              = 'ApplyOnly'
            RefreshMode                    = 'Push'
            RebootNodeIfNeeded             = $true
            ConfigurationModeFrequencyMins = 15
            CertificateID                  = $Node.Thumbprint
        }

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
                "$($Node.NodeName).$env:USERDNSDOMAIN"
            )
        }

        File SharePointFiles {
            Ensure          = 'Present'  
            Type            = 'Directory' 
            Recurse         = $true
            MatchSource     = $true
            Force           = $true 
            SourcePath      = $Node.SourcePath
            DestinationPath = $Node.DestinationPath
            Credential      = $CredentialSetup
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
            Credential       = $CredentialSetup
            MembersToInclude = $CredentialSetup.UserName
        }

        #**********************************************************
        # Install Binaries
        #
        # This section installs SharePoint and its Prerequisites
        #**********************************************************

        SPInstallPrereqs SharePointPrereqInstall {
            IsSingleInstance = 'Yes'
            Ensure           = 'Present'
            InstallerPath    = (Join-Path $Node.DestinationPath 'prerequisiteinstaller.exe')
            OnlineMode       = $false
            MSVCRT142        = (Join-Path $Node.Prereqs 'vc_redist.x64.exe')
            DotNet48         = (Join-Path $Node.Prereqs 'ndp48-web.exe')
            SXSPath          = $Node.SXSPath
        }

        PendingReboot AfterPrereqInstall {
            Name                 = 'AfterPrereqInstall'
            DependsOn            = '[SPInstallPrereqs]SharePointPrereqInstall'
            PsDscRunAsCredential = $CredentialSetup
        }

        SPInstall InstallSharePoint {
            IsSingleInstance = 'Yes'
            Ensure           = 'Present'
            BinaryDir        = $Node.DestinationPath
            ProductKey       = $Node.ProductKey
            DependsOn        = '[SPInstallPrereqs]SharePointPrereqInstall'
        }

        PendingReboot AfterSharePointInstall {
            Name                 = 'AfterSharePointInstall'
            DependsOn            = '[SPInstall]InstallSharePoint'
            PsDscRunAsCredential = $CredentialSetup
        }

        SPCertificate SPSSLCert {
            CertificateFilePath  = $Node.CertPath
            Store                = 'EndEntity'
            Exportable           = $true
            Ensure               = 'Present'
            PsDscRunAsCredential = $CredentialSetup
        }
    }
}
