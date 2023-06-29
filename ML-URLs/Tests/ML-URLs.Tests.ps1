. .\ML-URLs.ps1

Describe "ML URL Tests" {

    Context "ML URLs" {

        It "URL should be returned" {
            (Get-MLURLCollection -URL "http://sites.domain.net/sites/site/list").Count | Should -BeGreaterThan 0
        }

        It "http://sites.domain.net/sites/site/list" {
            (Get-MLURLCollection -URL "http://sites.domain.net/sites/site/list").Path | Should -Be "/http:%2F%2Fsites.domain.net%2Fsites%2Fsite/list"
        }

        It "http://sites.domain.net/sites/site/area/plan" {
            (Get-MLURLCollection -URL "http://sites.domain.net/sites/site/area/plan").Path | Should -Be "/http:%2F%2Fsites.domain.net%2Fsites%2Fsite/area/plan"
        }

        It "http://sites.domain.net/sites/site/area/Lists/Calendar" {
            (Get-MLURLCollection -URL "http://sites.domain.net/sites/site/area/Lists/Calendar").Path | Should -Be "/http:%2F%2Fsites.domain.net%2Fsites%2Fsite/area/Calendar"
        }

        It "http://sites.domain.net/SiteCollectionImages" {
            (Get-MLURLCollection -URL "http://sites.domain.net/SiteCollectionImages").Path | Should -Be "/http:%2F%2Fsites.domain.net/SiteCollectionImages"
        }
    }
}

