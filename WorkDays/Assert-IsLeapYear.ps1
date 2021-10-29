<#
.SYNOPSIS
Determines if the year is a leap year.

.DESCRIPTION
Determines if the year is a leap year.

.PARAMETER Year
Specifies the year to test.

.INPUTS
Only accepts integers as per the named parameter "Year".

.OUTPUTS
System.Boolean. Assert-IsLeapYear returns True if the year is a leap year.

.EXAMPLE
PS> Assert-IsLeapYear -Year 2012
True

.EXAMPLE
PS> Assert-IsLeapYear -Year 2015
False

.EXAMPLE
PS> 2012..2020 | Assert-IsLeapYear
True,False,False,False,True,False,False,False,True

.NOTES
(c) Des Finkenzeller, NutSoft Ltd. All rights reserved.

.LINK
https://github.com/NutSoft/NutSoft-Ltd
#>
function Assert-IsLeapYear {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        ((Get-Date -Year $Year -Month 2 -Day 29).Month -eq 2)
    }
}