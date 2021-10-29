Describe "Get-DaysInMonth Tests" {

    Context "Days in month" {

        It "31 days in March" {
            (Get-DaysInMonth -Month "March").Count | Should -Be 31
        }

        It "23 weekdays in March 2021" {
            (Get-DaysInMonth -Year 2021 -Month "March" -Weekdays).Count | Should -Be 23
        }

        It "28 days in February 2021" {
            (Get-DaysInMonth -Year 2021 -Month "February").Count | Should -Be 28
        }

        It "29 days in February 2020" {
            (Get-DaysInMonth -Year 2020 -Month "February").Count | Should -Be 29
        }
    }
}