$groups = ((Get-Content -Path './inputs/day6.txt' -Raw) -split "\r?\n\r?\n") | % { $_ -split '\r?\n' -join ''}
$sum = 0
foreach ($group in $groups) {
    $sum += (($group.toCharArray() | Sort-Object | Get-Unique) -join '').Length
}
"The answer to part 1 is: $sum"

