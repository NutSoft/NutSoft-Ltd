Describe "Get-EasterMonday Tests" {

    Context "UK Public Holidays" {

        Context "2016" {
            
            It "Easter Monday" {
                Get-EasterMonday -Year 2016 | Should -Be (Get-Date 28/3/2016)
            }
        }

        Context "2017" {
            
            It "Easter Monday" {
                Get-EasterMonday -Year 2017 | Should -Be (Get-Date 17/4/2017)
            }
        }

        Context "2018" {
            
            It "Easter Monday" {
                Get-EasterMonday -Year 2018 | Should -Be (Get-Date 2/4/2018)
            }
        }
        Context "2019" {
            
            It "Easter Monday" {
                Get-EasterMonday -Year 2019 | Should -Be (Get-Date 22/4/2019)
            }
        }
        Context "2020" {
            
            It "Easter Monday" {
                Get-EasterMonday -Year 2020 | Should -Be (Get-Date 13/4/2020)
            }
        }
        Context "2021" {
            
            It "Easter Monday" {
                Get-EasterMonday -Year 2021 | Should -Be (Get-Date 5/4/2021)
            }
        }
        Context "2022" {
            
            It "Easter Monday" {
                Get-EasterMonday -Year 2022 | Should -Be (Get-Date 18/4/2022)
            }
        }
    }
}
