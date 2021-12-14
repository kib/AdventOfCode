    #Requires -PSEdition Core
    $dotinput, $foldinput = (Get-Content -raw './inputs/d13.txt') -split "`r?`n`r?`n"

    $paper = $dotinput -split "`r?`n" | Foreach-Object {
        $x, $y = $_ -split ','
        [PSCustomObject]@{
            id = "$x,$y"
            x  = [int]$x
            y  = [int]$y
        }
    }

    $folds = $foldinput -split "`r?`n" | Foreach-Object {
        $axis, [int]$amount = $_ -replace 'fold along ' -split '='
        , @($axis, $amount)
    }

    function new-Fold {
        param (
            [Object[]] $paper,
            [String] $axis,
            [int] $fold
        )
        $paper | foreach-object {
            if ($_.$axis -gt $fold) {
                # point's distance from the fold => $_.$axis - $fold
                # we want to go from that fold the same distance the other way => $fold - ($_.$axis - $fold)
                # can be rewritten to => 2*$fold - $_.$axis
                $_.$axis = 2*$fold - $_.$axis
                $_.id = "$($_.x),$($_.y)"
                $_
            }
            else {
                $_
            }
        }
    }

    function Out-Paper {
        param (
            $paper
        )
        $width = ($paper.x | Measure-Object -Maximum).Maximum
        $height = ($paper.y | Measure-Object -Maximum).Maximum
        for ($y = 0; $y -le $height; $y++) {
            $line = for ($x = 0; $x -le $width; $x++) {
                    ($paper.id.Contains("$x,$y")) ? '█' : ' '
            }
            Write-Host $($line -join '')
        }
        Write-Host ''
    }

    # part 1
    # make the first fold
    $paper = new-fold $paper $folds[0][0] $folds[0][1]
    $part1 = ($paper.id | Sort-Object -Unique).Count
    "The answer to part 1 is: $part1"

    # part 2
    # make the rest of the folds
    $folds[1..$folds.Count] | foreach-object {
        $paper = new-fold $paper $_[0] $_[1]
    }
    'The answer to part 2 is:'
    Out-Paper $paper