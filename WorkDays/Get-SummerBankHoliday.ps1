<#
.SYNOPSIS
Determines if the year is a leap year.

.DESCRIPTION
Determines if the year is a leap year.

.PARAMETER Year
Specifies the year to test.

.PARAMETER Extension
Specifies the extension. "Txt" is the default.

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

.LINK
https://github.com/NutSoft/NutSoft-Ltd

#>
function Get-SummerBankHoliday {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        $day = Get-Date "$Year/8/31"
        while ($day.DayOfWeek -match 'Sunday|Tuesday|Wednesday|Thursday|Friday|Saturday') {
            $day = $day.AddDays(-1)
        }
        $day
    }
}

