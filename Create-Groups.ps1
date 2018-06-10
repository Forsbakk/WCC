$global:Data = Invoke-RestMethod "https://raw.githubusercontent.com/lsv/fifa-worldcup-2018/master/data.json"

function Get-Team {
    Param(
        $ID
    )
    $Team = $Data | Select-Object -ExpandProperty teams | Where-Object { $_.id -eq $ID } | Select-Object -ExpandProperty Name
    return $Team
}

function Get-Groups {
    [cmdletbinding()]
    
    $Group = "a","b","c","d", "e", "f", "g", "h"
    
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
                Name = "Gruppe $($i.ToUpper())"
                Teams = $ids | ForEach-Object {
                    New-Object psobject -Property @{ ID = $_ ; Name = Get-Team -ID $_ }   
                }
            }
        New-Object psobject -Property $Groups
    }
}

$Groups = Get-Groups