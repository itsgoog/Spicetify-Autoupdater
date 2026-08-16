<#
.SYNOPSIS
    Installs Spicetify Autoupdater by creating a startup shortcut for start.vbs.
.DESCRIPTION
    Run this from the folder where you extracted the release. It checks that
    all required files are present, creates a shortcut in the Windows Startup
    folder pointing to start.vbs, and confirms the installation succeeded.
.NOTES
    If PowerShell blocks the script with an execution policy error, run:
    powershell.exe -ExecutionPolicy Bypass -File install.ps1
#>

# Displays a banner, matching the style used in spicetify.ps1
function Write-Sep {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]$Message
    )
    $top = "`n +/------------------------------\+`n"
    $bot = "`n +\------------------------------/+`n"
    Write-Host $top $Message $bot
}

function Install-AutoupdaterShortcut {
    try {
        # 1. Must be run from a saved .ps1 file, not pasted into the console
        if ([string]::IsNullOrEmpty($PSScriptRoot)) {
            throw "This script must be saved and run as a .ps1 file (it won't work if pasted directly into the console)."
        }

        # 2. Confirm the release was extracted correctly (all required files present)
        $RequiredFiles = @("start.vbs", "spicetify.ps1", "update.bat")
        foreach ($file in $RequiredFiles) {
            $path = Join-Path $PSScriptRoot $file
            if (-not (Test-Path -Path $path)) {
                throw "Required file '$file' was not found in: $PSScriptRoot`nMake sure you extracted the full release archive before running this script."
            }
        }

        $StartupPath  = [System.Environment]::GetFolderPath('Startup')
        $VbsPath      = Join-Path $PSScriptRoot "start.vbs"
        $ShortcutPath = Join-Path $StartupPath "SpicetifyAutoupdater.lnk"

        # 3. Check if already installed, and verify if the user wants to overwrite the existing shortcut
        if (Test-Path -Path $ShortcutPath) {
            Write-Host "[INFO] A Spicetify Autoupdater shortcut already exists in the Startup folder." -ForegroundColor Cyan
            $response = Read-Host "Overwrite it? (Y/N)"
            if ($response -notmatch '^[Yy]') {
                Write-Host "[SKIPPED] Installation cancelled." -ForegroundColor Yellow
                return
            }
        }

        # 4. Create the Windows shortcut
        $WScriptShell = New-Object -ComObject WScript.Shell
        try {
            $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
            $Shortcut.TargetPath       = $VbsPath
            $Shortcut.WorkingDirectory = $PSScriptRoot
            $Shortcut.Description      = "Automated Spicetify Updater"

            $Shortcut.Save()
        } finally {
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($WScriptShell) | Out-Null
        }

        # 5. Confirm the .lnk file was actually created
        if (-not (Test-Path -Path $ShortcutPath)) {
            throw "The system failed to save the shortcut in the Startup folder."
        }

        Write-Host "[OK] Shortcut created successfully in the Startup folder ($StartupPath)!" -ForegroundColor Green
        Write-Host "[OK] Spicetify Autoupdater is now installed and will run every time you log in." -ForegroundColor Green
        Write-Host "     You can test it right away by double-clicking 'start.vbs', then check 'spicetify.log' for the results." -ForegroundColor Gray

    } catch {
        Write-Host "[ERROR] Could not complete the installation." -ForegroundColor Red
        Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Sep "|*   Installing Spicetify Autoupdater   *|"
Install-AutoupdaterShortcut

# Keep the window open when double-clicked so the result can actually be read
Write-Host ""
Read-Host "Press Enter to close this window"