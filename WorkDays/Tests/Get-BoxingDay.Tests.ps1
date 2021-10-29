Describe "Get-BoxingDay Tests" {

    Context "UK Public Holidays" {

        Context "2016" {

            It "Boxing Day" {
                Get-BoxingDay -Year 2016 | Should -Be (Get-Date 27/12/2016)
            }
        }

        Context "2017" {

            It "Boxing Day" {
                Get-BoxingDay -Year 2017 | Should -Be (Get-Date 26/12/2017)
            }
        }

        Context "2018" {
            
            It "Boxing Day" {
                Get-BoxingDay -Year 2018 | Should -Be (Get-Date 26/12/2018)
            }
        }
        
        Context "2019" {
            
            It "Boxing Day" {
                Get-BoxingDay -Year 2019 | Should -Be (Get-Date 26/12/2019)
            }
        }

        Context "2020" {
            
            It "Boxing Day" {
                Get-BoxingDay -Year 2020 | Should -Be (Get-Date 28/12/2020)
            }
        }

        Context "2021" {
            
            It "Boxing Day" {
                Get-BoxingDay -Year 2021 | Should -Be (Get-Date 28/12/2021)
            }
        }

        Context "2022" {
            
            It "Boxing Day" {
                Get-BoxingDay -Year 2022 | Should -Be (Get-Date 27/12/2022)
            }
        }
    }
}