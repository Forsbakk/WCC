. .\functions.ps1
##
##Create Group.json file
##
Get-Groups | ConvertTo-Json -Depth 4 | Out-File .\groups.json