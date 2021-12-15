$heights = Get-Content -Path '.\inputs\d09.txt'

$width = $heights[0].Length
$height = $heights.Count

# I am guessing I need to change these values in part B
# which is why I use this hashtable structure
$P = @{}
for ($x = 0; $x -lt $width; $x++) {
    $P[$x] = @{}
    for ($y = 0; $y -lt $height; $y++) {
        $P[$x][$y] = [Int32]::Parse($heights[$y][$x])
    }
}

function get-Value {
    param ( [int] $x, [int] $y)
    if (-not ($x -lt 0 -or $x -ge $width -or $y -lt 0 -or $y -ge $height)) {
        $val = $P[$x][$y]
        if ($val -ne -1) {
            return $val
        }
    }
}

function get-NeighbourValues {
    param ( [int] $x, [int] $y , [switch] $includeminus)
    $arr = @()
    $arr += (get-Value ($x + 1) $y)
    $arr += (get-Value ($x - 1) $y)
    $arr += (get-Value $x ($y + 1))
    $arr += (get-Value $x ($y - 1))
    return $arr
}

function Confirm-Lowest {
    param ( [int] $x, [int] $y )
    $lowest = (get-NeighbourValues $x $y | Measure-Object -Minimum).Minimum
    if ($lowest -gt $P[$x][$y]) {
        return $true
    }
    else {
        return $false
    }
}


$risk = 0
for ($x = 0; $x -lt $width; $x++) {
    for ($y = 0; $y -lt $height; $y++) {
        if (Confirm-Lowest $x $y) {
            $risk += $P[$x][$y] + 1
        }
    }
}

"The answer to part 1 is: $risk"