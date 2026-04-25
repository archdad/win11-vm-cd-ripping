Simple powershell script to call a webhook when the drive is ejected. Useful for ripping audio CDs to FLAC with Exact Audio Copy. (Be sure to set EAC to eject the CD upon completion).

Can call a webhook to your notification service of choice. Example: Home Assistant automation to notify via the mobile app.

Run with:
```
powershell.exe -ExecutionPolicy Bypass -File C:\Scripts\eject.ps1
```
