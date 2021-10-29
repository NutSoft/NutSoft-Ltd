

# Define the structural test container.
$data = @{
    Module = 'WorkDays'
    Functions = @(
        'Assert-IsLeapYear',
        'Assert-IsWeekday',
        'Assert-IsWeekend',
        'Get-BankHolidays',
        'Get-BoxingDay',
        'Get-ChristmasDay',
        'Get-DaysBetweenTwoDates',
        'Get-DaysInMonth',
        'Get-EarlyMayBankHoliday',
        'Get-EasterMonday',
        'Get-EasterSunday',
        'Get-GoodFriday',
        'Get-NewYearsDay',
        'Get-SpringBankHoliday',
        'Get-SummerBankHoliday'
    )
}
$container = New-PesterContainer -Path .\WorkDays.Tests.ps1 -Data $data

# Pester test the structure of the module.
Invoke-Pester -Container $container -Output Detailed

# Remove the module from memory.
Get-Module -Name WorkDays | Remove-Module -Force

# Import the module from the local path.
Import-Module $PSScriptRoot\..\WorkDays.psm1 -Force

# Define the non-structural test container.
$container = New-PesterContainer -Path ".\[Assert|Get]*.Tests.ps1"

# Pester test the module.
Invoke-Pester -Container $container -Output Detailed




