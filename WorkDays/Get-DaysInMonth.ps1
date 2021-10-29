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
function Get-DaysInMonth {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateSet("January","February","March","April","May","June","July","August","September","October","November","December")]
        [string]
        $Month = $((Get-Culture).DateTimeFormat.GetMonthName((Get-Date).Month)),
        [int]
        $Year = (Get-Date).Year,
        [switch]
        $Weekdays
    )

    process {
        $monthNumber = [datetime]::ParseExact($Month, "MMMM", [Globalization.CultureInfo]::CurrentCulture).Month
        $days = [datetime]::DaysInMonth($Year, $monthNumber)
        $start = (Get-Date ("{0}/{1}/1" -f $Year, $monthNumber))
        $end = $start.AddDays($days)
        if ($PSBoundParameters.ContainsKey("Weekdays")) {
            Get-DaysBetweenTwoDates -Start $start -End $end -Weekdays
        } else {
            Get-DaysBetweenTwoDates -Start $start -End $end
        }
        
    }
}
