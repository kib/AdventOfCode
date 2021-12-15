# import exercise
[String]$template, $pairrules = (Get-Content -Raw '.\inputs\d14.txt') -split "`r?`n`r?`n"
[String[]] $pairrules = $pairrules -split "`r?`n"

# initialise rules lookup table
$pair = @{}
$pairrules | ForEach-Object {
    $src, $trgt = $_ -split " -> "
    $pair.$src = $trgt
}

$clist = New-Object Collections.ArrayList
$template.toCharArray() | ForEach-Object { $null = $clist.Add($_) }

for ($i = 0; $i -lt 10; $i++) {
    $maxind = $clist.Count - 1
    $ind = 0
    do {
        $compair = $clist[$ind..($ind + 1)] -join ''
        if ($pair.ContainsKey($compair)) {
            $clist.insert(($ind + 1), $pair.$compair)
            $ind += 2
            $maxind ++
        }
        else {
            $ind ++
        }
    } until ($ind -ge $maxind)
}


$Least = ($clist | Group-Object | Sort-Object Count | Select-Object -First 1).Count
$Most = ($clist | Group-Object | Sort-Object Count | Select-Object -Last 1).Count
"The answer for part 1 is: {0}" -f $($Most - $least)
