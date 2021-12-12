#    -ABCDEFG         Column value additions per digit
# 0 |01110111| 6    | 42
# 1 |00010010| 2 *  | 17
# 2 |01011101| 5    | 34
# 3 |01011011| 5    | 39
# 4 |00111010| 4 *  | 30
# 5 |01101011| 5    | 37
# 6 |01101111| 6    | 41
# 7 |01010010| 3 *  | 25
# 8 |01111111| 7 *  | 49
# 9 |01111011| 6    | 45
#    08687497
#      *  **

$lines = (Get-Content -Path './inputs/d08.txt')
$digitlines = $lines | ForEach-Object {($_ -split ' \| ')[0]}
$outputlines = $lines | ForEach-Object {($_ -split ' \| ')[1]}

# part 1
$part1 = 0
foreach ($line in $outputlines) {
    $line -split ' ' | ForEach-Object {
        if ($_.length -in @(2, 3, 4, 7)) {
            $part1 ++
        }
    }
}
"The answer to part 1 is: $part1"

# part 2
$linedecode = @{}
$index = "abcdefg"
$magic = @{
42 = '0'
17 = '1'
34 = '2'
39 = '3'
30 = '4'
37 = '5'
41 = '6'
25 = '7'
49 = '8'
45 = '9'
}

for ($i = 0; $i -lt $lines.Count; $i++) {
    $linedecode.$i = (($digitlines[$i].split() -join '').tochararray() | Group-Object | ForEach-Object { $_.Count }) -join ','
}

for ($i = 0; $i -lt $lines.Count; $i++) {
    $words = $outputlines[$i] -split ' '
    $decoder = $linedecode.$i -split ','
    $number = ''
    foreach ($word in $words) {
        $sum = 0
        $word.tocharArray() | ForEach-Object {
            $ind = $index.IndexOf($_)
            $sum += $decoder[$ind]
        }
        $number += $magic.$sum
    }
    $part2 += [Int32]::Parse($number)
}

"The answer to part 2 is: $part2"
