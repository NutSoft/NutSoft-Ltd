Describe "Get-NewYearsDay Tests" {

    Context "UK Public Holidays" {

        It "New Year's Day 2016" {
            Get-NewYearsDay -Year 2016 | Should -Be (Get-Date 1/1/2016)
        }

        It "New Year's Day 2017" {
            Get-NewYearsDay -Year 2017 | Should -Be (Get-Date 2/1/2017)
        }

        It "New Year's Day 2018" {
            Get-NewYearsDay -Year 2018 | Should -Be (Get-Date 1/1/2018)
        }

        It "New Year's Day 2019" {
            Get-NewYearsDay -Year 2019 | Should -Be (Get-Date 1/1/2019)
        }

        It "New Year's Day 2020" {
            Get-NewYearsDay -Year 2020 | Should -Be (Get-Date 1/1/2020)
        }

        It "New Year's Day 2021" {
            Get-NewYearsDay -Year 2021 | Should -Be (Get-Date 1/1/2021)
        }

        It "New Year's Day 2022" {
            Get-NewYearsDay -Year 2022 | Should -Be (Get-Date 3/1/2022)
        }

        It "New Year's Day 2023" {
            Get-NewYearsDay -Year 2023 | Should -Be (Get-Date 2/1/2023)
        }

        It "New Year's Day 2024" {
            Get-NewYearsDay -Year 2024 | Should -Be (Get-Date 1/1/2024)
        }

        It "New Year's Day 2025" {
            Get-NewYearsDay -Year 2025 | Should -Be (Get-Date 1/1/2025)
        }

        It "New Year's Day 2026" {
            Get-NewYearsDay -Year 2026 | Should -Be (Get-Date 1/1/2026)
        }

        It "New Year's Day 2027" {
            Get-NewYearsDay -Year 2027 | Should -Be (Get-Date 1/1/2027)
        }

        It "New Year's Day 2028" {
            Get-NewYearsDay -Year 2028 | Should -Be (Get-Date 3/1/2028)
        }

        It "New Year's Day 2029" {
            Get-NewYearsDay -Year 2029 | Should -Be (Get-Date 1/1/2029)
        }

        It "New Year's Day 2030" {
            Get-NewYearsDay -Year 2030 | Should -Be (Get-Date 1/1/2030)
        }
    }
}
