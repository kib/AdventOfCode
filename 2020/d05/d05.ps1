$bps = Get-Content -Path './inputs/day5.txt'

$IDs = foreach ($bp in $bps) {
    $row = [Convert]::toInt32(($bp.subString(0, 7) -replace 'F', '0' -replace 'B', '1'), 2)
    $seat = [Convert]::ToInt32(($bp.subString(7, 3) -replace 'L', '0' -replace 'R', '1'), 2)
    $row * 8 + $seat
}

$max = $IDs | Sort-Object | Select-Object -Last 1
"The answer to part 1 is: $max"

$started = $false
$previous = 0
$IDs | Sort-Object | Foreach-Object {
    if (-not $started) {
        $started = $True
    }
    elseif ($_ -ne $previous + 1) {
        'The answer to part 2 is: ' + ($previous + 1)
        break
    }
    $previous = $_
}