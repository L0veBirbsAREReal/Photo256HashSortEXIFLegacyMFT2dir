
$defaultFolder = "D:\"
Start-Process explorer.exe $defaultFolder
Write-Host ""
Write-Host "Manually copy all files to D:\"
Write-Host ""
pause

Write-Host ""
Start-Process -FilePath "C:\Program Files\VideoLAN\VLC\vlc.exe" `
  -ArgumentList "--qt-start-minimized", "--play-and-exit", "--no-repeat", "--no-loop", "--play-and-exit", "`"C:\Windows\Media\ding.wav`"" `
  -WindowStyle Hidden

# Visualise Disk Usage
$winDirStat = "C:\Program Files\WinDirStat\WinDirStat.exe"
if (Test-Path $winDirStat) {
    Start-Process -FilePath $winDirStat -ArgumentList $defaultFolder
} else {
    Write-Host "WinDirStat not found." -ForegroundColor Red
}

Write-Host "View > details > sortbytype hold shift to group junk files for deletion and use WinDirStat's rescan to delete large cache files or hit eneter to carry on"
Write-Host ""
Start-Process explorer.exe $defaultFolder

Write-Host ""
Write-Host "Calling next script ~ JunkCleanUp.ps1"
Start-Process -FilePath "C:\Program Files\VideoLAN\VLC\vlc.exe" `
  -ArgumentList "--qt-start-minimized", "--play-and-exit", "--no-repeat", "--no-loop", "--play-and-exit", "`"C:\Windows\Media\ding.wav`"" `
  -WindowStyle Hidden

Write-Host ""
Write-Host "Next Step is JunkCleanUp.ps1"
Write-Host ""
pause

& "L:\Users\User\Desktop\JunkCleanUp.ps1"

