Describe "Get-SpringBankHoliday Tests" {

    Context "UK Public Holidays" {

        It "Spring Bank Holiday 2016" {
            Get-SpringBankHoliday -Year 2016 | Should -Be (Get-Date 30/5/2016)
        }

        It "Spring Bank Holiday 2017" {
            Get-SpringBankHoliday -Year 2017 | Should -Be (Get-Date 29/5/2017)
        }

        It "Spring Bank Holiday 2018" {
            Get-SpringBankHoliday -Year 2018 | Should -Be (Get-Date 28/5/2018)
        }

        It "Spring Bank Holiday 2019" {
            Get-SpringBankHoliday -Year 2019 | Should -Be (Get-Date 27/5/2019)
        }

        It "Spring Bank Holiday 2020" {
            Get-SpringBankHoliday -Year 2020 | Should -Be (Get-Date 25/5/2020)
        }

        It "Spring Bank Holiday 2021" {
            Get-SpringBankHoliday -Year 2021 | Should -Be (Get-Date 31/5/2021)
        }

        It "Spring Bank Holiday 2022" {
            Get-SpringBankHoliday -Year 2022 | Should -Be (Get-Date 2/6/2022)
        }
    }
}
