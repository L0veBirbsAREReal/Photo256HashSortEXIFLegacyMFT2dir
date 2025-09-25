<#
    ChronoSort.ps1 — Legacy-Grade Archival Sorter
    Version: 1.0.0
    Author: Budgie
    Date: 2025-07-15
    Purpose: Forensic-grade file sorting by earliest timestamp (EXIF, MFT, fallback)
             with SHA256 logging, color-coded output, and fatigue-friendly UX.

    Modules:
        - Get-Metadata
        - Resolve-Timestamp
        - Write-Log
		$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
		Add-Content -Path $logFile -Value "[$timestamp] [COPY] $($file.Name) saved to $targetPath ($dateSource)"

		
        - Copy-File
        - Sound-Cue
        - Summary-Report

    Philosophy:
        - Modular, reversible, and annotated
        - Built for clarity, auditability, and legacy preservation
        - Designed to reduce fatigue and cognitive load during late-night sessions

    Notes:
        - All files logged, including duplicates
        - Symlinks/junctions excluded from scan
        - Output includes CSV + optional JSON summary
#>

# formerly filename 20250715.ps1 now ChronoSort.ps1

$sourceFolder = "D:\"
$destinationFolder = "L:\Users\User\Desktop\Destination\SortedByYear"
$csvPath = "L:\Users\User\Desktop\Destination\_SummarizeLogsCSVs\PhotoHashes.csv"
$logFile = "L:\Users\User\Desktop\Destination\_SummarizeLogsCSVs\CopyLog.txt"
$errorLogFile = "L:\Users\User\Desktop\Destination\_SummarizeLogsCSVs\ErrorList.txt"
Remove-Item $errorLogFile -ErrorAction SilentlyContinue



$copiedCount = 0
$skippedCount = 0
$errorCount   = 0



$files = Get-ChildItem -Path $sourceFolder -File -Recurse | Where-Object {
    -not ($_.Attributes -match "ReparsePoint")
}

# Clean up old log file
Remove-Item $logFile -ErrorAction SilentlyContinue

$shellApp = New-Object -ComObject Shell.Application
$entries = Import-Csv $csvPath | Where-Object { $_.Path -and $_.EffectiveDate }


$hashTracker = @{}

