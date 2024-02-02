$res = fping -u -f "$PSScriptRoot/servers.txt"
if ($res) {
  $uri = "https://notify-api.line.me/api/notify"
  $token = "Bearer $(Get-Content $PSScriptRoot/token)"
  $header = @{Authorization=$token}
  $body = @{message="unreachable`n$res"}
  $res = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body $body

  write-host $res
}
exit
