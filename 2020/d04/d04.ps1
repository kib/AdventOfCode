$passport = (Get-Content -Path './inputs/day4.txt' -Raw) -split '\r?\n\r?\n' -replace '\r?\n', ' '

$byr = 'byr:'
$iyr = 'iyr:'
$eyr = 'eyr:'
$hgt = 'hgt:'
$hcl = 'hcl:'
$ecl = 'ecl:'
$passid = 'pid:'

$correct = foreach ($pass in $passport) {
    if (([regex]::matches($pass, "$byr|$iyr|$eyr|$hgt|$hcl|$ecl|$passid")).Count -eq 7) {
        $pass
    }
}

'The answer to part 1 is: ' + $correct.Count

# this would have been múch harder without a regex numeric range creator (https://3widgets.com/) and https://regexr.com
$byr = 'byr:(192\d|19[3-9]\d|20[01]\d|2020)\s'
$iyr = 'iyr:(201\d|2020)\s'
$eyr = 'eyr:(202\d|2030)\s'
$hgt = 'hgt:((15\d|1[6-8]\d|19[0-3])cm)|((59|6\d|7[0-6])in)'
$hcl = 'hcl:#([a-f\d]{6})\s'
$ecl = 'ecl:(amb|blu|brn|gry|grn|hzl|oth)\s'
$passid = 'pid:\d{9}\s'

$correct = foreach ($pass in $passport) {
    if (([regex]::matches($pass + ' ', "$byr|$iyr|$eyr|$hgt|$hcl|$ecl|$passid")).Count -eq 7) {
        $pass
    }
}

'The answer to part 2 is: ' + $correct.Count