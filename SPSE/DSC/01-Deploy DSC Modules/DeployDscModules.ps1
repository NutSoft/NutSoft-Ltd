$xml = [xml]( Get-Content -Path .\data.xml )

foreach ($server in $xml.servers.server) {
    $path = "\\$($server.name)\c$\Program Files\WindowsPowerShell\Modules"
    Write-Host "Copying DSC modules to: $($server.name)" -ForegroundColor Green
    foreach ($module in $server.modules.module) {
        Write-Host "-- copying: $($module.name)" -ForegroundColor Cyan
        Copy-Item -Path $module.path -Destination $path -Recurse -Force
    }
}