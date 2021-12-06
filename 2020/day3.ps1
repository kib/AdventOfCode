$map = Get-Content -Path 'inputs/day3.txt'

# part 1: 
$pos = 0
$trees = 0
$modvalue = $map[0].Length
for ($i = 1 ; $i -lt $map.Count; $i++) {
    $pos += 3
    $pos = $pos % $modvalue
    if ($map[$i][$pos] -eq '#') { $trees++ }
}
'The answer to part 1 is: ' + $trees

# Part 2 involved making part 1 into a function, which makes part 1 unnecessary

function Get-TreeCount {
    [CmdletBinding()]
    param (
        [int] $right = 3,
        [int] $down = 1
    )
    $pos = 0
    $trees = 0
    $modvalue = $map[0].Length
    for ($i = $down ; $i -lt $map.Count; $i += $down) {
        $pos += $right
        $pos = $pos % $modvalue
        if ($map[$i][$pos] -eq '#') { $trees++ }
    }
    return $trees
}

$answer1 = Get-TreeCount
$answer2 = (Get-Treecount 1 1) * (Get-TreeCount 3 1) * (Get-TreeCount 5 1) * (Get-TreeCount 7 1) * (Get-TreeCount 1 2)
"The answer to part 1 is: $answer1 (done using the generic function)"
"The answer to part 2 is: $answer2"