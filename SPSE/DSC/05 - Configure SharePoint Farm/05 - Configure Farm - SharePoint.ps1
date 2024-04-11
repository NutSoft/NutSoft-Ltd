param(
    [switch]$DeleteMOF,
    [string]$SPAPP01 = 'BCK-UKS-APP01',
    [string]$SPAPP02 = 'BCK-UKS-APP02',
    [string]$SPWFE01 = 'BCK-UKS-FE01',
    [string]$SPWFE02 = 'BCK-UKS-FE02'
)

# $SPAPP01 = 'BCK-UKS-APP01'; $SPAPP02 = 'BCK-UKS-APP02'; $SPWFE01 = 'BCK-UKS-FE01'; $SPWFE02 = 'BCK-UKS-FE02'
#region credentials
#region passwords
$password = ConvertTo-SecureString "Sunshine2024" -Force -AsPlainText
$bckpassword = ConvertTo-SecureString '!"RedBlue()12345' -Force -AsPlainText
#endregion passwords
$username = "BCKTEST\TTS-SPFarm"
$credsSPFarm = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
$username = "BCKTEST\bckadmin"
$credsSPSetup = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $bckpassword
$username = "BCKTEST\TTS-SPServices"
$credsSPServices = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
$username = "BCKTEST\TTS-SPSearch"
$credsSPSearch = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
$username = "BCKTEST\TTS-SPAdmin"
$credsSPAdmin = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
$username = "BCKTEST\TTS-SPWeb"
$credsSPWeb = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
$username = "BCKTEST\TTS-SPUserProfile"
$credsSPUserProfile = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
$username = "Passphrase"
$credsPassPhrase = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
#endregion credentials

#region Invoke-DscConfiguration
function  Invoke-DscConfiguration {
    param (
        [string]$ComputerName,
        [string]$Path
    )
    # Start the DSC configuration - this may or may not require a server reboot
    Start-DscConfiguration -path $Path -Verbose -Wait -Force -ComputerName $ComputerName
    # Sleep for 1 minute - should be sufficient time for the server to reboot
    Start-Sleep -Seconds 60
    # Resume the current deployment - if the server did not reboot (not required) then this will complete immediately
    Start-DscConfiguration -UseExisting -Wait -Verbose -ComputerName $ComputerName -Force -ErrorAction SilentlyContinue
}
#endregion Invoke-DscConfiguration

# Remove any previous MOF files
if ($DeleteMOF) {
    Get-ChildItem "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\*" -Recurse | Remove-Item -Verbose -ErrorAction SilentlyContinue
}

# Create the SP farm - server build sequence: APP01, WFE01, APP02, WFE02
. '.\05a - CreateSPFarm - SharePoint.ps1'
ConfigureBaseSharePoint -ConfigurationData "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05a" `
    -credsSPFarm $credsSPFarm `
    -credsSPSetup $credsSPSetup `
    -credsSPServices $credsSPServices `
    -credsSPSearch $credsSPSearch `
    -credsSPAdmin $credsSPAdmin `
    -credsSPWeb $credsSPWeb `
    -credsPassPhrase $credsPassPhrase

Invoke-DscConfiguration -ComputerName $SPAPP01 -Path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05a"
Invoke-DscConfiguration -ComputerName $SPWFE01 -Path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05a"
Invoke-DscConfiguration -ComputerName $SPAPP02 -Path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05a"
Invoke-DscConfiguration -ComputerName $SPWFE02 -Path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05a"

# Create the HNSC web application
. '.\05b - CreateHNSCWebApp - SharePoint.ps1'
CreateHNSCWebApplication -ConfigurationData "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05b" `
    -credsSPSetup $credsSPSetup `
    -credsSPAdmin $credsSPAdmin

Start-DscConfiguration -path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05b" -Verbose -Wait -Force # -ComputerName $SPAPP01

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
CreateRootSites -ConfigurationData "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05c" `
    -credsSPSetup $credsSPSetup `
    -credsSPAdmin $credsSPAdmin

Start-DscConfiguration -path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05c" -Verbose -Wait -Force -ComputerName $SPAPP01
Start-DscConfiguration -path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05c" -Verbose -Wait -Force

# Create the service applications
. '.\05d - CreateServiceApps - SharePoint.ps1'
CreateServiceApplications -ConfigurationData "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05d" `
    -credsSPSetup $credsSPSetup `
    -credsSPSearch $credsSPSearch `
    -credsSPUserProfile $credsSPUserProfile

Start-DscConfiguration -path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05d" -Verbose -Wait -Force -ComputerName $SPAPP01

# Configure search topology
. '.\05e - ConfigureSearch - SharePoint.ps1'
ConfigureSearchTopology -ConfigurationData "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1" `
    -outputpath "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05e" `
    -credsSPSetup $credsSPSetup

Start-DscConfiguration -path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05e" -Verbose -Wait -Force -ComputerName $SPAPP01
Start-DscConfiguration -path "\\BCK-UKS-MGMT01\c$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05e" -Verbose -Wait -Force -ComputerName $SPAPP02

# Configure WOPI bindings (OOS integration)
. '.\05f - WOPI Bindings.ps1'
WopiBinding -ConfigurationData 'C:\TelefonicaTech\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1' `
    -outputpath '\\BCK-UKS-MGMT01\C$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05f' `
    -credsSPSetup $credsSPSetup

Start-DscConfiguration -path '\\BCK-UKS-MGMT01\C$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05f' -ComputerName $SPAPP01 -Verbose -Wait -Force

# Deploy SP scripts
. '.\05g - SP Scripts.ps1'
SPScripts -ConfigurationData 'C:\TelefonicaTech\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1' `
    -outputpath '\\BCK-UKS-MGMT01\C$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05g' `
    -credsSPSetup $credsSPSetup

Start-DscConfiguration -Path '\\BCK-UKS-MGMT01\C$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05g' -Verbose -Wait -Force

# Configure Distributed Cache
# Validate:
#   (Get-SPServiceInstance).Where({ $_.TypeName -eq 'Distributed Cache' }) | Select-Object TypeName,Status,Id,Server
# Remove:
#   Stop-SPDistributedCacheServiceInstance -Graceful:$false
#   Remove-SPDistributedCacheServiceInstance

. '.\05h - DistributedCache - SharePoint.ps1'
SPDistributedCache -ConfigurationData 'C:\TelefonicaTech\DSC\05 - Configure SharePoint Farm\05 - Configure Farm - SharePoint.psd1' `
    -outputpath '\\BCK-UKS-MGMT01\C$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05h' `
    -credsSPSetup $credsSPSetup

Start-DscConfiguration -Path '\\BCK-UKS-MGMT01\C$\TelefonicaTech\DSC\05 - Configure SharePoint Farm\MOFS\05h' -Verbose -Wait -Force
