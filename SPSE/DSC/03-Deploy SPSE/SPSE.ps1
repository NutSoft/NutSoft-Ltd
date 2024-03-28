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
                $Node.FQDN
            )
        }
    }
}
