Describe "Get-ChristmasDay Tests" {

    Context "UK Public Holidays" {

        It "Christmas Day 2016" {
            Get-ChristmasDay -Year 2016 | Should -Be (Get-Date 26/12/2016)
        }

        It "Christmas Day 2017" {
            Get-ChristmasDay -Year 2017 | Should -Be (Get-Date 25/12/2017)
        }

        It "Christmas Day 2018" {
            Get-ChristmasDay -Year 2018 | Should -Be (Get-Date 25/12/2018)
        }

        It "Christmas Day 2019" {
            Get-ChristmasDay -Year 2019 | Should -Be (Get-Date 25/12/2019)
        }

        It "Christmas Day 2020" {
            Get-ChristmasDay -Year 2020 | Should -Be (Get-Date 25/12/2020)
        }

        It "Christmas Day 2021" {
            Get-ChristmasDay -Year 2021 | Should -Be (Get-Date 27/12/2021)
        }

        It "Christmas Day 2022" {
            Get-ChristmasDay -Year 2022 | Should -Be (Get-Date 26/12/2022)
        }
    }
}
