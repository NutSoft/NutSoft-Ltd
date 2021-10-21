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

function Get-NewYearsDay {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        $newYearsDay = Get-Date "$Year/1/1"
        while (Assert-IsWeekend -Date $newYearsDay) {
            $newYearsDay = $newYearsDay.AddDays(1)
        }
        $newYearsDay
    }
}

function Get-GoodFriday {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        Get-Date 2/4/2021
    }
}

function Get-EasterSunday {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        Get-Date 4/4/2021
    }
}

function Get-EasterMonday {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        Get-Date 5/4/2021
    }
}

function Get-EarlyMayBankHoliday {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        switch ($Year) {
            2020 {
                $day = Get-Date 2020/5/8
            }
            Default {
                $day = Get-Date "$Year/5/1"
                while ($day.DayOfWeek -match 'Sunday|Tuesday|Wednesday|Thursday|Friday|Saturday') {
                    $day = $day.AddDays(1)
                }
            }
        }

        $day
    }
}

function Get-SpringBankHoliday {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        switch ($Year) {
            2022 {
                $day = Get-Date 2022/6/2
            }
            Default {
                $day = Get-Date "$Year/5/31"
                while ($day.DayOfWeek -match 'Sunday|Tuesday|Wednesday|Thursday|Friday|Saturday') {
                    $day = $day.AddDays(-1)
                }
            }
        }
        
        $day
    }
}

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

function Get-ChristmasDay {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [int]
        $Year = (Get-Date).Year
    )

    process {
        $day = Get-Date "$Year/12/25"
        while (Assert-IsWeekend -Date $day) {
            $day = $day.AddDays(1)
        }
        $day
    }
}

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