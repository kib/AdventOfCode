$data = Get-Content -Path './inputs/d12_demo3.txt'
$target = @{}
# $paths = @{}
# $process = 0
$pc = 0

foreach ($line in $data) {
    $a, $b = $line -split '-'
    if (-not ($a -in $target.$b) -and ($a -ne 'start')) {
        $target.$b += , $a
    }
    if (-not ($b -in $target.$a) -and ($b -ne 'start')) {
        $target.$a += , $b
    }
    $target.Remove('end')
}

function get-Paths {
    param (
        [String[]] $p = @(),
        [String[]] $u = @(),
        [int] $id
    )
    # Write-Verbose "[$id] Branched from '$($p -join '-')' with [$($u -join ',')] and [$u2]"
    $last = $p[-1]
    $poss = [String[]]$target.$last
    foreach ($t in $poss) {
        # $script:process++
        # Write-Verbose "[$id] '$($p -join '-')-<$t>' from [$($poss -join "|")] with [$($u -join ',')] and [$u2]"
        if ($t -eq 'end') {
            # $key = $($p + $t) -join ','
            # $paths.$key = $($p + $t)
            $script:pc ++
            # Write-Verbose "[$id] FOUND $key"
            continue
        }
        $nu = $u
        if ([int][char]$t[0] -gt 90) {
            if ($t -in $nu) {
                continue
            }
            else {
                $nu = $nu + $t
            }
        }
        get-Paths $($p + $t) $nu $($id + 1)
    }
}
get-Paths 'start'

# $paths.Keys | Sort-Object
"The answer to part 1 is: {0}" -f $pc
# "This took $process steps"
