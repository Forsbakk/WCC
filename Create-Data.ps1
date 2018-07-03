. .\functions.ps1

$iPoints = Get-Points
$Toppscorer = Get-TopScorer

$Body = @"
<table class=`"leaderboard`">
    <tr>
        <th class=`"points`">Poeng</th>    
        <th>Navn</th>
    </tr>
"@
$iPoints = $iPoints | Sort-Object Poeng -Descending
foreach ($p in $iPoints) {
    $Body += @"
    <tr>
        <td>$($p.Poeng)</td>
        <td>$($p.Navn)</td>
    </tr>
"@
}
$Body += "</table>"
$Body | Out-File "web\leaderboard.html" -Encoding utf8

$gs = Get-GroupStandings

$Body = $null

foreach ($i in $gs) {
    $Body += @"
<table class=`"groups`">
    <tr>
        <th colspan=`"10`">$($i.Name)</th>
    </tr>
"@
    $teamssorted = $i.Teams | Sort-Object @{expression = "Points"; Descending = $true}, @{expression = "GoalDiff"; Descending = $true}, @{expression = "GoalIn"; Descending = $true}
    foreach ($ti in $teamssorted) {
        $Body += @"
    <tr>
        <td class=`"fp`">$($ti.Place)</td>
        <td>$($ti.Name)</td>
        <td class=`"fp`">$($ti.Played)</td>
        <td class=`"fp`">$($ti.Win)</td>
        <td class=`"fp`">$($ti.Draw)</td>
        <td class=`"fp`">$($ti.Loss)</td>
        <td class=`"fp`">$($ti.GoalIn)</td>
        <td class=`"fp`">$($ti.GoalOut)</td>
        <td class=`"fp`">$($ti.GoalDiff)</td>
        <td class=`"fp`">$($ti.Points)</td>
    </tr>
"@
    }
    $Body += @"
</table>
"@
}
$Body | Out-File "web/tabeller.html" -Encoding utf8

$Body = $null
$gm = Get-GroupMatches

foreach ($i in $gm) {
    $Body += @"
<table class=`"groups`">
    <tr>
        <th colspan=`"3`">$($i.Name)</th>
    </tr>
"@
    foreach ($m in $i.Matches) {
        if ($m.finished -eq "True") {
            $Body += @"
    <tr>
        <td>$($m.Hjemmelag)</td>
        <td>$($m.Bortelag)</td>
        <td class=`"fp`">$($m.HjemmelagScore)-$($m.BortelagScore)</td>
    </tr>
"@
        }
        else {
            $Body += @"
    <tr>
        <td>$($m.Hjemmelag)</td>
        <td>$($m.Bortelag)</td>
        <td class=`"fp`">N/A</td>
    </tr>
"@
        }
    }
}
$Body | Out-File "web/gruppekamper.html" -Encoding utf8


$Body = $null
$KOMatches = Get-KOMatches

$R16 = $KOMatches | Where-Object { $_.Round -eq "round_16" }
$R8 = $KOMatches | Where-Object { $_.Round -eq "round_8" }
$R4 = $KOMatches | Where-Object { $_.Round -eq "round_4" }
$R2 = $KOMatches | Where-Object { $_.Round -eq "round_2" }
$Winner = Get-Winner

$Body += @"
<table class=`"groups`">
    <tr>
        <th colspan=`"2`">8-delsfinale</th>
        <th>Vinner</th>
    </tr>
"@
foreach ($m in $R16) {
    $Body += @"
    <tr>
        <td>$($m.Hjemmelag)</td>
        <td>$($m.Bortelag)</td>
        <td>$($m.Vinner)</td>
    </tr>
"@
}
$Body += @"
</table>
<table class=`"groups`">
    <tr>
        <th colspan=`"2`">Kvartfinale</th>
        <th>Vinner</th>
    </tr>
"@
foreach ($m in $R8) {
    $Body += @"
    <tr>
        <td>$($m.Hjemmelag)</td>
        <td>$($m.Bortelag)</td>
        <td>$($m.Vinner)</td>
    </tr>
"@
}
$Body += @"
</table>
<table class=`"groups`">
    <tr>
        <th colspan=`"2`">Semifinale</th>
        <th>Vinner</th>
    </tr>
