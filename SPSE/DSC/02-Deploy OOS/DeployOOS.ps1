#region credentials
$credSetup = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'dev\administrator', (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText)
#endregion credentials

# Install & deploy OOS
. .\OOS.ps1
OOS -ConfigurationData .\ConfigData.psd1 `
    -OutputPath .\MOFS\ `
    -Credential $credSetup

Start-DscConfiguration -Path .\MOFS\ -Verbose -Wait -Force
