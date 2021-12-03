# part 1
[int[]]$expenses = Get-Content './inputs/day1.txt'

for ($i = 0; $i -lt $expenses.Count; $i++) {
    for ($j = $i; $j -lt $expenses.Count; $j++) {
        # only move forward
        if ($expenses[$i]+$expenses[$j] -eq 2020) {
            'The answer to part 1 is: ' + $expenses[$i] * $expenses[$j]
            break
        }
    }
}