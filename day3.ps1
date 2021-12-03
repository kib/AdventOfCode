#Requires -PSEdition Core

    $data = Get-Content '.\inputs\day3.txt'

    $gamma = @([char]'0') * $data[0].Length
    $epsilon = @([char]'1') * $data[0].Length

    for ($i = 0; $i -lt $data[0].Length; $i++) {
        $ones = 0
        foreach ($line in $data) {
            [char[]]$chars = $line
            if ($chars[$i] -eq '1') {
                $ones++
            }
        }
        if ($ones -gt $data.Length / 2) {
            $gamma[$i] = '1'
            $epsilon[$i] = '0'
        }
    }

    $gamma = [convert]::toInt32($gamma -join '', 2)
    $epsilon = [convert]::toInt32($epsilon -join '', 2)
    'The answer to part 1 is: ' + $gamma * $epsilon

    # part 2

    $report = Get-Content '.\inputs\day3.txt'

    function Get-Commonest {
        [CmdletBinding()]
        param (
            [Collections.Generic.List[String]] $data,
            [Switch] $Least
        )
        for ($i = 0; $i -lt $data[0].Length; $i++) {
            $ones = 0
            foreach ($line in $data) {
                if ($line[$i] -eq '1') {
                    $ones++
                }
            }
            $half = $data.Count /2
            if ($Least) {
                $keep = ($ones -lt $half) ? '1' : '0'
            } else {
                $keep = ($ones -ge $half) ? '1' : '0'
            }
            # remove incorrect objects
            $count = $data.Count
            for ($j = $Count - 1; $j -ge 0; $j--) {
                if ($data[$j][$i] -ne $keep -And $data.count -gt 1) {
                    $null = $data.Remove($data[$j])
                }
            }
        }
        $data[0]
    }

    $oxy = [convert]::toInt32($(Get-Commonest -data $report),2)
    $co2 = [convert]::toInt32($(Get-Commonest -data $report -Least),2)
    'The answer to part 2 is: ' + $oxy*$co2