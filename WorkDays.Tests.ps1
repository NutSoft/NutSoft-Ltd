BeforeAll {
    . $PSScriptRoot/WorkDays.ps1
}

Describe "WorkDays" {
    Context "Weekend or Weekday?" {
        It "Thursday 21/10/2021 is a weekday" {
            (Get-Date 21/10/2021) | Assert-IsWeekday | Should -Be $true
        }
        It "Thursday 21/10/2021 is not a weekend" {
            (Get-Date 21/10/2021) | Assert-IsWeekend | Should -Be $false
        }
        It "Saturday 23/10/2021 is a weekday" {
            (Get-Date 23/10/2021) | Assert-IsWeekday | Should -Be $false
        }
        It "Saturday 23/10/2021 is not a weekend" {
            (Get-Date 23/10/2021) | Assert-IsWeekend | Should -Be $true
        }
    }
    Context "UK Public Holidays" {
        Context "2020" {
            It "New Year's Day 2020" {
                Get-NewYearsDay -Year 2020 | Should -Be (Get-Date 1/1/2020)
            }
            It "Good Friday" {
                Get-GoodFriday -Year 2020 | Should -Be (Get-Date 10/4/2020)
            }
            It "Easter Sunday" {
                Get-EasterSunday -Year 2020 | Should -Be (Get-Date 12/4/2020)
            }
            It "Easter Monday" {
                Get-EasterMonday -Year 2020 | Should -Be (Get-Date 13/4/2020)
            }
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2020 | Should -Be (Get-Date 8/5/2020)
            }
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2020 | Should -Be (Get-Date 25/5/2020)
            }
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2020 | Should -Be (Get-Date 31/8/2020)
            }
            It "Christmas Day" {
                Get-ChristmasDay -Year 2020 | Should -Be (Get-Date 25/12/2020)
            }
            It "Boxing Day" {
                Get-BoxingDay -Year 2020 | Should -Be (Get-Date 28/12/2020)
            }
        }
        Context "2021" {
            It "New Year's Day 2021" {
                Get-NewYearsDay -Year 2021 | Should -Be (Get-Date 1/1/2021)
            }
            It "Good Friday" {
                Get-GoodFriday -Year 2021 | Should -Be (Get-Date 2/4/2021)
            }
            It "Easter Sunday" {
                Get-EasterSunday -Year 2021 | Should -Be (Get-Date 4/4/2021)
            }
            It "Easter Monday" {
                Get-EasterMonday -Year 2021 | Should -Be (Get-Date 5/4/2021)
            }
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2021 | Should -Be (Get-Date 3/5/2021)
            }
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2021 | Should -Be (Get-Date 31/5/2021)
            }
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2021 | Should -Be (Get-Date 30/8/2021)
            }
            It "Christmas Day" {
                Get-ChristmasDay -Year 2021 | Should -Be (Get-Date 27/12/2021)
            }
            It "Boxing Day" {
                Get-BoxingDay -Year 2021 | Should -Be (Get-Date 28/12/2021)
            }
        }
        Context "2022" {
            It "New Year's Day 2022" {
                Get-NewYearsDay -Year 2022 | Should -Be (Get-Date 3/1/2022)
            }
            It "Good Friday" {
                Get-GoodFriday -Year 2022 | Should -Be (Get-Date 15/4/2022)
            }
            It "Easter Sunday" {
                Get-EasterSunday -Year 2022 | Should -Be (Get-Date 17/4/2022)
            }
            It "Easter Monday" {
                Get-EasterMonday -Year 2022 | Should -Be (Get-Date 18/4/2022)
            }
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2022 | Should -Be (Get-Date 2/5/2022)
            }
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2022 | Should -Be (Get-Date 2/6/2022)
            }
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2022 | Should -Be (Get-Date 29/8/2022)
            }
            It "Christmas Day" {
                Get-ChristmasDay -Year 2022 | Should -Be (Get-Date 26/12/2022)
            }
            It "Boxing Day" {
                Get-BoxingDay -Year 2022 | Should -Be (Get-Date 27/12/2022)
            }
        }
    }
}
