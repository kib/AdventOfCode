    $data = Get-Content -Path './inputs/d12_demo1.txt'
    $targets = @{}
    $paths = @{}
    $process = 0
    $pathCount = 0

    foreach ($line in $data) {
        $a, $b = $line -split '-'
        if (-not ($a -in $targets.$b) -and ($a -ne 'start')) {
            $targets.$b += , $a
        }
        if (-not ($b -in $targets.$a) -and ($b -ne 'start')) {
            $targets.$a += , $b
        }
        $targets.Remove('end')
    }

    function get-Paths {
        param (
            [String[]] $pathTaken = @(),
            [String[]] $smallCaves = @(),
            [String] $twiceCave = '',
            [int] $id
        )
        Write-Verbose "[$id] Branched from '$($pathTaken -join '-')' with [$($smallCaves -join ',')] small visited ([$twiceCave] twice)"
        $last = $pathTaken[-1]
        $possibleNodes = [String[]]$targets.$last
        foreach ($node in $possibleNodes) {
            $script:process++
            Write-Verbose "[$id] '$($pathTaken -join '-')-<$node>' from [$($possibleNodes -join "|")] with small [$($smallCaves -join ',')] used ([$twiceCave] twice)"
            if ($node -eq 'end') {
                $key = $($pathTaken + $node) -join ','
                $paths.$key = $($pathTaken + $node)
                Write-Verbose "[$id] FOUND $key"
                $script:pathCount ++
                continue
            }
            # we do not want to change these inside the loop, but only when we recurse
            $smallCaveCopy = $smallCaves
            $twiceCaveCopy = $twiceCave
            if ([int][char]$node[0] -gt 90) {
                if ($node -in $smallCaves) {
                    if ('' -eq $twiceCave) {
                        $twiceCaveCopy = $node
                    } else {
                        continue
                    }
                } else {
                    $smallCaveCopy = $smallCaveCopy + $node
                }
            }
            get-Paths -pathTaken $($pathTaken + $node) -smallCaves $smallCaveCopy -twiceCave $twiceCaveCopy -id $($id+1)
        }
    }
    get-Paths 'start'

    $paths.Keys | Sort-Object
    "The answer to part 2 is: {0}" -f $pathCount
    "This took $process steps"
