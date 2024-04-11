$SPAPP01 = 'APP01'
$SPAPP02 = 'APP02'
$SPWFE01 = 'WFE01'
$SPWFE02 = 'WFE02'

#region credentials
$credSetup = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'dev\administrator', (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText)
$credSPFarm = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'dev\svc-spfarm', (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText)
$credSPServices = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'dev\svc-spsvc', (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText)
$credSPSearch = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'dev\svc-spsearch', (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText)
$credSPAdmin = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'dev\spAdmin', (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText)
$credSPWeb = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'dev\svc-spweb', (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText)
$credPassPhrase = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'Farm Passphrase', (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText)
#endregion credentials

#region Invoke-DscConfiguration
function  Invoke-DscConfiguration {
    param (
        [string]$ComputerName,
        [string]$Path
    )
    # Start the DSC configuration - this may or may not require a server reboot
    Start-DscConfiguration -path $Path -Verbose -Wait -Force -ComputerName $ComputerName

    # Wait 10 seconds before testing if computer has returned from restarting (if at all)
    do {
        Start-Sleep -Seconds 10
    }
    while (!(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet))

    # Test the computer to see if further configuration is pending
    if (!(Test-DscConfiguration -ComputerName $ComputerName)) {
        # Resume the current deployment
        Start-DscConfiguration -UseExisting -Wait -Verbose -ComputerName $ComputerName -Force -ErrorAction SilentlyContinue
    }
}
#endregion Invoke-DscConfiguration

# Create the SP farm - server build sequence: APP01, WFE01, APP02, WFE02
. '.\05a - CreateSPFarm - SharePoint.ps1'
ConfigureBaseSharePoint -ConfigurationData "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05a" `
    -credsSPFarm $credSPFarm `
    -credsSPSetup $credSetup `
    -credsSPServices $credSPServices `
    -credsSPSearch $credSPSearch `
    -credsSPAdmin $credSPAdmin `
    -credsSPWeb $credSPWeb `
    -credsPassPhrase $credPassPhrase

Invoke-DscConfiguration -ComputerName $SPAPP01 -Path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05a"
Invoke-DscConfiguration -ComputerName $SPWFE01 -Path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05a"
Invoke-DscConfiguration -ComputerName $SPAPP02 -Path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05a"
Invoke-DscConfiguration -ComputerName $SPWFE02 -Path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05a"

# Create the HNSC web application
. '.\05b - CreateHNSCWebApp - SharePoint.ps1'
CreateHNSCWebApplication -ConfigurationData "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05b" `
    -credsSPSetup $credSetup `
    -credsSPAdmin $credSPAdmin

Start-DscConfiguration -path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05b" -Verbose -Wait -Force # -ComputerName $SPAPP01

# Create the root sites - when building in the TT Azure environment we encountered issues with IIS
#   Validate:
#   1 - That the IIS sites have the SSL certificate associated in the bindings
#       Remediation - edit the IIS bindings and assign the SSL certificate to the HNSC paths
#   2 - That the physical path is valid and not empty
#       Remediation - from the SP Mgmt Shell:
#           $wa = Get-SPWebApplication "SharePoint - HNSC"
#           $wa.Provision()
#           $wa = Get-SPWebApplication "SharePoint - HNSC"
#           $wa.ProvisionGlobally()
. '.\05c - CreateRootSites - SharePoint.ps1'
CreateRootSites -ConfigurationData "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05c" `
    -credsSPSetup $credSetup `
    -credsSPAdmin $credSPAdmin

Start-DscConfiguration -path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05c" -Verbose -Wait -Force -ComputerName $SPAPP01
Start-DscConfiguration -path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05c" -Verbose -Wait -Force

# Create the service applications
. '.\05d - CreateServiceApps - SharePoint.ps1'
CreateServiceApplications -ConfigurationData "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05d" `
    -credsSPSetup $credSetup `
    -credsSPSearch $credSPSearch `
    -credsSPUserProfile $credsSPUserProfile

Start-DscConfiguration -path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05d" -Verbose -Wait -Force -ComputerName $SPAPP01

# Configure search topology
. '.\05e - ConfigureSearch - SharePoint.ps1'
ConfigureSearchTopology -ConfigurationData "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05e" `
    -credsSPSetup $credSetup

Start-DscConfiguration -path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05e" -Verbose -Wait -Force -ComputerName $SPAPP01
Start-DscConfiguration -path "\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05e" -Verbose -Wait -Force -ComputerName $SPAPP02

# Configure WOPI bindings (OOS integration)
. '.\05f - WOPI Bindings.ps1'
WopiBinding -ConfigurationData 'C:\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1' `
    -outputpath '\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05f' `
    -credsSPSetup $credSetup

Start-DscConfiguration -path '\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05f' -ComputerName $SPAPP01 -Verbose -Wait -Force

# Deploy SP scripts
. '.\05g - SP Scripts.ps1'
SPScripts -ConfigurationData 'C:\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1' `
    -outputpath '\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05g' `
    -credsSPSetup $credSetup

Start-DscConfiguration -Path '\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05g' -Verbose -Wait -Force

# Configure Distributed Cache
# Validate:
#   (Get-SPServiceInstance).Where({ $_.TypeName -eq 'Distributed Cache' }) | Select-Object TypeName,Status,Id,Server
# Remove:
#   Stop-SPDistributedCacheServiceInstance -Graceful:$false
#   Remove-SPDistributedCacheServiceInstance

. '.\05h - DistributedCache - SharePoint.ps1'
SPDistributedCache -ConfigurationData 'C:\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1' `
    -outputpath '\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05h' `
    -credsSPSetup $credSetup

Start-DscConfiguration -Path '\\ADS01\C$\Git\NutSoft-Ltd\SPSE\DSC\05 - Configure SharePoint Farm\MOFS\05h' -Verbose -Wait -Force
