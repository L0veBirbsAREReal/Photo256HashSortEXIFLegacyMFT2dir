# Photo256HashSortEXIFLegacyMFT2dir

## 🖼️ TL;DR — What This Does - ✅ Sorts photos by year using metadata and hash-based de duplication - 🔍 Detects junk files, thumbnails (if specified), or .nomedia aka "junk" clutter - 🎧 Poke - Uses audio and visual cues to reduce fatigue - 🧠 Logs everything for forensic traceability - 🧪 Future implementations :: Detect Stenography and reconstruct metadata from sideloaded from redundant SDcards maybe hash via IPFS 🌐 CIDs, CIDv1 to avoid wasted drive volume. 🌀 Detected Pixel CRC Block Detection for Tamper Detection, Archival Integrity ~ help dect possible Stenography

Simple tool for non distraction sorting of photos from devices, where ability to sort source directory to USB thumb drive, Flash to MicroSDcards etc..

🧭🏚️

Working Directories**
Defaults can be moved (HIT Enter to rush through) - on the fly or edit beforehand - choices are yours..

Extract "Photo256HashSortEXIFLegacyMFT2dir.zip" to desktop Running in order..

Tested over networked drive L:\Users\User\Desktop\ Injunction with the following order;

 - Prerequisites.ps1
 - AsciiOliver.ps1
 - JunkCleanUp.ps1
 - WinDirStatCsvAudio.ps1
 - sha256hashCSV.ps1
 - ChronoSort.ps1

**Note - Native Windoze setup runs Desktop at -> "C:\Users\User\Desktop\" > right-click > "Location" Tab to change the "Files in the Desktop folder which are stored in the target location below.

You can change the location where files in this folder are stored to another place on this hard drive, another drive or another computer on your network..

- For those running their Desktop over a networked drive or running SyncThing where the repository is over the network ~ L:\Users\User\Desktop\

PS This project was being running and being uploaded when windows decided to imperative update and restart, losing 100s of hours work overriding Group Policy Edits and modified "Advanced" Power Settings, Kiosk Software and power toys.

Suggestions 2 decades of photos 256GB took ~ 3 days, therefore the thing that fooled the afk/clock that worked was a cheap analogue clock sitting under the mouse sensor when I went out..

shasum -a 256 *.ps1

12b95329a6deab4d5fe9eda16f01646b55e8a61663fa959e9847846ea279071d  L:/Users/User/Desktop/AsciiOliver.ps1
510c70d477cb0ae42e208f6f6bff0a2d738a58f221e64ff4f6f10f64032f2a09  L:/Users/User/Desktop/ChronoSort.ps1
08da9b51a660866f310f68571368046f160aa53c7df6523f83c1ef8cf93692ea  L:/Users/User/Desktop/JunkCleanUp.ps1
61caec0138b813a62353189ed021705068ae290ab3879d0d32b5bc828c0c9b6f  L:/Users/User/Desktop/Photo256HashSortEXIFLegacyMFT2dir.zip
7b04ff613096314759a35e825ea98cebae6ad171de03eca76236fc6eeea6c360  L:/Users/User/Desktop/Prerequisites.ps1
914168babed5a416f8c914456cf5304a7ae5670a4ecaa68c7f807d4feb2991de  L:/Users/User/Desktop/sha256hashCSV.ps1
f7e4f32ae01ab09ee9b12c43cf6a9afe9410053b2e9f6550c7d0767df69fcbd7  L:/Users/User/Desktop/WinDirStatCsvAudio.ps1
