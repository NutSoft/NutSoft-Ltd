Describe "Assert-IsWeekend Tests" {

    Context "Weekend?" {

        It "Thursday 21/10/2021 is not a weekend" {
            (Get-Date 21/10/2021) | Assert-IsWeekend | Should -Be $false
        }

        It "Saturday 23/10/2021 is a weekend" {
            (Get-Date 23/10/2021) | Assert-IsWeekend | Should -Be $true
        }
    }
}
