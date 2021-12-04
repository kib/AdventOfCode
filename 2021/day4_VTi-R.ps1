# credits to https://www.reddit.com/user/VTi-R/
# through https://reddit.com/r/PowerShell
#
# slightly modified to load from the same data, and to calculate both parts in one function

$filepath = 'inputs/day4.txt'
$CallData = Get-Content $filepath | Select -First 1
$Calls = $CallData -Split ","
$Boardstext = Get-Content $filepath | Select -Skip 2

$Boards = [System.Collections.ArrayList]::new()
$WinBoards = [System.Collections.ArrayList]::new()

function ImportBoards {
    param ($BoardList)
    for ($h = 0; $h -lt $BoardList.Count; $h += 6) {
        $newBoard = @(@(0,0,0,0,0),@(0,0,0,0,0),@(0,0,0,0,0),@(0,0,0,0,0),@(0,0,0,0,0))
        for ($i = 0; $i -lt 5; $i++) {
            $x = ($BoardList[$h+$i]).Trim().Replace("  "," ") -Split " "
            for ($j = 0; $j -lt $x.Length; $j++) {
                $newBoard[$i][$j] = $x[$j]
            }
        }
        $Boards.Add($newBoard) | Out-Null
    }
}

function CheckBoard {
    param ($Board)
    $Winner = $false

    for ($i = 0; $i -lt 5; $i++) {
        if (($Board[$i][0] + $Board[$i][1] + $Board[$i][2] + $Board[$i][3] + $Board[$i][4]) -eq -5) { $Winner = $true }
        if (($Board[0][$i] + $Board[1][$i] + $Board[2][$i] + $Board[3][$i] + $Board[4][$i]) -eq -5) { $Winner = $true }
    }

    return $Winner
}

function ZeroMarked {
    param ($Board)

    for ($i = 0; $i -lt $Board.Length; $i++) {
        for ($j = 0; $j -lt $Board[$i].Length; $j++) {
            if ($Board[$i][$j] -eq -1) { $Board[$i][$j] = 0 }
        }
    }
}

function SumBoard {
    param ($Board)

    ZeroMarked $Board
    $Sum = 0
    for ($i = 0; $i -lt $Board.Length; $i++) {
        for ($j = 0; $j -lt $Board[$i].Length; $j++) {
            $Sum += $Board[$i][$j]
        }
    }
    return $Sum
}

function MarkBoard {
    param ($Board, [Int]$Call)

    for ($i = 0; $i -lt ($Board.Length); $i++) {
        for ($j = 0; $j -lt ($Board[0].Length); $j++) {
            if ($Board[$i][$j] -eq $Call) { $Board[$i][$j] = -1 }
        }
    }
}

ImportBoards $Boardstext
$FinalCall = 0

for ($i = 0; $i -lt $Calls.Count; $i++) {
    $Call = $Calls[$i]
    $RemainingBoards = [System.Collections.ArrayList]::new()
    foreach ($Board in $Boards) {
        MarkBoard $Board $Call
        if ((CheckBoard $Board) -and -not $WinBoards.Contains($Board)) {
            $WinBoards.Add($Board) | Out-Null
            If (-not $FirstFound) {
                $Firstfound = $true
                $Score = [Int32]::Parse($Call) * [Int32]::Parse((SumBoard $Board))
                Write-Host "Part 1: " $Call * (SumBoard $Board) " = " $Score
            }
        } else {
            $RemainingBoards.Add($Board) | Out-Null
        }
    }
    $Boards = $RemainingBoards
    if (($RemainingBoards.Count -eq 0) -and ($FinalCall -eq 0)) { $FinalCall = $Call }
}

$FinalBoard = $WinBoards[$WinBoards.Count - 1]
Write-Host "Part 2: " $FinalCall " * " (SumBoard $FinalBoard) " = " (([Int32]::Parse($FinalCall)) * ([Int32]::Parse((SumBoard $FinalBoard))))