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
        (Get-EasterSunday -Year $Year).AddDays(-2)
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
        $obj = '' |
        Add-Member -PassThru -MemberType NoteProperty   -Name Year  -Value $Year |
        Add-Member -PassThru -MemberType ScriptProperty -Name C7    -Value { $this.Year % 19 } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C8    -Value { [System.Math]::Truncate($this.Year / 100) } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C9    -Value { $this.Year % 100 } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C10   -Value { [System.Math]::Truncate($this.C8 / 4) } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C11   -Value { $this.C8 % 4 } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C12   -Value { [System.Math]::Truncate($this.C8 + 8) / 25 } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C13   -Value { [System.Math]::Truncate(($this.C8 - $this.C12 + 1) / 3) } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C14   -Value { ((19 * $this.C7) + $this.C8 - $this.C10 - $this.C13 + 15) % 30 } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C15   -Value { [System.Math]::Truncate($this.C9 / 4) } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C16   -Value { $this.C9 % 4 } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C17   -Value { (32 + 2 * ($this.C11 + $this.C15) - $this.C14 - $this.C16) % 7 } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C18   -Value { [System.Math]::Truncate(($this.C7 + (11 * $this.C14) + (22 * $this.C17)) / 451) } |
        Add-Member -PassThru -MemberType ScriptProperty -Name Month -Value { [System.Math]::Truncate(($this.C14 + $this.C17 - (7 * $this.C18) + 114) / 31) } |
        Add-Member -PassThru -MemberType ScriptProperty -Name C20   -Value { ($this.C14 + $this.C17 - (7 * $this.C18) + 114) % 31 } |
        Add-Member -PassThru -MemberType ScriptProperty -Name Day   -Value { $this.C20 + 1 }

        Get-Date ("{0}/{1}/{2}" -f $obj.Year, $obj.Month, $obj.Day)
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
        (Get-EasterSunday -Year $Year).AddDays(1)
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
