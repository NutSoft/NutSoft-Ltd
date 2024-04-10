[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(
        ValueFromPipeline = $true
    )]
    [string[]]$Computers = @('APP01', 'APP02', 'WFE01', 'WFE02', 'OOS01', 'OOS02'),
    [PSCredential]$Credentials = (New-Object -Typename System.Management.Automation.PSCredential -Argumentlist "dev\administrator", (ConvertTo-SecureString 'P@ssW0rd' -Force -AsPlainText))
)

process {
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
}