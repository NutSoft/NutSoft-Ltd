Configuration SPScripts {
    param(
        [pscredential]$credsSPSetup
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName {
        File SPScripts {
            Ensure          = 'Present'  
            Type            = 'Directory' 
            Recurse         = $true
            MatchSource     = $true
            Force           = $true 
            SourcePath      = $Node.SPScripts
            Credential      = $credsSPSetup
            DestinationPath = 'C:\Scripts'
        }
    }
}
