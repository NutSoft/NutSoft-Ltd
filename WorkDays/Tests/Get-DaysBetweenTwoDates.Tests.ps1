Describe "Get-DaysBetweenTwoDates Tests" {

    Context "Days Between Two Dates" {

        It "21 weekdays between 2017/09/01 and 2017/09/30" {
            (Get-DaysBetweenTwoDates -Start 2017/09/01 -End 2017/09/30 -Weekdays).Count | Should -Be 21
        }

        It "2,922 days between 1966/03/22 and 1974/03/22" {
            (Get-DaysBetweenTwoDates -Start 1966/03/22 -End 1974/03/22).Count | Should -Be 2922
        }
        
        It "373 days between 1966/03/22 and 1967/03/30" {
            (Get-DaysBetweenTwoDates -Start 1966/03/22 -End 1967/03/30).Count | Should -Be 373
        }
    }
}
