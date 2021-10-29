<#
.SYNOPSIS
Determines if the supplied date is a weekend.

.DESCRIPTION
Determines if the supplied date is a weekend.

.PARAMETER Date
Specifies the date to test.

.INPUTS
Only accepts datetime as per the named parameter "Date".

.OUTPUTS
System.Boolean. Assert-IsWeekend returns True if the date is a weekend.

.EXAMPLE
PS> Assert-IsWeekend -Date (Get-Date 2017/09/12)
False

Description
-----------
Returns false for the specified date (Tuesday).

.NOTES
(c) Des Finkenzeller, NutSoft Ltd. All rights reserved.

.LINK
https://github.com/NutSoft/NutSoft-Ltd
#>
function Assert-IsWeekend {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [datetime]
        $Date = (Get-Date)
    )
    
    process {
        $Date.DayOfWeek -match 'Saturday|Sunday'
    }
}