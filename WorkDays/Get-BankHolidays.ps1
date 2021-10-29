<#
.SYNOPSIS
Gets a collection of bank holidays.

.DESCRIPTION
Gets a collection of bank holidays for the year.

.PARAMETER Year
Specifies the year to get the bank holidays for.

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
function Get-BankHolidays {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        @(
            (Get-NewYearsDay -Year $Year),
            (Get-GoodFriday -Year $Year),
            (Get-EasterMonday -Year $Year),
            (Get-EarlyMayBankHoliday -Year $Year),
            (Get-SpringBankHoliday -Year $Year),
            (Get-SummerBankHoliday -Year $Year),
            (Get-ChristmasDay -Year $Year),
            (Get-BoxingDay -Year $Year)
        )
    }
}

