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
    # Wait 10 seconds before testing if computer has returned from restarting - repeat as necessary
    do {
        Start-Sleep -Seconds 10 
    }
    while (!(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet)) 
    # Resume the current deployment - if the server did not reboot (not required) then this will complete immediately
    Start-DscConfiguration -UseExisting -Wait -Verbose -ComputerName $ComputerName -Force -ErrorAction SilentlyContinue
}
#endregion Invoke-DscConfiguration

# Install & deploy SPSE
. .\SPSE.ps1
SPSE -ConfigurationData .\ConfigData.psd1 `
     -OutputPath .\MOFS\ `
     -CredentialSPFarm $credSPFarm `
     -CredentialSetup $credSetup `
     -CredentialSPServices $credSPServices `
     -CredentialSPSearch $credSPSearch `
     -CredentialSPAdmin $credSPAdmin `
     -CredentialSPWeb $credSPWeb `
     -CredentialPassPhrase $credPassPhrase

Invoke-DscConfiguration -ComputerName $SPAPP01 -Path .\MOFS\ 
Invoke-DscConfiguration -ComputerName $SPAPP02 -Path .\MOFS\ 
Invoke-DscConfiguration -ComputerName $SPWFE01 -Path .\MOFS\ 
Invoke-DscConfiguration -ComputerName $SPWFE02 -Path .\MOFS\ 
