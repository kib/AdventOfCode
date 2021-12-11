[String[]]$octopi = Get-Content -Path './inputs/d11.txt'

$width = $octopi[0].Length
$height = $octopi.Count;

$octopus = @{}
$neighbours = @{}
$totalflashes, $step, $flashes = 0

$visualise = $true
if($visualise) {
    Start-Sleep 2
}

for ($h = 0; $h -lt $height; $h++) {
    for ($w = 0; $w -lt $width; $w++) {
        $octopus["$w,$h"] = [convert]::ToInt32($octopi[$h][$w], 10)
    }
}

function Get-Neighbours {
    param (
        [String]$id
    )
    if ($neighbours.ContainsKey($id)) {
        return $neighbours[$id]
    }
    [int]$x, [int]$y = $id -split ','
    $nb = for ($i = -1; $i -lt 2; $i++) {
        for ($j = -1; $j -lt 2; $j++) {
            if ($x + $i -ge 0 -and $y + $j -ge 0 -and $x + $i -lt $width -and $y + $j -lt $height -and -not ($i -eq 0 -and $j -eq 0)) {
                "$($x + $i),$($y + $j)"
            }
        }
    }
    $neighbours[$id] = $nb
    return $nb
}

function New-Flash {
    param (
        [String]$id
    )
    $script:flashes ++
    $octopus[$id] = 0
    if ($visualise) {
        $origpos = $host.UI.RawUI.CursorPosition
        Show-Field
        $host.UI.RawUI.CursorPosition = $origpos
    }
    get-neighbours $id | ForEach-Object {
        $octo = $_
        switch ($octopus[$_]) {
                ({ $PSItem -eq 0 }) {
                continue
            }
                ({ $PSItem -ge 9 }) {
                new-flash $octo
            }
            default {
                $octopus[$octo] += 1
            }
        }
    }
}

function Show-Field {
    ''
    for ($h = 0; $h -lt $height; $h++) {
        for ($w = 0; $w -lt $width; $w++) {
            if ($visualise) {
                $host.UI.RawUI.CursorSize = 0
            }
            switch ($octopus["$w,$h"]) {
                0 { 
                    Write-Host '0' -NoNewLine -BackgroundColor White
                }
                ({ $_ -ge 9 }) {
                    Write-Host '9' -NoNewline
                }
                Default {
                    Write-Host -NoNewLine $_
                }
            }
        }
        Write-Host ''
    }
    ""
    Write-Host "Step: $step"
}

function Start-FieldIncrease {
    $script:step ++
    for ($h = 0; $h -lt $height; $h++) {
        for ($w = 0; $w -lt $width; $w++) {
            $octopus["$w,$h"] += 1
        }
    }
}

function Step-Field {
    param (
        [int] $days
    )
    for ($i = 0; $i -lt $days; $i++) {
        Start-FieldIncrease
        for ($h = 0; $h -lt $height; $h++) {
            for ($w = 0; $w -lt $width; $w++) {
                if ($octopus["$w,$h"] -gt 9) {
                    New-Flash "$w,$h"
                }
            }
        }
    }
    $script:totalflashes += $script:flashes
}

# part 1
Step-Field 100
#"After step $step there have been $totalflashes flashes"

# part 2
do {
    $flashes = 0
    Step-Field 1
} until ($flashes -eq $octopus.count)

#"After step $step all octopi have flashed simultaneously"