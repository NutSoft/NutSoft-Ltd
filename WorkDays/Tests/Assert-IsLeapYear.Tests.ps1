Describe "Assert-IsLeapYear Tests" {

    Context "Leap Year" {

        It "1900 isn't a Leap Year" {
            Assert-IsLeapYear -Year 1900 | Should -Be $false
        }

        It "2020 is a Leap Year" {
            Assert-IsLeapYear -Year 2020 | Should -Be $true
        }

        It "2021 isn't a Leap Year" {
            Assert-IsLeapYear -Year 2021 | Should -Be $false
        }

        It "2022 isn't a Leap Year" {
            Assert-IsLeapYear -Year 2022 | Should -Be $false
        }

        It "2023 isn't a Leap Year" {
            Assert-IsLeapYear -Year 2023 | Should -Be $false
        }

        It "2024 is a Leap Year" {
            Assert-IsLeapYear -Year 2024 | Should -Be $true
        }

        It "2025 isn't a Leap Year" {
            Assert-IsLeapYear -Year 2025 | Should -Be $false
        }

        It "2028 is a Leap Year" {
            Assert-IsLeapYear -Year 2028 | Should -Be $true
        }

        It "2030 isn't a Leap Year" {
            Assert-IsLeapYear -Year 2030 | Should -Be $false
        }
    }
}