"@
foreach ($m in $R4) {
    $Body += @"
    <tr>
        <td>$($m.Hjemmelag)</td>
        <td>$($m.Bortelag)</td>
        <td>$($m.Vinner)</td>
    </tr>
"@
}
$Body += @"
</table>
<table class=`"groups`">
    <tr>
        <th colspan=`"2`">Finale</th>
        <th>Vinner</th>
    </tr>
"@
foreach ($m in $R2) {
    $Body += @"
    <tr>
        <td>$($m.Hjemmelag)</td>
        <td>$($m.Bortelag)</td>
        <td>$($m.Vinner)</td>
    </tr>
"@
}
$Body += @"
</table>
<h1>Vinner: $Winner</h1>
<h4>Toppscorer: $($Toppscorer.Toppscorer)<br>
Land: $($Toppscorer.Land)<br>
Mål: $($Toppscorer.Goals)</h4>
"@

$Body | Out-File "web\kokamper.html" -Encoding utf8

$Body = $null
$predictionFiles = Get-ChildItem ".\predictions"
foreach ($p in $predictionFiles) {
    $i = Get-Content $p.FullName | ConvertFrom-Json
    $scr = $iPoints | Where-Object { $_.Navn -eq $i.Navn } | Select-Object -ExpandProperty Poeng
    $Body += @"
<h2>$($i.Navn) - $scr poeng</h2>
<table class=`"groups`">
    <tr>
        <th colspan=`"2`">8-delsfinale</th>
        <th>Vinner</th>
    </tr>
    <tr>
        <td>$($i.GrpAWin)</td>
        <td>$($i.GrpBSec)</td>
        <td>$($i.M49Win)</td>
    </tr>
    <tr>
        <td>$($i.GrpCWin)</td>
        <td>$($i.GrpDSec)</td>
        <td>$($i.M50Win)</td>
    </tr>
    <tr>
        <td>$($i.GrpBWin)</td>
        <td>$($i.GrpASec)</td>
        <td>$($i.M51Win)</td>
    </tr>
    <tr>
        <td>$($i.GrpDWin)</td>
        <td>$($i.GrpCSec)</td>
        <td>$($i.M52Win)</td>
    </tr>
    <tr>
        <td>$($i.GrpEWin)</td>
        <td>$($i.GrpFSec)</td>
        <td>$($i.M53Win)</td>
    </tr>
    <tr>
        <td>$($i.GrpGWin)</td>
        <td>$($i.GrpHSec)</td>
        <td>$($i.M54Win)</td>
    </tr>
    <tr>
        <td>$($i.GrpFWin)</td>
        <td>$($i.GrpESec)</td>
        <td>$($i.M55Win)</td>
    </tr>
    <tr>
        <td>$($i.GrpHWin)</td>
        <td>$($i.GrpGSec)</td>
        <td>$($i.M56Win)</td>
    </tr>
</table>
<table class=`"groups`">
    <tr>
        <th colspan=`"2`">Kvartfinale</th>
        <th>Vinner</th>
    </tr>
    <tr>
        <td>$($i.M49Win)</td>
        <td>$($i.M50Win)</td>
        <td>$($i.M57Win)</td>
    </tr>
    <tr>
        <td>$($i.M53Win)</td>
        <td>$($i.M54Win)</td>
        <td>$($i.M58Win)</td>
    </tr>
    <tr>
        <td>$($i.M51Win)</td>
        <td>$($i.M52Win)</td>
        <td>$($i.M59Win)</td>
    </tr>
    <tr>
        <td>$($i.M55Win)</td>
        <td>$($i.M56Win)</td>
        <td>$($i.M60Win)</td>
    </tr>
</table>
<table class=`"groups`">
    <tr>
        <th colspan=`"2`">Semifinale</th>
        <th>Vinner</th>
    </tr>
    <tr>
        <td>$($i.M57Win)</td>
        <td>$($i.M58Win)</td>
        <td>$($i.M61Win)</td>
    </tr>
    <tr>
        <td>$($i.M59Win)</td>
        <td>$($i.M60Win)</td>
        <td>$($i.M62Win)</td>
    </tr>
</table>
<table class=`"groups`">
    <tr>
        <th colspan=`"2`">Finale</th>
        <th>Vinner</th>
    </tr>
    <tr>
        <td>$($i.M61Win)</td>
        <td>$($i.M62Win)</td>
        <td>$($i.Winner)</td>
    </tr>
</table>
<h2>Vinner: $($i.Winner)</h2>
<h4>Toppscorer: $($i.Scorer)
<hr>
"@
}

$Body | Out-File "web\predictions.html" -Encoding utf8