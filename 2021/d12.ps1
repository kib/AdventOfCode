$data = Get-Content -Path './inputs/d12.txt'
$target = @{}
$paths = @{}
$smallvisited = {}
$counter = 0

foreach ($line in $data) {
    $id, $d = $line -split '-'
    if (-not ($d -in $target.$id)) {
        $target.$id += , $d
    }
    if (-not ($id -in $target.$d)) {
        $target.$d += , $id
    }
    $target.Remove('end')
}

function get-Paths {
    param (
        [String[]] $p = @(),
        [String[]] $u = @(),
        [int] $id
    )
    if ($p.Count -eq 0) {
        $p = ,'start'
    }
    $last = $p[-1]
    #comm
    $key = $p -join '-'
    $l = $u -join ','
    Write-Verbose "[$id] Branched from '$key' with '$l' already visited"
    Write-Verbose "[$id] Last item was '$last'"
    #/comm
    $poss = [String[]]$target.$last
    foreach ($t in $poss) {
        $nu = $u
        $key2 = $p -join '-'
        Write-Verbose "[$id] Working on '$key2"
        Write-Verbose "[$id] Working on '$key'"
        Write-Verbose "[$id] -> '$t' (from '$($poss -join ",")'), visited '$($u -join ',')'"
        # special case
        if ($t -eq 'start') {
            continue
        }
        #end of path
        if ($t -eq 'end') {
            $end = $p + $t
            $key = $end -join ','
            Write-Verbose "[$id] FOUND: $key"
            $paths.$key = $end
            continue
        }
        # can't visit small cave twice
        if ([int][char]$t[0] -gt 90) {
            if ($t -in $u) {
                continue
            } else {
                $nu = $nu + $t
            }
        }
        # if we made it here we can branch
        get-Paths $($p + $t) $nu $($id+1)
    }
}

get-Paths

Write-verbose ($paths.Keys -join '`n')
"The answer to part 1 is: {0}" -f $paths.Keys.Count