#$global:Data = Invoke-RestMethod "https://raw.githubusercontent.com/lsv/fifa-worldcup-2018/master/data.json"
$global:Data = Get-Content ".\devfiles\testdata.json" | ConvertFrom-Json
$global:Groups = Get-Content ".\groups.json" | ConvertFrom-Json


function Get-Team {
    Param(
        $ID
    )
    $Team = $Data | Select-Object -ExpandProperty teams | Where-Object { $_.id -eq $ID } | Select-Object -ExpandProperty Name
    return $Team
}

function Get-Groups {
    $Group = "a", "b", "c", "d", "e", "f", "g", "h"
    
    foreach ($i in $Group) {
        $grp = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty "$i" | Select-Object -ExpandProperty matches
        $ids = @()
        foreach ($i2 in $grp) {
            if ($ids -notcontains $i2.home_team) {
                $ids += $i2.home_team
            }
            if ($ids -notcontains $i2.away_team) {
                $ids += $i2.away_team
            }
        }
        $Groups = @{
            Name  = "Gruppe $($i.ToUpper())"
            CurrentWinner = $null
            CurrentRunnerUp = $null
            Teams = $ids | ForEach-Object {
                New-Object psobject -Property @{ ID = $_; Name = Get-Team -ID $_; Played = [int]0; Win = [int]0; Draw = [int]0; Loss = [int]0; Points = [int]0; GoalIn = [int]0; GoalOut = [int]0; GoalDiff = [int]0; Place = [int]1 }
            }
        }
        New-Object psobject -Property $Groups
    }
}

function Get-GroupStandings {
    $gi = "a", "b", "c", "d", "e", "f", "g", "h"
    $Groups = Get-Content ".\groups.json" | ConvertFrom-Json

    foreach ($grp in $gi) {
        $mi = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty "$grp" | Select-Object -ExpandProperty matches
        $i = $Groups | Where-Object { $_.Name -eq "Gruppe $($grp.ToUpper())" }

        foreach ($match in $mi) {    
            if ($match.finished -eq "true") {
                $home_team = $i.Teams | Where-Object { $_.ID -eq $match.home_team }
                $away_team = $i.Teams | Where-Object { $_.ID -eq $match.away_team }
        
                #Add Played
                $home_team.Played++
                $away_team.Played++

                #Add Goals
                $home_team.GoalIn = $home_team.GoalIn + $match.home_result
                $away_team.GoalIn = $away_team.GoalIn + $match.away_result
                $home_team.GoalOut = $home_team.GoalOut + $match.away_result
                $away_team.GoalOut = $away_team.GoalOut + $match.home_result

                #Add points
                If ($match.home_result -gt $match.away_result) {
                    $home_team.Points = $home_team.Points + 3
                    $home_team.Win++
                    $away_team.Loss++
                }
                If ($match.home_result -eq $match.away_result) {
                    $home_team.Points = $home_team.Points + 1
                    $away_team.Points = $away_team.Points + 1
                    $home_team.Draw++
                    $away_team.Draw++
                }
                If ($match.home_result -lt $match.away_result) {
                    $away_team.Points = $away_team.Points + 3
                    $away_team.Win++
                    $home_team.Loss++
                }
            }
        }
        foreach ($team in $i.Teams) {
            $team.GoalDiff = $team.GoalIn - $team.GoalOut
        }
        $Teams = $i.Teams | Sort-Object @{expression = "Points"; Descending = $true}, @{expression = "GoalDiff"; Descending = $true}
        $Teams[0].Place = 1
        $Teams[1].Place = 2
        $Teams[2].Place = 3
        $Teams[3].Place = 4
        $i.CurrentWinner = $Teams | Where-Object { $_.Place -eq 1 } | Select-Object -ExpandProperty ID
        $i.CurrentRunnerUp = $Teams | Where-Object { $_.Place -eq 2 } | Select-Object -ExpandProperty ID
    }
    return $Groups
}

function Get-GroupMatches {
    $gi = "a", "b", "c", "d", "e", "f", "g", "h"

    foreach ($grp in $gi) {
        $mi = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty "$grp" | Select-Object -ExpandProperty matches
        $Groups = @{
            Name    = "Gruppe $($grp.ToUpper())"
            Matches = $mi | ForEach-Object { 
                New-Object psobject -Property @{ Hjemmelag = Get-Team -ID $_.home_team; Bortelag = Get-Team -ID $_.away_team; HjemmelagScore = $_.home_result; BortelagScore = $_.away_result; finished = $_.finished}
            }
        }
        New-Object psobject -Property $Groups
    }
}


function New-PredictionGroupMenu {
    Param(
        $GruppeNavn
    )
    $menu = @{}
    $grpmenu = $Groups | Where-Object { $_.Name -eq $GruppeNavn } | Select-Object -ExpandProperty Teams | Select-Object -ExpandProperty Name
    for ($i = 1; $i -le $grpmenu.Count; $i++) {
        Write-Host "$i.$($grpmenu[$i-1])"
        $menu.Add($i, $grpmenu[$i - 1])
    }
    [int]$grpwin = Read-Host "Vinner av $GruppeNavn"
    [int]$grpsec = Read-Host "Nummer 2 av $GruppeNavn"
    $grpwinname = $menu.Item($grpwin)
    $grpsecname = $menu.Item($grpsec)
    Write-Output $grpwinname
    Write-Output $grpsecname
}

