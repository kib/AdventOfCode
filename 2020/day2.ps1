$passwords = Get-Content 'inputs/day2.txt'

foreach ($line in $passwords) {
    $req, $password = $line -split ': '
    $a, $rest = $req -split '-'
    $b, $letter = $rest -split ' '
    $count = ($password.ToCharArray() | Where-Object { $_ -eq $letter } | Measure-Object).Count
    if ($count -ge $a -and $count -le $b) {
        $part1++
    }
    if ($password[$a - 1] -eq $letter -xor $password[$b - 1] -eq $letter) {
        $part2++
    }
}

'The answer to part 1 is: ' + $part1
'The answer to part 2 is: ' + $part2