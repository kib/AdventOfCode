$passwords = Get-Content 'inputs/day2.txt'

foreach ($line in $passwords) {
    $req, $password = $line -split ': '
    $min, $rest = $req -split '-'
    $max, $letter = $rest -split ' '
    $count = ($password.ToCharArray() | Where-Object {$_ -eq $letter} | Measure-Object).Count
    if ($count -ge $min -and $count -le $max) {
        $counter++
    }
}

'The answer to part 1 is: ' + $counter