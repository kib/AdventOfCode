# PREPARATIONS FOR PART 2
"
This is a list of the toys and how many parts they consist of:"
$ht = @{}
$toys = $totalparts.GetEnumerator() | Where-Object { -not $usedaspart[$_.Name] }
$toys

### switch around:
# $toys | ForEach-Object {
#     $ht[$($_.Value)] = $($_.Name)
# }
# $ht

"
There are {0} parts missing... how many of each toy were made ?" -f ($parts[0].Split())[0]