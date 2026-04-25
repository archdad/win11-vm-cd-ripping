# Webhook URL
$webhookUrl = "http://your-domain-or-ip/webhook"

# How often to check (seconds)
$pollInterval = 2

Write-Host "Monitoring CD drive for media removal..."

# Track previous state
$previousHasMedia = $false

while ($true) {
    try {
        # Get all CD/DVD drives (DriveType 5)
        $cdDrives = Get-CimInstance Win32_LogicalDisk | Where-Object {
            $_.DriveType -eq 5
        }

        foreach ($drive in $cdDrives) {

            # If drive has media, VolumeName will NOT be null
            $hasMedia = [bool]$drive.VolumeName

            # Detect transition: media present → removed
            if ($previousHasMedia -and -not $hasMedia) {
                Write-Host "CD ejected from $($drive.DeviceID) → sending webhook"

                try {
                    Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "application/json" -Body "{}"
                } catch {
                    Add-Content -Path "C:\Scripts\cd_watcher_error.log" -Value "$(Get-Date): $_"
                }
            }

            # Update state
            $previousHasMedia = $hasMedia
        }

    } catch {
        Add-Content -Path "C:\Scripts\cd_watcher_error.log" -Value "$(Get-Date): $_"
    }

    Start-Sleep -Seconds $pollInterval
}
