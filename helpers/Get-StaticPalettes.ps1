# Define the API endpoint
$uri = "http://colormind.io/api/"

# Prepare to collect palettes
$palettes = @()

# Loop to fetch 100 random palettes
for ($i = 0; $i -lt 100; $i++) {
    Start-Sleep -Seconds 1
    # Define the body of the request for a random palette
    $body = @{ model = "default" } | ConvertTo-Json

    # Make the POST request
    $response = Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType "application/json"

    # Store the result in the array
    $palettes += ,$response.result
}

# Output palettes to the console
# $palettes

# Convert palettes to JSON and save to a file
$Text = $palettes | ConvertTo-Json | Out-String
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
$EncodedText =[Convert]::ToBase64String($Bytes)

if ($IsWindows) {
    $Path = "c:\temp\B64 encoded palette.txt"
}

if ($IsLinux) {
    $Path = "/tmp/B64 encoded palette.txt"
}

$EncodedText | Out-File $Path