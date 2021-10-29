Describe "Get-BankHolidays Tests" {

    Context "Bank Holiday collection" {

        It "Bank Holiday collection count should be 8" {
            (Get-BankHolidays).Count | Should -Be 8
        }
    }
}
