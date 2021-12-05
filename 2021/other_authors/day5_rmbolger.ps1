# credits to https://www.reddit.com/user/rmbolger/
# through https://www.reddit.com/r/PowerShell/comments/r99a9i/advent_of_code_2021_day_5_hydrothermal_venture/
#
# This script takes input from clipboard, so make sure the correct input for day5 is there

function Get-Points {
    [CmdletBinding()]
    param(
        [object[]]$Coords
    )

    foreach ($c in $Coords) {
        Write-Verbose ($c -join ',')

        # enumerate the points between x1,y1 and x2,y2
        $x,$y = $c[0],$c[1]
        do {
            "$x,$y"
            # increment/decrement x and y if they're not already done
            if ($x -ne $c[2]) { $x += ($c[0] -le $c[2]) ? 1 : -1 }
            if ($y -ne $c[3]) { $y += ($c[1] -le $c[3]) ? 1 : -1 }
        }
        while ($x -ne $c[2] -or $y -ne $c[3])

        # don't forget the last point
        "$x,$y"
    }
}

# parse the input
$coords = gcb | %{
    ,[int[]](($_.Replace(' -> ',',')) -split ',')
}

# separate the diagonals and non-diagonals
$nonDiags = $coords | Where-Object {
    $_[0] -eq $_[2] -or $_[1] -eq $_[3]
}
$diags = $coords | Where-Object {
    $_[0] -ne $_[2] -and $_[1] -ne $_[3]
}

$points = Get-Points $nonDiags
($points |
    Group-Object |
    Where-Object { $_.Count -gt 1 } |
    Measure-Object
).Count

$points += Get-Points $diags
($points |
    Group-Object |
    Where-Object { $_.Count -gt 1 } |
    Measure-Object
).Count