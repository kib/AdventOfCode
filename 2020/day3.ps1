$map = Get-Content -Path 'inputs/day3.txt'

$pos = 0
$trees = 0
$modvalue = $map[0].Length
for ($i = 1 ; $i -lt $map.Count; $i++){
    $pos += 3
    $pos = $pos % $modvalue
    if ($map[$i][$pos] -eq '#') { $trees++ }
}

'The answer to part 1 is: ' + $trees