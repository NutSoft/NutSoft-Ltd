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

