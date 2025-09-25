<# ============================
# SHA256 Hashing + Metadata CSV
# =============================
#>

Write-Host ""
Write-Host "Before we start"
Write-Host ""

$source     = "D:\"
$outputCSV  = "L:\Users\User\Desktop\Destination\_SummarizeLogsCSVs\PhotoHashes.csv"
$scanID     = "SCAN_" + (Get-Date -Format "yyyyMMdd_HHmmss")
$existing   = @{}

# Load sound cue function
function Play-Ding {
    [console]::beep(1000, 300)
}

# Load existing hashes if CSV exists
if (Test-Path $outputCSV) {
    $existing = Import-Csv $outputCSV | Group-Object Path -AsHashTable -AsString
    Write-Host " Existing hash records loaded: $($existing.Count)" -ForegroundColor Yellow
}

# Metadata extraction function
function Get-Metadata {
    param ($file)
    $meta = [ordered]@{
        DateTaken   = $null
        MetaSummary = ""
    }

    try {
        $shell = New-Object -ComObject Shell.Application
        $folder = $shell.Namespace((Split-Path $file.FullName))
        $item = $folder.ParseName($file.Name)

        $meta.DateTaken   = $folder.GetDetailsOf($item, 12) # Date Taken
        $meta.MetaSummary = "EXIF:$($folder.GetDetailsOf($item, 12));MOD:$($folder.GetDetailsOf($item, 4))"
    } catch {
        $meta.MetaSummary = "Shell COM failed"
    }

    return $meta
}

# Get all files
$files = Get-ChildItem -Path $source -Recurse -File -ErrorAction SilentlyContinue
$hashList = @()
$counter = 0
$total = $files.Count

foreach ($file in $files) {
    $counter++
    Write-Host "[$counter/$total] Processing: $($file.FullName)" -ForegroundColor Cyan


    # Hash file
    try {
        $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256 | Select-Object -ExpandProperty Hash
    } catch {
        $hash = "ERROR"
    }

    # Metadata
    $meta = Get-Metadata -file $file

    # Effective date logic
    $dates = @(
        $meta.DateTaken,
        $file.CreationTimeUtc,
        $file.LastWriteTimeUtc
    ) | Where-Object { $_ -ne $null } | Sort-Object
    $effectiveDate = $dates[0]

    # Build output object
    $output = [PSCustomObject]@{
        Name          = $file.Name
        Path          = $file.FullName
        Hash          = $hash
        Size          = $file.Length
        DateTaken     = $meta.DateTaken
        Created       = $file.CreationTimeUtc
        Modified      = $file.LastWriteTimeUtc
        EffectiveDate = $effectiveDate
        MetaSummary   = $meta.MetaSummary
        ScanID        = $scanID
    }

        # Visual feedback block
    Write-Host "[$counter/$total] $($file.Name)" -ForegroundColor Cyan
    Write-Host " -> Hash: $hash" -ForegroundColor DarkGray
    Write-Host " --> EffectiveDate: $effectiveDate" -ForegroundColor DarkCyan
    Write-Host " ---> $($meta.MetaSummary)" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Magenta


    $hashList += $output
}

# Append to CSV
if ($hashList.Count -gt 0) {
    $hashList | Export-Csv -Path $outputCSV -Append -NoTypeInformation -Encoding UTF8
    Write-Host "`n New hashes saved to $outputCSV" -ForegroundColor Green
    Play-Ding
} else {
    Write-Host "`n No new files to hash. All up to date." -ForegroundColor Gray
}

# ─── Summary Block ─────────────────────────────────────────────
Write-Host "`n[🔍 SUMMARY BLOCK]" -ForegroundColor Cyan

$totalFiles     = $hashList.Count
$uniqueHashes   = ($hashList.Hash | Where-Object { $_ -ne "ERROR" } | Select-Object -Unique).Count
$duplicateCount = $totalFiles - $uniqueHashes
$errorCount     = ($hashList | Where-Object { $_.Hash -eq "ERROR" }).Count

Write-Host "📦 Total files hashed:     $totalFiles"     -ForegroundColor White
Write-Host "✅ Unique hashes:          $uniqueHashes"   -ForegroundColor Green
Write-Host "⚠️ Duplicates flagged:     $duplicateCount" -ForegroundColor Yellow

if ($errorCount -gt 0) {
    Write-Host "❌ Errors encountered:     $errorCount" -ForegroundColor Red
    $hashList | Where-Object { $_.Hash -eq "ERROR" } | ForEach-Object {
        Write-Host "   🔸 $($_.Path)" -ForegroundColor DarkRed
    }
} else {
    Write-Host "🟢 No errors encountered." -ForegroundColor Green
}
# ───────────────────────────────────────────────────────────────





Write-Host ""

Start-Process explorer.exe $source
Start-Process notepad.exe $outputCSV

Write-Host ""
Write-Host "Calling next script ~ ChronoSort.ps1"
Start-Process -FilePath "C:\Program Files\VideoLAN\VLC\vlc.exe" `
  -ArgumentList "--qt-start-minimized", "--play-and-exit", "--no-repeat", "--no-loop", "--play-and-exit", "`"C:\Windows\Media\ding.wav`"" `
  -WindowStyle Hidden

Write-Host ""

pause

& "L:\Users\User\Desktop\ChronoSort.ps1"