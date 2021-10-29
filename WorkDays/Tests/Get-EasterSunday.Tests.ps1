Describe "Get-EasterSunday Tests" {

    Context "UK Public Holidays" {

        Context "2016" {
            
            It "Easter Sunday" {
                Get-EasterSunday -Year 2016 | Should -Be (Get-Date 27/3/2016)
            }
        }

        Context "2017" {
            
            It "Easter Sunday" {
                Get-EasterSunday -Year 2017 | Should -Be (Get-Date 16/4/2017)
            }
        }

        Context "2018" {
            
            It "Easter Sunday" {
                Get-EasterSunday -Year 2018 | Should -Be (Get-Date 1/4/2018)
            }
        }

        Context "2019" {
            
            It "Easter Sunday" {
                Get-EasterSunday -Year 2019 | Should -Be (Get-Date 21/4/2019)
            }
        }

        Context "2020" {
            
            It "Easter Sunday" {
                Get-EasterSunday -Year 2020 | Should -Be (Get-Date 12/4/2020)
            }
        }

        Context "2021" {
            
            It "Easter Sunday" {
                Get-EasterSunday -Year 2021 | Should -Be (Get-Date 4/4/2021)
            }
        }

        Context "2022" {
            
            It "Easter Sunday" {
                Get-EasterSunday -Year 2022 | Should -Be (Get-Date 17/4/2022)
            }
        }
    }
}
