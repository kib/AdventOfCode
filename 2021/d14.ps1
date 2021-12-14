    [String]$template, $pairrules = (Get-Content -Raw '.\inputs\d14.txt') -split "`r?`n`r?`n"
    [String[]] $pairrules = $pairrules -split "`r?`n"

    # rules lookup
    $target = @{}
    $pairrules | ForEach-Object {
        $src, [char]$trgt = $_ -split " -> "
        $target.$src = $trgt
    }

    # pair counter
    $occurence =@{}
    for ($i = 0; $i -lt $template.Length -1; $i++) {
        $occurence.$($template.subString($i,2)) ++
    }

    # character counter
    $charcount = @{}
    $template.toCharArray() | ForEach-Object {
        $charcount."$_" += 1
    }

    function Polymerise {
        param (
            [int] $loops
        )
        for ($i = 1; $i -le $loops; $i++) {
            $o = $occurence.Clone()
            foreach ($pair in @($o.Keys)) {
                    $c = $target.$pair
                    $left = $pair[0] + $c
                    $right = $c + $pair[1]
                    $occurence.$left += $o.$pair
                    $occurence.$right += $o.$pair
                    $charcount."$c" += $o.$pair
                    $occurence.$pair -= $o.$pair
            }
            # cleanup
            foreach ($pair in @($occurence.Keys)) {
                if ($occurence.$pair -eq 0) {
                    $occurence.Remove($pair)
                }
            }
        }
    }

    #part 1
    Polymerise 10
    $ans1 = ($charcount.Values | measure-object -maximum).maximum - ($charcount.Values | measure-object -minimum).minimum
    "The answer to part 1 is: $ans1"

    # part 2
    Polymerise 30
    $ans2 = ($charcount.Values | measure-object -maximum).maximum - ($charcount.Values | measure-object -minimum).minimum
    "The answer to part 1 is: $ans2"
