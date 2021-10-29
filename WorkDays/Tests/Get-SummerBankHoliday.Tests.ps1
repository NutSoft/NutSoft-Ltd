Describe "Get-SummerBankHoliday Tests" {

    Context "UK Public Holidays" {

        Context "2016" {
            
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2016 | Should -Be (Get-Date 29/8/2016)
            }
        }

        Context "2017" {
            
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2017 | Should -Be (Get-Date 28/8/2017)
            }
        }

        Context "2018" {
            
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2018 | Should -Be (Get-Date 27/8/2018)
            }
        }

        Context "2019" {
            
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2019 | Should -Be (Get-Date 26/8/2019)
            }
        }

        Context "2020" {
            
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2020 | Should -Be (Get-Date 31/8/2020)
            }
        }

        Context "2021" {
            
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2021 | Should -Be (Get-Date 30/8/2021)
            }
        }

        Context "2022" {
            
            It "Summer Bank Holiday" {
                Get-SummerBankHoliday -Year 2022 | Should -Be (Get-Date 29/8/2022)
            }
        }
    }
}
