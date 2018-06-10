#$global:Data = Invoke-RestMethod "https://raw.githubusercontent.com/lsv/fifa-worldcup-2018/master/data.json"
$global:Data = Get-Content "C:\Users\jonas\Documents\GitHub\World Cup Competition\testdata.JSON" | ConvertFrom-Json

function Get-Team {
    Param(
        $ID
    )
    $Team = $Data | Select-Object -ExpandProperty teams | Where-Object { $_.id -eq $ID } | Select-Object -ExpandProperty Name
    return $Team
}

$gaMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty a | Select-Object -ExpandProperty matches

foreach ($match in $gaMatches) {
    if ($match.finished -eq "true") {
        
    }
}



$GroupBMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty b | Select-Object -ExpandProperty matches
$GroupCMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty c | Select-Object -ExpandProperty matches
$GroupDMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty d | Select-Object -ExpandProperty matches
$GroupEMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty e | Select-Object -ExpandProperty matches
$GroupFMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty f | Select-Object -ExpandProperty matches
$GroupGMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty g | Select-Object -ExpandProperty matches
$GroupHMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty h | Select-Object -ExpandProperty matches