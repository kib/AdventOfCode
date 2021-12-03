[int[]]$report = Get-Content -Path '.\inputs\day1.txt'

for ($i = 1; $i -lt $report.Count; $i++) {
    if ($report[$i] -gt $report[$i-1]) {
        $increased++
    }
}
'The answer to part 1 is: ' + $increased

for ($i = 3; $i -lt $report.Count; $i++) {
    $firstsum = ($report[$($i-3)..$($i-1)] | Measure-Object -Sum).Sum
    $secondsum = ($report[$($i-2)..$i] | Measure-Object -Sum).Sum
    if ($secondsum -gt $firstsum) {
        $largersums++
    }
}
'The answer to part 2 is: ' + $largersums

