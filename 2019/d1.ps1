[int32[]]$masses = Get-Content -Path './inputs/d1.txt'
$sum, $sum2 = 0

function get-Fuel {
    param (
        [int32]
        $mass
    )
    [Math]::Floor([int]$mass / 3) - 2
}

function get-TotalFuel {
    param (
        [int32] $mass,
        [int32] $total = 0
    )
    $fuel = get-Fuel -mass $mass
    if ($fuel -le 0) { return $total }
    $total = $total + $fuel
    get-TotalFuel -mass $fuel -total $total
}

function Get-TotalFuel2 {
    param (
        [int32[]]
        $masses
    )
    $sum = 0
    foreach ($mass in $masses) {
        # recursive through a self terminating while
        while (($mass = [Math]::floor($mass / 3) - 2) -gt 0) {
            $sum += $mass
        }
    }
    return $sum
}

$masses | ForEach-Object { $sum += get-Fuel $_ }
$masses | ForEach-Object { $sum2 += get-TotalFuel $_ }
"The answer for part 1 is: $sum"
"The answer for part 2 is: $sum2"

'The answer for part 2 is: ' + (Get-TotalFuel2 $masses) + ' (single recursive function)'