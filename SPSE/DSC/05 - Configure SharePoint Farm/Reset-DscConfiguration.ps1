[CmdletBinding(SupportsShouldProcess)]
param(
    $Computers = @('bck-uks-APP01', 'bck-uks-APP02', 'bck-uks-FE01', 'bck-uks-FE02'),
    [PSCredential]$Credentials = (New-Object -typename System.Management.Automation.PSCredential -argumentlist "bcktest\bckadmin", (ConvertTo-SecureString '!"RedBlue()12345' -Force -AsPlainText))
)

foreach ($computer in $Computers) {
    $cimSession = New-CimSession -ComputerName $computer -Credential $Credentials
    if ($PSCmdlet.ShouldProcess($computer, "Stopping remote DSC configuration jobs")) {
        Stop-DscConfiguration -CimSession $cimSession -Verbose -Force
    }
    Invoke-Command -ComputerName $computer -ScriptBlock { Get-ChildItem -Path C:\Windows\System32\Configuration -File -Force }
    if ($PSCmdlet.ShouldProcess($computer, "Removing remote DSC configuration jobs")) {
        #Remove-DscConfigurationDocument -CimSession $cimSession -Stage Current, Pending, Previous -Verbose -Force
        Remove-DscConfigurationDocument -CimSession $cimSession -Stage Pending -Verbose -Force
        Invoke-Command -ComputerName $computer -ScriptBlock { Get-ChildItem -Path C:\Windows\System32\Configuration -File -Force }
    }
}