function New-PredictionMenu {
    Param(
        $Team1,
        $Team2
    )
    $Teams = $Team1, $Team2
    $menu = @{}
    for ($i = 1; $i -le $Teams.Count; $i++) {
        Write-Host "$i.$($Teams[$i-1])"
        $menu.Add($i, $Teams[$i - 1])
    }
    [int]$win = Read-Host "Hvem vinner"
    $winname = $menu.Item($win)
    Write-Output $winname
}

function New-Prediction {
    $Predictor = Read-Host "Navnet til tipper"
    $grpa = New-PredictionGroupMenu -GruppeNavn "Gruppe A"
    $grpb = New-PredictionGroupMenu -GruppeNavn "Gruppe B"
    $grpc = New-PredictionGroupMenu -GruppeNavn "Gruppe C"
    $grpd = New-PredictionGroupMenu -GruppeNavn "Gruppe D"
    $grpe = New-PredictionGroupMenu -GruppeNavn "Gruppe E"
    $grpf = New-PredictionGroupMenu -GruppeNavn "Gruppe F"
    $grpg = New-PredictionGroupMenu -GruppeNavn "Gruppe G"
    $grph = New-PredictionGroupMenu -GruppeNavn "Gruppe H"

    $m49 = New-PredictionMenu -Team1 $grpa[0] -Team2 $grpb[1]
    $m50 = New-PredictionMenu -Team1 $grpc[0] -Team2 $grpd[1]
    $m51 = New-PredictionMenu -Team1 $grpb[0] -Team2 $grpa[1]
    $m52 = New-PredictionMenu -Team1 $grpd[0] -Team2 $grpc[1]
    $m53 = New-PredictionMenu -Team1 $grpe[0] -Team2 $grpf[1]
    $m54 = New-PredictionMenu -Team1 $grpg[0] -Team2 $grph[1]
    $m55 = New-PredictionMenu -Team1 $grpf[0] -Team2 $grpe[1]
    $m56 = New-PredictionMenu -Team1 $grph[0] -Team2 $grpg[1]
    
    $m57 = New-PredictionMenu -Team1 $m49 -Team2 $m50
    $m58 = New-PredictionMenu -Team1 $m53 -Team2 $m54
    $m59 = New-PredictionMenu -Team1 $m51 -Team2 $m52
    $m60 = New-PredictionMenu -Team1 $m55 -Team2 $m56

    $m61 = New-PredictionMenu -Team1 $m57 -Team2 $m58
    $m62 = New-PredictionMenu -Team1 $m59 -Team2 $m60

    $winner = New-PredictionMenu -Team1 $m61 -Team2 $m62

    $properties = @{
        Navn    = $Predictor
        GrpAWin = $grpa[0]
        GrpASec = $grpa[1]
        GrpBWin = $grpb[0]
        GrpBSec = $grpb[1]
        GrpCWin = $grpc[0]
        GrpCSec = $grpc[1]
        GrpDWin = $grpd[0]
        GrpDSec = $grpd[1]
        GrpEWin = $grpe[0]
        GrpESec = $grpe[1]
        GrpFWin = $grpf[0]
        GrpFSec = $grpf[1]
        GrpGWin = $grpg[0]
        GrpGSec = $grpg[1]
        GrpHWin = $grph[0]
        GrpHSec = $grph[1]
        M49Win  = $m49
        M50Win  = $m50
        M51Win  = $m51
        M52Win  = $m52
        M53Win  = $m53
        M54Win  = $m54
        M55Win  = $m55
        M56Win  = $m56
        M57Win  = $m57
        M58Win  = $m58
        M59Win  = $m59
        M60Win  = $m60
        M61Win  = $m61
        M62Win  = $m62
        Winner  = $winner
        Points  = [int]0
    }
    $properties | ConvertTo-Json -Compress | Out-File "predictions\$Predictor.json"
}

function Get-RO16Matches {

    $matchs = $Data | Select-Object -ExpandProperty knockout | Select-Object -ExpandProperty round_16 | Select-Object -ExpandProperty matches

    foreach ($m in $matchs) {

        $home_teamlo = $m.home_team -split "_"
        $away_teamlo = $m.away_team -split "_"

        if ($home_teamlo[0] -eq "winner") {
            $home_team = Get-Team -ID (Get-GroupStandings | Where-Object { $_.Name -eq "Gruppe $($home_teamlo[1])" } | Select-Object -ExpandProperty CurrentWinner)
        }
        elseif ($home_teamlo[0] -eq "runner") {
            $home_team = Get-Team -ID (Get-GroupStandings | Where-Object { $_.Name -eq "Gruppe $($home_teamlo[1])" } | Select-Object -ExpandProperty CurrentRunnerUp)
        }

        if ($away_teamlo[0] -eq "winner") {
            $away_team = Get-Team -ID (Get-GroupStandings | Where-Object { $_.Name -eq "Gruppe $($away_teamlo[1])" } | Select-Object -ExpandProperty CurrentWinner)
        }
        elseif ($away_teamlo[0] -eq "runner") {
            $away_team = Get-Team -ID (Get-GroupStandings | Where-Object { $_.Name -eq "Gruppe $($away_teamlo[1])" } | Select-Object -ExpandProperty CurrentRunnerUp)
        }

        if ($m.winner -eq "away") {
            $winner = $away_team
        }
        elseif ($m.winner -eq "home") {
            $winner = $home_team
        }
        else {
            $winner = "TBD"
        }

        $properties = @{
            Match     = $m.name
            Hjemmelag = $home_team
            Bortelag  = $away_team
            Vinner    = $winner
        }
        New-Object psobject -Property $properties 
    }
}

