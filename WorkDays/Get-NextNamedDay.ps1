<#
.SYNOPSIS
Gets the next instance of a day of the week.

.DESCRIPTION
Gets the next instance of a day of the week.

.PARAMETER DayOfWeek
Specifies the day of the week to get the next instance of.

.INPUTS
Only accepts strings as per the named parameter "DayOfWeek".

.OUTPUTS
System.DateTime. Get-NextNamedDay returns the date of the next instance of DayOfWeek.

.EXAMPLE
PS> Get-NextNamedDay -DayOfWeek Wednesday
20 September 2023 17:30:25

.EXAMPLE
PS> Get-NextNamedDay -DayOfWeek Sunday
24 September 2023 17:34:57

.EXAMPLE
PS> "Sunday","Friday" | Get-NextNamedDay
24 September 2023 17:36:10
22 September 2023 17:36:10

.LINK
https://github.com/NutSoft/NutSoft-Ltd

#>
function Get-NextNamedDay {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $true
        )]
        [ValidateScript({
            if ($_ -in [enum]::GetValues([DayOfWeek])) {
                $true
            }
            else {
                throw "'$_' is an invalid day of week."
            }
        })]
        [string]
        $DayOfWeek
    )

    process {
        $date = (Get-Date)
        while ($date.DayOfWeek -ne $DayOfWeek) { $date = $date.AddDays(1) }
        $date
    }
}

