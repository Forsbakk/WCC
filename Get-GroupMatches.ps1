$Data = Invoke-RestMethod "https://raw.githubusercontent.com/lsv/fifa-worldcup-2018/master/data.json"

$Teams = $Data | Select-Object -ExpandProperty teams

$GroupAMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty a | Select-Object -ExpandProperty matches
$GroupBMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty b | Select-Object -ExpandProperty matches
$GroupCMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty c | Select-Object -ExpandProperty matches
$GroupDMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty d | Select-Object -ExpandProperty matches
$GroupEMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty e | Select-Object -ExpandProperty matches
$GroupFMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty f | Select-Object -ExpandProperty matches
$GroupGMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty g | Select-Object -ExpandProperty matches
$GroupHMatches = $Data | Select-Object -ExpandProperty groups | Select-Object -ExpandProperty h | Select-Object -ExpandProperty matches


Write-Output "Group A matches"
Write-Output "----------------"
ForEach ($Match in $GroupAMatches) {
    $Properties = @{
        home_team = $Teams | Where-Object { $_.id -eq $Match.home_team } | Select-Object -ExpandProperty Name
        away_team = $Teams | Where-Object { $_.id -eq $Match.away_team } | Select-Object -ExpandProperty Name
    }
    $nmObj = New-Object psobject -Property $Properties
    Write-Output "$($nmObj.home_team) - $($nmObj.away_team)"
}
Write-Output "----------------"
Write-Output "Group B matches"
Write-Output "----------------"
ForEach ($Match in $GroupBMatches) {
    $Properties = @{
        home_team = $Teams | Where-Object { $_.id -eq $Match.home_team } | Select-Object -ExpandProperty Name
        away_team = $Teams | Where-Object { $_.id -eq $Match.away_team } | Select-Object -ExpandProperty Name
    }
    $nmObj = New-Object psobject -Property $Properties
    Write-Output "$($nmObj.home_team) - $($nmObj.away_team)"
}
Write-Output "----------------"
Write-Output "Group C matches"
Write-Output "----------------"
ForEach ($Match in $GroupCMatches) {
    $Properties = @{
        home_team = $Teams | Where-Object { $_.id -eq $Match.home_team } | Select-Object -ExpandProperty Name
        away_team = $Teams | Where-Object { $_.id -eq $Match.away_team } | Select-Object -ExpandProperty Name
    }
    $nmObj = New-Object psobject -Property $Properties
    Write-Output "$($nmObj.home_team) - $($nmObj.away_team)"
}
Write-Output "----------------"
Write-Output "Group D matches"
Write-Output "----------------"
ForEach ($Match in $GroupDMatches) {
    $Properties = @{
        home_team = $Teams | Where-Object { $_.id -eq $Match.home_team } | Select-Object -ExpandProperty Name
        away_team = $Teams | Where-Object { $_.id -eq $Match.away_team } | Select-Object -ExpandProperty Name
    }
    $nmObj = New-Object psobject -Property $Properties
    Write-Output "$($nmObj.home_team) - $($nmObj.away_team)"
}
Write-Output "----------------"
Write-Output "Group E matches"
Write-Output "----------------"
ForEach ($Match in $GroupEMatches) {
    $Properties = @{
        home_team = $Teams | Where-Object { $_.id -eq $Match.home_team } | Select-Object -ExpandProperty Name
        away_team = $Teams | Where-Object { $_.id -eq $Match.away_team } | Select-Object -ExpandProperty Name
    }
    $nmObj = New-Object psobject -Property $Properties
    Write-Output "$($nmObj.home_team) - $($nmObj.away_team)"
}
Write-Output "----------------"
Write-Output "Group F matches"
Write-Output "----------------"
ForEach ($Match in $GroupFMatches) {
    $Properties = @{
        home_team = $Teams | Where-Object { $_.id -eq $Match.home_team } | Select-Object -ExpandProperty Name
        away_team = $Teams | Where-Object { $_.id -eq $Match.away_team } | Select-Object -ExpandProperty Name
    }
    $nmObj = New-Object psobject -Property $Properties
    Write-Output "$($nmObj.home_team) - $($nmObj.away_team)"
}
Write-Output "----------------"
Write-Output "Group G matches"
Write-Output "----------------"
ForEach ($Match in $GroupGMatches) {
    $Properties = @{
        home_team = $Teams | Where-Object { $_.id -eq $Match.home_team } | Select-Object -ExpandProperty Name
        away_team = $Teams | Where-Object { $_.id -eq $Match.away_team } | Select-Object -ExpandProperty Name
    }
    $nmObj = New-Object psobject -Property $Properties
    Write-Output "$($nmObj.home_team) - $($nmObj.away_team)"
}
Write-Output "----------------"
Write-Output "Group H matches"
Write-Output "----------------"
ForEach ($Match in $GroupHMatches) {
    $Properties = @{
        home_team = $Teams | Where-Object { $_.id -eq $Match.home_team } | Select-Object -ExpandProperty Name
        away_team = $Teams | Where-Object { $_.id -eq $Match.away_team } | Select-Object -ExpandProperty Name
    }
    $nmObj = New-Object psobject -Property $Properties
    Write-Output "$($nmObj.home_team) - $($nmObj.away_team)"
}