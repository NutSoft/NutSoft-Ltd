Describe "Get-SpringBankHoliday Tests" {

    Context "UK Public Holidays" {

        Context "2016" {
            
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2016 | Should -Be (Get-Date 30/5/2016)
            }
        }

        Context "2017" {
            
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2017 | Should -Be (Get-Date 29/5/2017)
            }
        }

        Context "2018" {
            
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2018 | Should -Be (Get-Date 28/5/2018)
            }
        }

        Context "2019" {
            
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2019 | Should -Be (Get-Date 27/5/2019)
            }
        }

        Context "2020" {
            
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2020 | Should -Be (Get-Date 25/5/2020)
            }
        }

        Context "2021" {
            
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2021 | Should -Be (Get-Date 31/5/2021)
            }
        }

        Context "2022" {
            
            It "Spring Bank Holiday" {
                Get-SpringBankHoliday -Year 2022 | Should -Be (Get-Date 2/6/2022)
            }
        }
    }
}
