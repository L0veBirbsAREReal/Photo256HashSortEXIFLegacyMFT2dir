$defaultFolder = "D:\"

# Junk cleanup loop
function Run-JunkCleanup {
    $defaultFolder = "D:\"
    $defaultType = "*.nomedia"

    # Define default path
$defaultFolder = "D:\"

Write-Host ""

# Prompt user input
$targetFolder = Read-Host "Enter a folder path or press 'Enter' to use default -> ($defaultFolder)"
if ([string]::IsNullOrWhiteSpace($targetFolder)) {
    $targetFolder = $defaultFolder
}
#



Write-Host "PlaySound"
Start-Process -FilePath "C:\Program Files\VideoLAN\VLC\vlc.exe" `
  -ArgumentList "--qt-start-minimized", "--play-and-exit", "--no-repeat", "--no-loop", "--play-and-exit", "`"C:\Windows\Media\ding.wav`"" `
  -WindowStyle Hidden





# --- Now it's safe to use $targetFolder ---
if (Test-Path $targetFolder) {
    Get-ChildItem $targetFolder
    # ...continue with your logic...
} else {
    Write-Host "Folder path not found: $targetFolder"
}
Write-Host ""
Write-Host "ARE YOU SURE THESE ARE THE FRESHLY COPIED FILES AT THIS LOCATION?"
    $targetFolder = Read-Host "press 'Enter' to use default OR SPECIFY ALTERNATIVE -> ($defaultFolder)"
    if ([string]::IsNullOrWhiteSpace($targetFolder)) { $targetFolder = $defaultFolder }

    $fileType = Read-Host "Enter file type (e.g. *.txt) (default: $defaultType)"
    if ([string]::IsNullOrWhiteSpace($fileType)) { $fileType = $defaultType }

    $files = Get-ChildItem -Path $targetFolder -Filter $fileType -Recurse -File

    if ($files.Count -eq 0) {
        Write-Host "No $fileType files found in $targetFolder"
    } else {
        foreach ($file in $files) {
            try {
                Remove-Item $file.FullName -Force
                Write-Host "Deleted: $($file.FullName)" -ForegroundColor Green
            } catch {
                Write-Host "Failed to delete: $($file.FullName)" -ForegroundColor Red
            }
        }

        Write-Host "`nTotal $fileType files deleted: $($files.Count)" -ForegroundColor Cyan
    }
}

do {
    Run-JunkCleanup
    $repeat = Read-Host "`nRepeat junk clean-up again? TO SKIP ENTER IS NO (Y/N)"
} while ($repeat -match "^[Yy]$")

Write-Host ""
Write-Host "Calling next script ~ sha256hashCSV.ps1"
Start-Process -FilePath "C:\Program Files\VideoLAN\VLC\vlc.exe" `
  -ArgumentList "--qt-start-minimized", "--play-and-exit", "--no-repeat", "--no-loop", "--play-and-exit", "`"C:\Windows\Media\ding.wav`"" `
  -WindowStyle Hidden

Write-Host ""

pause

& "L:\Users\User\Desktop\sha256hashCSV.ps1"
