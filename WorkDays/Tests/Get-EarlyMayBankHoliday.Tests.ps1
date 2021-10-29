Describe "Get-EarlyMayBankHoliday Tests" {

    Context "UK Public Holidays" {

        It "Early May Bank Holiday 2016" {
            Get-EarlyMayBankHoliday -Year 2016 | Should -Be (Get-Date 2/5/2016)
        }

        It "Early May Bank Holiday 2017" {
            Get-EarlyMayBankHoliday -Year 2017 | Should -Be (Get-Date 1/5/2017)
        }

        It "Early May Bank Holiday 2018" {
            Get-EarlyMayBankHoliday -Year 2018 | Should -Be (Get-Date 7/5/2018)
        }

        It "Early May Bank Holiday 2019" {
            Get-EarlyMayBankHoliday -Year 2019 | Should -Be (Get-Date 6/5/2019)
        }

        It "Early May Bank Holiday (VE Day) 2020" {
            Get-EarlyMayBankHoliday -Year 2020 | Should -Be (Get-Date 8/5/2020)
        }

        It "Early May Bank Holiday 2021" {
            Get-EarlyMayBankHoliday -Year 2021 | Should -Be (Get-Date 3/5/2021)
        }

        It "Early May Bank Holiday 2022" {
            Get-EarlyMayBankHoliday -Year 2022 | Should -Be (Get-Date 2/5/2022)
        }
    }
}
