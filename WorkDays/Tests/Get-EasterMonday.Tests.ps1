Describe "Get-EasterMonday Tests" {

    Context "UK Public Holidays" {

        It "Easter Monday 2016" {
            Get-EasterMonday -Year 2016 | Should -Be (Get-Date 28/3/2016)
        }

        It "Easter Monday 2017" {
            Get-EasterMonday -Year 2017 | Should -Be (Get-Date 17/4/2017)
        }

        It "Easter Monday 2018" {
            Get-EasterMonday -Year 2018 | Should -Be (Get-Date 2/4/2018)
        }
        It "Easter Monday 2019" {
            Get-EasterMonday -Year 2019 | Should -Be (Get-Date 22/4/2019)
        }
        It "Easter Monday 2020" {
            Get-EasterMonday -Year 2020 | Should -Be (Get-Date 13/4/2020)
        }
        It "Easter Monday 2021" {
            Get-EasterMonday -Year 2021 | Should -Be (Get-Date 5/4/2021)
        }
        It "Easter Monday 2022" {
            Get-EasterMonday -Year 2022 | Should -Be (Get-Date 18/4/2022)
        }
    }
}
