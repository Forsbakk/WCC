. .\functions.ps1
##
##Create Group.json file
##
Get-Groups | ConvertTo-Json -Depth 4 -Compress | Out-File .\groups.json