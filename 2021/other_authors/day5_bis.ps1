# credits to https://www.reddit.com/user/bis/
# through https://www.reddit.com/r/PowerShell/comments/r99a9i/advent_of_code_2021_day_5_hydrothermal_venture/
#
# This script takes input from clipboard, so make sure the correct input for day5 is there

$1 = [System.Collections.Generic.Dictionary[int, int]]::new(1000)
$2 = [System.Collections.Generic.Dictionary[int, int]]::new(1000)
Get-Clipboard | ForEach-Object {
    $x1, $y1, $x2, $y2 = $_ -split '\D+' -as [int[]]
    $x = $x1..$x2
    $y = $y1..$y2
    $c = $x.Count
    if ($y1 -eq $y2) {
        $x | ForEach-Object { $1[$_ * 1000 + $y1]++ }
        $y *= $c
    }
    elseif ($x1 -eq $x2) {
        $y | ForEach-Object { $1[$x1 * 1000 + $_]++ }
        $c = $y.Count
        $x *= $c
    }
    0..($c - 1) | ForEach-Object { $2[$x[$_] * 1000 - $y[$_]]++ }
}
($1.Values -gt 1).Count
($2.Values -gt 1).Count