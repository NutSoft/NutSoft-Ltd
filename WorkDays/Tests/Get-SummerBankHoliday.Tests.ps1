Describe "Get-SummerBankHoliday Tests" {

    Context "UK Public Holidays" {

        It "Summer Bank Holiday 2016" {
            Get-SummerBankHoliday -Year 2016 | Should -Be (Get-Date 29/8/2016)
        }

        It "Summer Bank Holiday 2017" {
            Get-SummerBankHoliday -Year 2017 | Should -Be (Get-Date 28/8/2017)
        }

        It "Summer Bank Holiday 2018" {
            Get-SummerBankHoliday -Year 2018 | Should -Be (Get-Date 27/8/2018)
        }

        It "Summer Bank Holiday 2019" {
            Get-SummerBankHoliday -Year 2019 | Should -Be (Get-Date 26/8/2019)
        }

        It "Summer Bank Holiday 2020" {
            Get-SummerBankHoliday -Year 2020 | Should -Be (Get-Date 31/8/2020)
        }

        It "Summer Bank Holiday 2021" {
            Get-SummerBankHoliday -Year 2021 | Should -Be (Get-Date 30/8/2021)
        }

        It "Summer Bank Holiday 2022" {
            Get-SummerBankHoliday -Year 2022 | Should -Be (Get-Date 29/8/2022)
        }
    }
}
