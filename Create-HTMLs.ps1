. .\functions.ps1

$Body = $null
$predictionFiles = Get-ChildItem ".\predictions"
$scores = $predictionFiles | ForEach-Object {
    Get-Points -File $_.FullName
}
$scores | Sort-Object Poeng -Descending | ConvertTo-Html | Out-File web\leaderboard.html
$Body = $null
$gs = Get-GroupStandings


foreach ($i in $gs) {
    $Body += "<h3>$($i.Name)</h3><br>"
    $Body += "Leder: $(Get-Team -ID $i.CurrentWinner)<br>"
    $Body += "2. plass: $(Get-Team -ID $i.CurrentRunnerUp)"
    $Body += $i.Teams | Select-Object Place, Name, Played, Win, Draw, Loss, GoalIn, GoalOut, GoalDiff, Points | Sort-Object @{expression = "Points"; Descending = $true}, @{expression = "GoalDiff"; Descending = $true} | ConvertTo-Html -Fragment -As Table
}
ConvertTo-Html -Body $Body | Out-File web\tabeller.html

$Body = $null
$gm = Get-GroupMatches

foreach ($i in $gm) {
    $Body += "<h3>$($i.Name)</h3>"
    $Body += $i.Matches | Select-Object Hjemmelag, Bortelag, HjemmelagScore, BortelagScore | ConvertTo-Html -Fragment -As Table
}
ConvertTo-Html -Body $Body | Out-File web\kamper.html

$Body = $null
$RO16Matches = Get-RO16Matches
$RO8Matches = Get-KOMatches -Round "round_8"
$RO4Matches = Get-KOMatches -Round "round_4"
$RO2Matches = Get-KOMatches -Round "round_2"
$Winner = Get-KOMatches -Round "round_2" | Select-Object -ExpandProperty Vinner
$Body += "<h3>8-delsfinale</h3>"
$Body += $RO16Matches | Select-Object Hjemmelag, Bortelag, Vinner | ConvertTo-Html -Fragment -As Table
$Body += "<h3>Kvartfinale</h3>"
$Body += $RO8Matches | Select-Object Hjemmelag, Bortelag, Vinner | ConvertTo-Html -Fragment -As Table
$Body += "<h3>Semifinale</h3>"
$Body += $RO4Matches | Select-Object Hjemmelag, Bortelag, Vinner | ConvertTo-Html -Fragment -As Table
$Body += "<h3>Finale</h3>"
$Body += $RO2Matches | Select-Object Hjemmelag, Bortelag, Vinner | ConvertTo-Html -Fragment -As Table
$Body += "<h1>Vinner: $Winner</h1>"


ConvertTo-Html -Body $Body | Out-File web\kokamper.html


$Body = $null
$predictionFiles = Get-ChildItem ".\predictions"
foreach ($p in $predictionFiles) {
    $i = Get-Content $p.FullName | ConvertFrom-Json
    $Points = Get-Points -File $p.FullName | Select-Object -ExpandProperty Poeng
    $Body += "<h3>$($i.Navn)</h3>"
    $Body += "<h4>Poeng: $Points</h4>"
    $Body += $i | Select-Object GrpAWin, GrpASec, GrpBWin, GrpBSec, GrpCWin, GrpCSec, GrpDWin, GrpDSec, GrpEWin, GrpESec, GrpFWin, GrpFSec, GrpGWin, GrpGSec, GrpHWin, GrpHSec | ConvertTo-Html -Fragment -As Table
    $Body += $i | Select-Object M49Win, M50Win, M51Win, M52Win, M53Win, M54Win, M55Win, M56Win | ConvertTo-Html -Fragment -As Table
    $Body += $i | Select-Object M57Win, M58Win, M59Win, M60Win | ConvertTo-Html -Fragment -As Table
    $Body += $i | Select-Object M61Win, M62Win | ConvertTo-Html -Fragment -As Table
    $Body += $i | Select-Object Winner | ConvertTo-Html -Fragment -As Table
}
ConvertTo-Html -Body $Body | Out-File web\predictions.html