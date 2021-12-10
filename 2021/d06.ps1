    [int[]] $data = (Get-Content -Path './inputs/day6.txt') -split ','
    $fish = @{0 = 0; 1 = 0; 2 = 0; 3 = 0; 4 = 0; 5 = 0; 6 = 0; 7 = 0; 8 = 0 }
    $sum = $sum2 = 0

    $data | ForEach-Object { $fish[$_]++ }

    function AdvanceDays {
        param (
            $days
        )
        for ($i = 0; $i -lt $days; $i++) {
            $fish_0 = $fish[0]
            for ($j = 0; $j -lt 9; $j++) {
                $fish[$j] = $fish[($j + 1)]
            }
            $fish[6] += $fish_0
            $fish[8] += $fish_0
        }
    }

    AdvanceDays 80
    $fish.GetEnumerator() | ForEach-Object { $sum += $_.Value }
    "The answer to part 1 is: $sum"

    AdvanceDays (256 - 80)
    $fish.GetEnumerator() | ForEach-Object { $sum2 += $_.Value }
    "The answer to part 1 is: $sum2"