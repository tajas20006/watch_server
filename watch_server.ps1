# Run fping and capture the output
$fpingRes = fping -u -f "$PSScriptRoot/servers.txt"

# Initialize line_res to capture the response from the LINE Notify API
$lineRes = $null

# Check if there was a response from fping
if ($fpingRes) {
    $uri = "https://notify-api.line.me/api/notify"
    $token = "Bearer $(Get-Content $PSScriptRoot/token)"
    $header = @{Authorization=$token}
    $body = @{message="unreachable`n$fpingRes"}
    
    # Capture the response from the LINE API
    $lineRes = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body $body
    Write-Host $lineRes
}

# Format the current date and time
$currentDateTime = Get-Date -Format "yyyyMMdd_HHmmss"

# Create the directory for results if it does not exist
$resultsDir = "$PSScriptRoot/result"
if (-not (Test-Path $resultsDir)) {
    New-Item -ItemType Directory -Path $resultsDir
}

# Define the file path for the CSV file
$filePath = "$resultsDir/${currentDateTime}.csv"

# Prepare the data for the CSV file
$csvData = "fping_res,line_res`n" + "`"$fpingRes`",`"$lineRes`""

# Write the data to the CSV file
$csvData | Out-File -FilePath $filePath -Encoding UTF8

exit
