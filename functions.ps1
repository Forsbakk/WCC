#$global:Data = Invoke-RestMethod "https://raw.githubusercontent.com/lsv/fifa-worldcup-2018/master/data.json"
$global:Data = Get-Content ".\testdata.json" | ConvertFrom-Json
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
            Teams = $ids | ForEach-Object {
                New-Object psobject -Property @{ ID = $_; Name = Get-Team -ID $_; Played = [int]0; Win = [int]0; Draw = [int]0; Loss = [int]0; Points = [int]0; GoalIn = [int]0; GoalOut = [int]0 }
            }
        }
        New-Object psobject -Property $Groups
    }
}

function Get-GroupStandings {
    $gi = "a", "b", "c", "d", "e", "f", "g", "h"

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


function New-PredictionMenu {
    Param(
        $GruppeNavn
    )
    $menu = @{}
    $grpmenu = $Groups | Where-Object { $_.Name -eq $GruppeNavn } | Select-Object -ExpandProperty Teams | Select-Object -ExpandProperty Name
    for ($i = 1; $i -le $grpmenu.Count; $i++) {
        Write-Host "$i.$($grpmenu[$i-1])"
        $menu.Add($i, $grpmenu[$i - 1])
    }
    [int]$grpwin = Read-Host "Vinner $GruppeNavn"
    [int]$grpsec = Read-Host "Nummer 2 $GruppeNavn"
    $grpwinname = $menu.Item($grpwin)
    $grpsecname = $menu.Item($grpsec)
    Write-Output $grpwinname
    Write-Output $grpsecname
}

function New-Prediction {
    $Predictor = Read-Host "Navnet til tipper"
    $grpa = New-PredictionMenu -GruppeNavn "Gruppe A"
    $grpb = New-PredictionMenu -GruppeNavn "Gruppe B"
    $grpc = New-PredictionMenu -GruppeNavn "Gruppe C"
    $grpd = New-PredictionMenu -GruppeNavn "Gruppe D"
    $grpe = New-PredictionMenu -GruppeNavn "Gruppe E"
    $grpf = New-PredictionMenu -GruppeNavn "Gruppe F"
    $grpg = New-PredictionMenu -GruppeNavn "Gruppe G"
    $grph = New-PredictionMenu -GruppeNavn "Gruppe H"
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
    }
    $properties | ConvertTo-Json -Compress | Out-File "predictions\$Predictor.json"
}