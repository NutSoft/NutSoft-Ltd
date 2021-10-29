Describe "Get-GoodFriday Tests" {

    Context "UK Public Holidays" {

        It "Good Friday 2016" {
            Get-GoodFriday -Year 2016 | Should -Be (Get-Date 25/3/2016)
        }

        It "Good Friday 2017" {
            Get-GoodFriday -Year 2017 | Should -Be (Get-Date 14/4/2017)
        }

        It "Good Friday 2018" {
            Get-GoodFriday -Year 2018 | Should -Be (Get-Date 30/3/2018)
        }

        It "Good Friday 2019" {
            Get-GoodFriday -Year 2019 | Should -Be (Get-Date 19/4/2019)
        }

        It "Good Friday 2020" {
            Get-GoodFriday -Year 2020 | Should -Be (Get-Date 10/4/2020)
        }

        It "Good Friday 2021" {
            Get-GoodFriday -Year 2021 | Should -Be (Get-Date 2/4/2021)
        }

        It "Good Friday 2022" {
            Get-GoodFriday -Year 2022 | Should -Be (Get-Date 15/4/2022)
        }
    }
}