function Get-KOMatches {
    Param(
        $Round
    )
    if ($Round -eq "round_8") {
        $prevRound = Get-RO16Matches
    }
    elseif ($Round -eq "round_4") {
        $prevRound = Get-KOMatches -Round "round_8"
    }
    elseif ($Round -eq "round_2") {
        $prevRound = Get-KOMatches -Round "round_4"
    }

    $matchs = $Data | Select-Object -ExpandProperty knockout | Select-Object -ExpandProperty $Round | Select-Object -ExpandProperty Matches
    foreach ($m in $matchs) {
        $home_team = $prevRound | Where-Object { $_.Match -eq $m.home_team } | Select-Object -ExpandProperty Vinner
        $away_team = $prevRound | Where-Object { $_.Match -eq $m.away_team } | Select-Object -ExpandProperty Vinner

        if ($m.winner -eq "away") {
            $winner = $away_team
        }
        elseif ($m.winner -eq "home") {
            $winner = $home_team
        }
        else {
            $winner = "TBD"
        }

        $properties = @{
            Match     = $m.name
            Hjemmelag = $home_team
            Bortelag  = $away_team
            Vinner    = $winner
        }
        New-Object psobject -Property $properties 
    }
}

function Get-Points {
    Param(
        $File
    )
    $prediction = Get-Content $File | ConvertFrom-Json
    
    $pRO16teams = $prediction.GrpAWin, $prediction.GrpASec, $prediction.GrpBWin, $prediction.GrpBSec, $prediction.GrpCWin, $prediction.GrpCSec, $prediction.GrpDWin, $prediction.GrpDSec, $prediction.GrpEWin, $prediction.GrpESec, $prediction.GrpFWin, $prediction.GrpFSec, $prediction.GrpGWin, $prediction.GrpGSec, $prediction.GrpHWin, $prediction.GrpHSec
    $rRO16obj = Get-GroupStandings | Select-Object Name, CurrentWinner, CurrentRunnerUp
    $rRO16teams = $rRO16obj | ForEach-Object { 
        Get-Team -ID $_.CurrentWinner; Get-Team -ID $_.CurrentRunnerUp 
    }

    $ro16Points = (Compare-Object $pRO16teams $rRO16teams -ExcludeDifferent -IncludeEqual).Count

    $ro16matches = Get-RO16Matches
    $ro16winner = $null
    foreach ($m in $ro16matches) {
        $ro16winner += $m.Vinner
    }
    $pro16winner = $prediction.M49Win, $prediction.M50Win, $prediction.M51Win, $prediction.M52Win, $prediction.M53Win, $prediction.M54Win, $prediction.M55Win, $prediction.M56Win
    
    $ro16mPoints = ((Compare-Object $pro16winner $ro16winner -ExcludeDifferent -IncludeEqual).Count * 2)
    
    $rqfmatches = Get-KOMatches -Round "round_8"
    $qfwinner = $null
    foreach ($m in $rqfmatches) {
        $qfwinner += $m.Vinner
    }
    $pqfwinner = $prediction.M57Win, $prediction.M58Win, $prediction.M59Win, $prediction.M60Win

    $qfpoints = ((Compare-Object $pqfwinner $qfwinner -ExcludeDifferent -IncludeEqual).Count * 3)

    $rsfmatches = Get-KOMatches -Round "round_4"
    $sfwinner = $null
    foreach ($m in $rsfmatches) {
        $sfwinner += $m.Vinner
    }
    $psfwinner = $prediction.M61Win, $prediction.M62Win
    
    $sfpoints = ((Compare-Object $psfwinner $sfwinner -ExcludeDifferent -IncludeEqual).Count * 4)

    $rwcwinner = Get-KOMatches -Round "round_2" | Select-Object -ExpandProperty Vinner
    $pwcwinner = $prediction.Winner
    if ($rwcwinner -eq $pwcwinner) {
        $winnerpoints = 5 
    }
    else {
        $winnerpoints = 0
    }
    [int]$Points = $ro16Points + $ro16mPoints + $qfpoints + $sfpoints + $winnerpoints
    $properties = @{
        Navn  = $prediction.Navn
        Poeng = $Points
    }
    New-Object psobject -Property $properties
}