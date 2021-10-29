<#
.SYNOPSIS
Gets the date of the Boxing Day bank holidays.

.DESCRIPTION
Gets the date of the Boxing Day bank holidays allowing for weekends.

.PARAMETER Year
Specifies the year to get the bank holidays for.

.INPUTS
Only accepts datetime as per the named parameter "Date".

.OUTPUTS
System.DateTime. Get-BoxingDay returns a DateTime object corresponding to the Boxing Day bank holiday for the specified year.

.EXAMPLE
PS> Get-BoxingDay

28 December 2021 00:00:00

Description
-----------
Returns a DateTime object corresponding to the Boxing Day bank holiday for the current year.

.EXAMPLE
PS> Get-BoxingDay -Year 2022

27 December 2022 00:00:00

Description
-----------
Returns a DateTime object corresponding to the Boxing Day bank holiday for 2022.

.NOTES
(c) Des Finkenzeller, NutSoft Ltd. All rights reserved.

.LINK
https://github.com/NutSoft/NutSoft-Ltd
#>
function Get-BoxingDay {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        $day = (Get-ChristmasDay -Year $Year).AddDays(1)
        while (Assert-IsWeekend -Date $day) {
            $day = $day.AddDays(1)
        }
        $day
    }
}

