# part 2
$puzzle = Get-Content -Path 'inputs/day4.txt'

$callline, $boardlines = $puzzle -split "`n`n"
[int[]]$calls = $callline -split ','
[int[]]$nums = $boardlines -split ' ' | Where-Object { $_ }

[Collections.Generic.List[PSObject]]$boards = @()
$boardsolved = @{}

# Read all boards and create them as nested hastables
for ($i = 0; $i -lt $nums.Count / 25; $i++) {
    [Collections.Generic.List[PSObject]]$board = @()
    for ($j = 0; $j -lt 5; $j++) {
        $line = @{}
        for ($k = 0; $k -lt 5; $k++) {
            $index = $i * 25 + $j * 5 + $k
            $line.Add($nums[$index], 0)
        }
        $board.Add($line)
    }
    for ($l = 0; $l -lt 5; $l++) {
        $line = @{}
        for ($m = 0; $m -lt 25; $m += 5) {
            $index = $i * 25 + $l + $m
            $line.Add($nums[$index], 0)
        }
        $board.Add($line)
    }
    $boards.Add($board)
    $boardsolved[$i] = $false
}

# Mark the called number and break on winner
foreach ($call in $calls) {
    for ($i = 0; $i -lt $boards.Count; $i++) {
        $num = $boards.Count - ($boardsolved.getEnumerator() | Where-Object { $_.Value }).Count
        if (-not $boardsolved[$i] -and $num -gt 0) {
            for ($j = 0; $j -lt $boards[$i].Count; $j++) {
                if ($boards[$i][$j].Contains($call)) {
                    $boards[$i][$j][$call] = 1
                    if (($boards[$i][$j].Values | Measure-Object -Sum).Sum -eq 5) {
                        $boardsolved[$i] = $true
                        $lastcall = $call
                        $lastboard = $i
                    }
                }
            }
        }
    }
}

# Find the magic number
$sum = 0
for ($m = 0; $m -lt 5; $m++) {
    $boards[$lastboard][$m].GetEnumerator() | Where-Object { $_.Value -eq 0 } | Foreach-Object { $sum = $sum + $_.Key }
}
'The answer to part 2 is: ' + $sum * $lastcall