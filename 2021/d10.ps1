    $codes = Get-Content -Path '.\inputs\day10.txt'
    [Collections.Generic.Stack[String]] $stack = @()

    $openbrackets = '[([{<]'
    $closebrackets = '[)\]}>]'

    $closer = @{
        ')' = '('
        ']' = '['
        '}' = '{'
        '>' = '<'
    }

    $points = @{
        ')' = 3
        ']' = 57
        '}' = 1197
        '>' = 25137
    }

    $points2 = @{
        '(' = 1
        '[' = 2
        '{' = 3
        '<' = 4
    }


    $sum = 0
    $linecosts = foreach ($code in $codes) {
        $stack.Clear()
        [String[]]$code.ToCharArray() | ForEach-Object {
            if ($_ -match $openbrackets) {
                $stack.Push($_)
            } elseif ($_ -match $closebrackets) {
                if ($closer[$_] -eq $stack.Peek()) {
                    $null = $stack.Pop()
                } else {
                    $sum += $points[$_]
                    continue
                }
            }
        }
        # part2
        if ($stack.Count -gt 0) {
            $lc = 0
            [String[]]($stack -join '').ToCharArray() | Foreach-Object {
                $lc *= 5
                $lc += $points2[$_]
            }
            $lc
        }
    }

    "The answer to part 1 is $sum"
    $linecosts = $linecosts | Sort-Object
    "The answer to part 2 is {0}" -f $linecosts[($linecosts.Count/2)]
