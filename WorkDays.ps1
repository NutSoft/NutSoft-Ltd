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
        $obj = '' |
            Add-Member -PassThru -MemberType NoteProperty   -Name Year  -Value $Year |
            Add-Member -PassThru -MemberType ScriptProperty -Name C7    -Value { $this.Year%19 } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C8    -Value { [System.Math]::Truncate($this.Year/100) } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C9    -Value { $this.Year%100 } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C10   -Value { [System.Math]::Truncate($this.C8/4) } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C11   -Value { $this.C8%4 } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C12   -Value { [System.Math]::Truncate($this.C8+8)/25 } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C13   -Value { [System.Math]::Truncate(($this.C8-$this.C12+1)/3) } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C14   -Value { ((19*$this.C7)+$this.C8-$this.C10-$this.C13+15)%30 } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C15   -Value { [System.Math]::Truncate($this.C9/4) } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C16   -Value { $this.C9%4 } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C17   -Value { (32+2*($this.C11+$this.C15)-$this.C14-$this.C16)%7 } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C18   -Value { [System.Math]::Truncate(($this.C7+(11*$this.C14)+(22*$this.C17))/451) } |
            Add-Member -PassThru -MemberType ScriptProperty -Name Month -Value { [System.Math]::Truncate(($this.C14+$this.C17-(7*$this.C18)+114)/31) } |
            Add-Member -PassThru -MemberType ScriptProperty -Name C20   -Value { ($this.C14+$this.C17-(7*$this.C18)+114)%31 } |
            Add-Member -PassThru -MemberType ScriptProperty -Name Day   -Value { $this.C20+1 }

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