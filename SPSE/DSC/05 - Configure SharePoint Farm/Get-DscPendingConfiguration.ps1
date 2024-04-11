[CmdletBinding(SupportsShouldProcess)]
param(
    $Computers = @('bck-uks-app01', 'bck-uks-app02','bck-uks-fe01', 'bck-uks-fe02')
)

foreach ($computer in $Computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock { Get-ChildItem -Path C:\Windows\System32\Configuration\Pending.mof -File -Force -ErrorAction SilentlyContinue }
}

