#Requires -PSEdition Core
$ventlines = Get-Content -Path 'inputs/day5.txt'

function get-VentPoints {
    param (
        [String[]]$ventlines,
        [Switch]$Diags
    )
    foreach ($line in $ventlines) {
        [int]$ax, [int]$ay, [int]$bx, [int]$by = $line -split ' -> ' -join ',' -split ','
        if ((-not $diags) -and $ax -ne $bx -and $ay -ne $by) {
            continue
        } elseif ($diags -and ($ax -eq $bx -or $ay -eq $by)) {
            continue
        }
        "$ax,$ay"
        do {
            if ($ax -ne $bx) { $ax += ($ax -lt $bx) ? 1 : -1 }
            if ($ay -ne $by) { $ay += ($ay -lt $by) ? 1 : -1 }
            "$ax,$ay"
        }
        while ($ax -ne $bx -or $ay -ne $by)
    }
}

$points1 = Get-VentPoints $ventlines
$points2 = $part1points + (Get-VentPoints $ventlines -Diags)
$part1 = ($points1 | Group-Object | Where-Object { $_.Count -gt 1 } | Measure-Object).Count
$part2 = ($points2 | Group-Object | Where-Object { $_.Count -gt 1 } | Measure-Object).Count
"The answer to part 1 is: $part1"
"The answer to part 1 is: $part2"