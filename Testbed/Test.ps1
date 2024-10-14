Remove-Variable -Name pwd -Scope Global -Force
New-Variable -Name pwd -Visibility Private -Value (ConvertTo-SecureString 'password' -AsPlainText -Force)




