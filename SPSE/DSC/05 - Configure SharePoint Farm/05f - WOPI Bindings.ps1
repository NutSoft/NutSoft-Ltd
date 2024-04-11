Configuration WopiBinding {
    param(
        [pscredential]$credsSPSetup
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SharePointDsc

    Node $AllNodes.NodeName {
        SPOfficeOnlineServerBinding OosBinding
        {
            Zone                 = $ConfigurationData.NonNodeData.OOSBinding.Zone
            DnsName              = $ConfigurationData.NonNodeData.OOSBinding.DnsName
            Ensure               = 'Present'
            PsDscRunAsCredential = $credsSPSetup
        }
    }
}