foreach ($file in $files) {
    $year = $null
    $dateSource = "Unknown"

    # Extract metadata
    try {
        $folder = $shellApp.Namespace((Split-Path $file.FullName))
        $item = $folder.ParseName($file.Name)
        $dateTaken = $folder.GetDetailsOf($item, 12)

        if (![string]::IsNullOrWhiteSpace($dateTaken)) {
            $year = ([datetime]::Parse($dateTaken)).Year
            $dateSource = "Date Taken"
        }
    } catch {
        Write-Host "[WARNING] Metadata extraction failed for $($file.Name)" -ForegroundColor Yellow
        Add-Content -Path $logFile -Value "[WARNING] Metadata extraction failed for $($file.Name): $_"
    }

    # Fallback timestamp
    if (-not $year) {
        if ($file.LastWriteTime -ne $null) {
            $year = $file.LastWriteTime.Year
            $dateSource = "Last Write Time"
        } elseif ($file.CreationTime -ne $null) {
            $year = $file.CreationTime.Year
            $dateSource = "Creation Time"
        } else {
            Write-Host "[WARNING] No valid date found for $($file.Name)" -ForegroundColor Yellow
            Add-Content -Path $logFile -Value "[WARNING] No valid date found for $($file.Name)"
            continue
        }
    }

    # Create target folder
    $targetPath = Join-Path $destinationFolder $year
    if (-not (Test-Path $targetPath)) {
        New-Item -ItemType Directory -Path $targetPath | Out-Null
        Write-Host "[FOLDER CREATED] $targetPath" -ForegroundColor Cyan
        Add-Content -Path $logFile -Value "[FOLDER CREATED] $targetPath"
    }

    $destinationFile = Join-Path $targetPath $file.Name

    # Hash comparison if file already exists
    if (Test-Path $destinationFile) {
        try {
            $srcHash = (Get-FileHash $file.FullName -Algorithm SHA256).Hash
            $dstHash = (Get-FileHash $destinationFile -Algorithm SHA256).Hash

            # Hash collision tracking
            if ($hashTracker.ContainsKey($srcHash)) {
                $collisionNote = "[NOTICE] Hash collision: $($file.Name) matches $($hashTracker[$srcHash])"
                Write-Host $collisionNote -ForegroundColor Magenta
                Add-Content -Path $logFile -Value $collisionNote
            } else {
                $hashTracker[$srcHash] = $file.Name
            }

            if ($srcHash -eq $dstHash) {
                $skippedCount++
                Write-Host "[SKIP] Duplicate file: $($file.Name)" -ForegroundColor DarkYellow
                Add-Content -Path $logFile -Value "[SKIP] Duplicate (hash match): $($file.Name)"
                continue
            } else {
                # Rename and copy
                $guid = [guid]::NewGuid().ToString().Substring(0, 8)
                $newName = "$([System.IO.Path]::GetFileNameWithoutExtension($file.Name))-$guid$([System.IO.Path]::GetExtension($file.Name))"
                $destinationFile = Join-Path $targetPath $newName
            }
        } catch {
            Write-Host "[ERROR] Hash check failed for $($file.Name): $_" -ForegroundColor Red
            Add-Content -Path $logFile -Value "[ERROR] Hash check failed for $($file.Name): $_"
            $errorCount++
            Add-Content -Path $errorLogFile -Value "$($file.FullName)"
            continue
        }
    }

    # Final copy attempt (normal or renamed)
    try {
        Copy-Item $file.FullName -Destination $destinationFile -ErrorAction Stop

        if (Test-Path $destinationFile) {
            Write-Host "[COPY] $($file.Name) saved to $targetPath ($dateSource)" -ForegroundColor Green
            Add-Content -Path $logFile -Value "[COPY] $($file.Name) saved to $targetPath ($dateSource)"
            $copiedCount++
        } else {
            Write-Host "[ERROR] Copy failed: $($file.Name) not found at destination" -ForegroundColor Red
            Add-Content -Path $logFile -Value "[ERROR] Copy failed: $($file.Name) not found at destination"
            $errorCount++
            Add-Content -Path $errorLogFile -Value "$($file.FullName)"
        }
    } catch {
        Write-Host "[ERROR] Failed to copy $($file.Name): $_" -ForegroundColor Red
        Add-Content -Path $logFile -Value "[ERROR] Failed to copy $($file.Name): $_"
        $errorCount++
        Add-Content -Path $errorLogFile -Value "$($file.FullName)"
    }
}



# Visualise Disk Usage
$winDirStat = "C:\Program Files\WinDirStat\WinDirStat.exe"
if (Test-Path $winDirStat) {
    Start-Process -FilePath $winDirStat -ArgumentList $destinationFolder
} else {
    Write-Host "WinDirStat not found." -ForegroundColor Red
}

Write-Host ""


Start-Process explorer.exe $destinationFolder
Start-Process notepad.exe $logFile
Start-Process notepad.exe $csvPath
Write-Host ""
Write-Host "Finished, check directory for photos by year, opening WinDirStat to observ result "


Write-Host ""
Write-Host "Calling next script X THE END ~ EXIT"
Write-Host ""
Start-Process -FilePath "C:\Program Files\VideoLAN\VLC\vlc.exe" `
  -ArgumentList "--qt-start-minimized", "--play-and-exit", "--no-repeat", "--no-loop", "--play-and-exit", "`"C:\Windows\Media\ding.wav`"" `
  -WindowStyle Hidden
Write-Host ""
Write-Host "THE END ~ EXIT"
Write-Host ""
pause