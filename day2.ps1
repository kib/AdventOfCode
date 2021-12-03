$commands = Get-Content '.\inputs\day2.txt'
$pos = 0
$depth= 0

# part 1
foreach ($line in $commands) {
    $command, [int]$value = $line -split ' '
    switch ($command) {
        'forward' { $pos += $value }
        'down' { $depth += $value }
        'up' { $depth -= $value }
    }
}

'The answer to part 1 is: ' + $pos*$depth

# part 2 - reset counters
$pos = 0
$depth= 0
$aim =0

foreach ($line in $commands) {
    $command, [int]$value = $line -split ' '
    switch ($command) {
        'down' { $aim += $value }
        'up' { $aim -= $value }
        'forward' {
            $pos += $value
            $depth += ($aim*$value)
        }
    }
}

'The answer to part 2 is: ' + $pos*$depth