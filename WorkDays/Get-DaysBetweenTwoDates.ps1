<#
.SYNOPSIS
Gets a collection of days between two dates.

.DESCRIPTION
Gets a collection of days between two dates considering bank holidays and weekends.

.PARAMETER Start
Specifies the start date of the period.

.PARAMETER End
Specifies the end date of the period.

.PARAMETER Weekdays
If supplied, this switch forces the return of weekdays not including bank holidays.

.INPUTS
Only accepts datetime as per the named parameter "Date".

.OUTPUTS
System.DateTime. Get-BankHolidays returns a collection of DateTime objects for the specified year.

.EXAMPLE
PS> Get-BankHolidays

01 January 2021 00:00:00
02 April 2021 00:00:00
05 April 2021 00:00:00
03 May 2021 00:00:00
31 May 2021 00:00:00
30 August 2021 00:00:00
27 December 2021 00:00:00
28 December 2021 00:00:00

Description
-----------
Returns a collection of DateTime objects that represent the bank holidays for the current year.

.EXAMPLE
PS> Get-BankHolidays -Year 2022

03 January 2022 00:00:00
15 April 2022 00:00:00
18 April 2022 00:00:00
02 May 2022 00:00:00
02 June 2022 00:00:00
29 August 2022 00:00:00
26 December 2022 00:00:00
27 December 2022 00:00:00

Description
-----------
Returns a collection of DateTime objects that represent the bank holidays for 2022.

.NOTES
(c) Des Finkenzeller, NutSoft Ltd. All rights reserved.

.LINK
https://github.com/NutSoft/NutSoft-Ltd
#>
function Get-DaysBetweenTwoDates {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false
        )]
        [datetime]
        $Start = (Get-Date),
        [Parameter(
            Mandatory = $false
        )]
        [ValidateScript({
                if ($_ -lt $Start) {
                    throw "End date must be after start date: $Start"
                }
                else {
                    $true
                }
            })]
        [datetime]
        $End = (Get-Date),
        [switch]
        $Weekdays
    )

    if ($End.Year -gt $Start.Year) {
        $bankHolidays = ($Start.Year)..($End.Year) | Get-BankHolidays
    }
    else {
        $bankHolidays = Get-BankHolidays -Year $Start.Year
    }

    $day = $Start
    $(
        do {
            $day
            $day = $day.AddDays(1)
        } while ($day -lt $End)
    ) |
    Where-Object { -not ($_.DayOfWeek -match 'Saturday|Sunday' -and $PSBoundParameters.ContainsKey('Weekdays')) } |
    Where-Object { -not ($bankHolidays -contains $_ -and $PSBoundParameters.ContainsKey('Weekdays')) }
}

