Describe "Get-NextNamedDay Tests" {

    Context "Next Named Day" {
        It "Today" {
            (Get-NextNamedDay -DayOfWeek (Get-Date).DayOfWeek).Day - (Get-Date).Day | Should -Be 0
        }

        It "Sunday" {
            (Get-NextNamedDay -DayOfWeek Sunday).DayOfWeek | Should -Be "Sunday"
        }

        It "Monday" {
            (Get-NextNamedDay -DayOfWeek Monday).DayOfWeek | Should -Be "Monday"
        }

        It "Tuesday" {
            (Get-NextNamedDay -DayOfWeek Tuesday).DayOfWeek | Should -Be "Tuesday"
        }

        It "Wednesday" {
            (Get-NextNamedDay -DayOfWeek Wednesday).DayOfWeek | Should -Be "Wednesday"
        }

        It "Thursday" {
            (Get-NextNamedDay -DayOfWeek Thursday).DayOfWeek | Should -Be "Thursday"
        }

        It "Friday" {
            (Get-NextNamedDay -DayOfWeek Friday).DayOfWeek | Should -Be "Friday"
        }

        It "Saturday" {
            (Get-NextNamedDay -DayOfWeek Saturday).DayOfWeek | Should -Be "Saturday"
        }
    }
}