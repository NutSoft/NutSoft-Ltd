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
        Get-Date 3/5/2021
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
        Get-Date 31/5/2021
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
        Get-Date 30/8/2021
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
        Get-Date 27/12/2021
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
        Get-Date 28/12/2021
    }
}