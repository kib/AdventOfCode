    [String[]]$octopi = Get-Content -Path './inputs/d11.txt'

    $width = $octopi[0].Length
    $height = $octopi.Count;

    $octopus = @{}
    $flashes,$step = 0

    for ($h = 0; $h -lt $height; $h++) {
        for ($w = 0; $w -lt $width; $w++) {
            $key = "$w,$h"
            $octopus[$key] = [convert]::ToInt32($octopi[$h][$w], 10)
            $flashedin[$key] = 0
        }
    }

    function Get-Neighbours {
        param (
            [String]$id
        )
        [int]$x, [int]$y = $id -split ','
        for ($i = -1; $i -lt 2; $i++) {
            for ($j = -1; $j -lt 2; $j++) {
                if ($x + $i -ge 0 -and $y + $j -ge 0 -and $x + $i -lt $width -and $y + $j -lt $height -and -not ($i -eq 0 -and $j -eq 0)) {
                    "{0},{1}" -f $($x + $i), $($y + $j)
                }
            }
        }
    }

    function New-Flash {
        param (
            [String]$id
        )
        $script:flashes ++
        $octopus[$id] = 0
        get-neighbours $id | ForEach-Object {
            $octo = $_
            switch ($octopus[$_]) {
                ({$PSItem -eq 0}) {
                    continue
                }
                ({$PSItem -ge 9}) {
                    new-flash $octo
                }
                default {
                    $octopus[$octo] += 1
                }
            }
        }
    }

    function Show-Field {
        ""
        "this is the field after step $step"
        for ($h = 0; $h -lt $height; $h++) {
            $line = for ($w = 0; $w -lt $width; $w++) {
                $octopus["$w,$h"]
            }
            $line -join ''
        }
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
        #Show-Field
    }

    # part 1
    Step-Field 100
    "After step $step there have been $flashes flashes"

    # part 2
    do {
        Step-Field 1
    } until ($octopus.Count -eq ($octopus.Values | Group-Object)[0].Count)

    "After step $step all octopi have flashed simultaneously"
