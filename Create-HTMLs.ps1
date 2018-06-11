. .\functions.ps1

$Body = $null
$gs = Get-GroupStandings


foreach ($i in $gs) {
    $Body += "<h3>$($i.Name)</h3>"
    $Body += $i.Teams | Select-Object Place, Name, Played, Win, Draw, Loss, GoalIn, GoalOut, Points | Sort-Object Points -Descending | ConvertTo-Html -Fragment -As Table
}
ConvertTo-Html -Body $Body | Out-File web\tabeller.html

$Body = $null
$gm = Get-GroupMatches

foreach ($i in $gm) {
    $Body += "<h3>$($i.Name)</h3>"
    $Body += $i.Matches | Select-Object Hjemmelag, Bortelag, HjemmelagScore, BortelagScore | ConvertTo-Html -Fragment -As Table
}
ConvertTo-Html -Body $Body | Out-File web\kamper.html