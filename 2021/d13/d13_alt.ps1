#Requires -PSEdition Core
$dotinput, $foldinput = (Get-Content -raw './inputs/d13.txt') -split "`r?`n`r?`n"

$paper = @{}
$dotinput -split "`r?`n" | Foreach-Object {
    $x, $y = $_ -split ','
    $paper.Add("$x,$y",@{x = [int]$x; y = [int]$y })
}

$folds = $foldinput -split "`r?`n" | Foreach-Object {
    $axis, [int]$amount = $_ -replace 'fold along ' -split '='
    , @($axis, $amount)
}

function origami {
    param (
        [int] $start,
        [int] $end
    )
    foreach ($p in @($paper.Keys)) {
        # perform all the folds
        $x = $paper.$p.x
        $y = $paper.$p.y
        $folds[0..$folds.Count] | foreach-object {
            $n = $_[1]
            switch ($_[0]) {
                'x' { $x = ($x -gt $n) ? $(2*$n - $x) : $x }
                'y' { $y = ($y -gt $n) ? $(2*$n - $y) : $y }
            }
        }
        # move the old point to the new point
        $paper.Remove($p)
        if (-not $paper.containsKey("$x,$y")) {
            $paper.Add("$x,$y",@{x = [int]$x; y = [int]$y })
        }
    }
}

function Out-Paper {
    $width = ($paper.Values.x | Measure-Object -Maximum).Maximum
    $height = ($paper.Values.y | Measure-Object -Maximum).Maximum
    for ($y = 0; $y -le $height; $y++) {
        $line = for ($x = 0; $x -le $width; $x++) {
                ($paper.ContainsKey("$x,$y")) ? '█' : ' '
        }
        Write-Host $($line -join '')
    }
    Write-Host ''
}

# part 1
# make the first fold
Origami 0 1
$part1 = $paper.Keys.Count
"The answer to part 1 is: $part1"

# part 2
# make the rest of the folds
Origami 1 $folds.Count
'The answer to part 2 is:'
Out-Paper