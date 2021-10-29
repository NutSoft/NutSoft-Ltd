Describe "Assert-IsWeekday Tests" {
    
    Context "Weekday?" {
        
        It "Thursday 21/10/2021 is a weekday" {
            (Get-Date 21/10/2021) | Assert-IsWeekday | Should -Be $true
        }

        It "Saturday 23/10/2021 is not a weekday" {
            (Get-Date 23/10/2021) | Assert-IsWeekday | Should -Be $false
        }
    }
}
