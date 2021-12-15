[int[]] $data = (Get-Content -Path './inputs/day7.txt') -split ','

$median = ($data | Sort-Object)[[Math]::Floor($data.Length / 2) + 1]
"The answer to part 1 is: $median"

