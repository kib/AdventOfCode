[String[]]$points = Get-Content -Path './inputs/d15.txt'
[int]$width = $points[0].Length

$width = $points[0].Length -1
$height = $points.Count -1

$p = @{}

for ($h = 0; $h -le $height; $h++) {
    for ($w = 0; $w -le $width; $w++) {
        $p["$w,$h"] = @{cost = [convert]::ToInt32($points[$h][$w], 10);x=$w;y=$h}
    }
}

$lowcost = 9999
function Get-Path {
    param (
        [int] $curx = 0,
        [int] $cury = 0,
        [int] $pathcost = 0,
        $visitednodes = @{}
    )
    # update the cost of the path so far
    if (-not ($curx -eq 0 -and $cury -eq 0)) {
        $pathcost += $p."$curx,$cury".cost
        if ($pathcost -gt $script:lowcost) {
            # no need continuing, we are already too expensive
            return
        }
    }
    # update the list of visited nodes
    $visited = @{} + $visitednodes
    $visited."$curx,$cury" = $true
    #"[$curx,$cury] from [$prevx, $prevy] with [$pathcost] under [$script:lowcost]"
    # is this the last position ?
    if ($curx -eq $width -and $cury -eq $height) {
            if ($pathcost -lt $script:lowcost) {
                "[$pathcost] < [$script:lowcost]"
                $script:lowcost = $pathcost
            }
            return
        }

    # we are not at the end, look at available directions
    @(@(1, 0), @(0, 1), @(0, -1), @(-1, 0)) | ForEach-Object {
        $newx = $curx + $_[0]
        $newy = $cury + $_[1]
        $beenhere = $visited.ContainsKey("$newx,$newy")
        # verify it is valid
        if (-not ($beenhere -or $newx -gt $width -or $newx -lt 0 -or $newy -gt $height -or $newy -lt 0)) {
            Get-Path $newx $newy $pathcost $visited
        }
    }
}

get-Path
"The answer to part 1 is: $lowcost"
