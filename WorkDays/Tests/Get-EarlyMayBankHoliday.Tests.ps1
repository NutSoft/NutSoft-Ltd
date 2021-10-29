Describe "Get-EarlyMayBankHoliday Tests" {

    Context "UK Public Holidays" {

        Context "2016" {
            
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2016 | Should -Be (Get-Date 2/5/2016)
            }
        }

        Context "2017" {
            
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2017 | Should -Be (Get-Date 1/5/2017)
            }
        }

        Context "2018" {
            
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2018 | Should -Be (Get-Date 7/5/2018)
            }
        }

        Context "2019" {
            
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2019 | Should -Be (Get-Date 6/5/2019)
            }
        }

        Context "2020" {
            
            It "Early May Bank Holiday (VE Day)" {
                Get-EarlyMayBankHoliday -Year 2020 | Should -Be (Get-Date 8/5/2020)
            }
        }

        Context "2021" {
            
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2021 | Should -Be (Get-Date 3/5/2021)
            }
        }

        Context "2022" {
            
            It "Early May Bank Holiday" {
                Get-EarlyMayBankHoliday -Year 2022 | Should -Be (Get-Date 2/5/2022)
            }
        }
    }
}
