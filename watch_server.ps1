# Initialize variables to store the results of each fping attempt and the LINE response
$fpingRes1 = $fpingRes2 = $fpingRes3 = "n/a"
$lineRes = "n/a"

# Perform up to three fping checks with a 1-second pause between each
for ($i = 1; $i -le 3; $i++) {
    $tempRes = fping -u -f "$PSScriptRoot/servers.txt"
    switch ($i) {
        1 { $fpingRes1 = $tempRes }
        2 { $fpingRes2 = $tempRes }
        3 { $fpingRes3 = $tempRes }
    }
    if (-not $tempRes) { break } # Exit the loop if fping doesn't return a true-ish value
    if ($i -lt 3) { Start-Sleep -Seconds 1 }
}

# Check if all fping attempts returned a true-ish value
if ($fpingRes1 -and $fpingRes2 -and $fpingRes3) {
    $uri = "https://notify-api.line.me/api/notify"
    $token = "Bearer $(Get-Content $PSScriptRoot/token)"
    $header = @{Authorization=$token}
    $body = @{message="unreachable`n$fpingRes1, $fpingRes2, $fpingRes3"}
    
    # Capture the response from the LINE API
    $lineRes = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body $body
    Write-Host $lineRes
}

# Format the current date and time for the file name
$currentDateTime = Get-Date -Format "yyyyMMdd_HHmmss"

# Define the directory and file path for the results
$resultsDir = "$PSScriptRoot/result"
if (-not (Test-Path $resultsDir)) {
    New-Item -ItemType Directory -Path $resultsDir
}
$filePath = "$resultsDir/${currentDateTime}.csv"

# Prepare CSV data
$csvData = "fping_res1,fping_res2,fping_res3,line_res`n" + 
           "`"$fpingRes1`",`"$fpingRes2`",`"$fpingRes3`",`"$lineRes`""

# Write the CSV data to the file
$csvData | Out-File -FilePath $filePath -Encoding UTF8

exit
