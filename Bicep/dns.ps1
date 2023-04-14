$headers = @{
    "Authorization" = "Bearer $Env:APIKey"
    "Content-Type"  = "application/json"
}

$records = Invoke-RestMethod `
  -Uri "https://api.cloudflare.com/client/v4/zones/$Env:ZoneId/dns_records?name=www.orsclab.com" `
  -Headers $headers `
  -Method 'GET'

$cnameRecords = $records.result | Where-Object { $_.Type -eq "CNAME" }

if ($null -ne $cnameRecords) {
  if ($cnameRecords.content -ne $Env:HostName) {
    # Update CNAME
    $recordId = $cnameRecords.id
    $url = "https://api.cloudflare.com/client/v4/zones/$Env:ZoneId/dns_records/$recordId"
    $body = @{ "content" = $Env:HostName } | ConvertTo-Json
    Invoke-RestMethod `
      -Uri $url `
      -Headers $headers `
      -Method PATCH `
      -Body $body
      Start-Sleep -Seconds 300
  }
}
else {
    # Create CNAME
    $body = @{
      "type" = "CNAME"
      "name" = "www"
      "content" = $Env:HostName
      "ttl" = 300
      "proxied" = $False
    } | ConvertTo-Json
    Invoke-RestMethod `
      -Uri "https://api.cloudflare.com/client/v4/zones/$Env:ZoneId/dns_records" `
      -Headers $headers `
      -Method POST `
      -Body $body
}
