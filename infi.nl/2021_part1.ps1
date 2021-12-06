$parts = Get-Content -Path './inputs/2021.txt'
$lines = @{}
$usedaspart = @{}
$totalparts = @{}
$count = 0

for ($i = 1; $i -lt $parts.Count; $i++) {
    $name, $components = $parts[$i].Trim() -split ':'
    $lines[$name] = $components.Trim()
}

function Get-Parts {
    param (
        [String[]] $parts
    )
    $elements = $parts -split ','
    $count, $subcost = 0
    foreach ($element in $elements) {
        [int]$amount, $name = $element.Trim() -split ' '
        if ($lines.ContainsKey($name)) {
            $usedaspart[$name] = $true
            $amount = $amount * (Get-Parts -parts $lines[$name])
        }
        $count += $amount
    }
    return $count
}

$lines.GetEnumerator() | ForEach-Object {
    $pnum = Get-Parts $_.Value
    if (-not $totalparts.ContainsKey($_.Key)) {
        $totalparts.Add($_.Key, $pnum)
    }
    if ($pnum -gt $highest) {
        $highest = $pnum
    }
}
"
The answer to part 1 is: $highest"
