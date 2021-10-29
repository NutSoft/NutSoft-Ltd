<#
.SYNOPSIS
Determines if the supplied date is a weekday.

.DESCRIPTION
Determines if the supplied date is a weekday.

.PARAMETER Date
Specifies the date to test.

.INPUTS
Only accepts datetime as per the named parameter "Date".

.OUTPUTS
System.Boolean. Assert-IsWeekday returns True if the date is a weekday.

.EXAMPLE
PS> Assert-IsWeekday -Date (Get-Date 2017/09/12)
True

Description
-----------
Returns true for the specified date (Tuesday).

.NOTES
(c) Des Finkenzeller, NutSoft Ltd. All rights reserved.

.LINK
https://github.com/NutSoft/NutSoft-Ltd
#>
function Assert-IsWeekday {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [datetime]
        $Date = (Get-Date)
    )
    
    process {
        -not (Assert-IsWeekend -Date $Date)
    }
}