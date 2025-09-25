# @echo off

# Set-ExecutionPolicy RemoteSigned -ErrorAction Stop
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -ErrorAction Stop


Future implemantations  Detect steganography and reconstruct metadata

<# Working DIR // Tested directory L:\Users\User\Desktop

"C:\Users\User\Desktop\" > right-click > "Location" Tab to change the "Files in the Desktop folder which are stored in the target location below.

You can change the location where files in this folder are stored to anoither place on this hard drive, another drive or another computer on your network..

<"L:\Users\User\Desktop">

See <a href="https://thegeekpage.com/wp-content/uploads/2020/05/Desktop-Properties-Location-tab-Move.png">Desktop-Properties-Location-tab-Move</a>

Running in order,,..

Following

Prerequisites.ps1
AsciiOliver.ps1
JunkCleanUp.ps1
WinDirStatCsvAudio.ps1
sha256hashCSV.ps1
ChronoSort.ps1

#>


pause

Write-Host "If error above (continues to) relates to these commands 'Set-ExecutionPolicy RemoteSigned' "
Write-Host "Then perhaps I'll leave them toggeled off for this experiment '----------------et-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass' "

Write-Host "UAC // Run As Admin to avoid above error?"
Write-Host ""
Write-Host "You maybe be here a while, chimes will ding maybe install some software from ninte.com.. "
Write-Host "Install and Update All Your Programs at Once"
Write-Host "No toolbars. No clicking next. Just pick your apps and go. "
Write-Host ""
Write-Host "UAC // Run As Admin to avoid above error?"
Write-Host ""
Start-Process "msedge.exe" "https://ninite.com/"
Write-Host ""
Write-Host "Read about StegHide and learn about Stenography"
Start-Process "https://steghide.sourceforge.net/index.php"
Write-Host ""
Write-Host "Install VLC and WinDirStat via powershell"
Write-Host ""
Write-Host "Install VLC"
Write-Host ""

# Check if winget is available
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Winget not found. Please update your system or install App Installer from Microsoft Store." -ForegroundColor Red
    exit 1
}

# Install VLC Media Player
Write-Host "📦 Installing VLC Media Player..." -ForegroundColor Cyan

$job = Start-Job { winget install --id VideoLAN.VLC -e --silent }

$duration = 30  # estimated time in seconds
for ($i = 0; $i -le $duration; $i++) {
    $percent = [math]::Round(($i / $duration) * 100)
    Write-Progress -Activity "Installing VLC" -Status "$percent% Complete" -PercentComplete $percent
    Start-Sleep -Seconds 1
    if ($job.State -ne 'Running') { break }
}

Receive-Job $job



Write-Host "Install WinDirStat"

Write-Host ""

$job = Start-Job { winget install --id WinDirStat.WinDirStat -e --silent }

$duration = 30  # estimated time in seconds
for ($i = 0; $i -le $duration; $i++) {
    $percent = [math]::Round(($i / $duration) * 100)
    Write-Progress -Activity "WinDirStat" -Status "$percent% Complete" -PercentComplete $percent
    Start-Sleep -Seconds 1
    if ($job.State -ne 'Running') { break }
}

Receive-Job $job

$outputCSV  = "L:\Users\User\Desktop\Destination\_SummarizeLogsCSVs\PhotoHashes.csv"

Write-Host "Create outputCSV ONLY IF NOT EXIT!"

# Ensure CSV exists with headers — never overwrite
if (-not (Test-Path $outputCSV)) {
    Write-Host "Creating new CSV with headers..." -ForegroundColor Cyan

    [PSCustomObject]@{
        Name          = ''
        Path          = ''
        Hash          = ''
        Size          = ''
        DateTaken     = ''
        Created       = ''
        Modified      = ''
        EffectiveDate = ''
        MetaSummary   = ''
        ScanID        = ''
    } | Export-Csv -Path $outputCSV -NoTypeInformation -Encoding UTF8
}



Write-Host ""
Write-Host "Calling next script ~ AsciiOliver.ps1"
Start-Process -FilePath "C:\Program Files\VideoLAN\VLC\vlc.exe" `
  -ArgumentList "--qt-start-minimized", "--play-and-exit", "--no-repeat", "--no-loop", "--play-and-exit", "`"C:\Windows\Media\ding.wav`"" `
  -WindowStyle Hidden

Write-Host ""

Write-Host "Copy files to D:\"
Write-Host ""

pause
Write-Host ""
& "L:\Users\User\Desktop\AsciiOliver.ps1"
Write-Host ""
Write-Host "Prerequisites.ps1 FINISHED"

exit

<#  

Implenmentations..

#>