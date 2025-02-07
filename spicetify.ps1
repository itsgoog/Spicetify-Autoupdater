# Function to include a new line before script output
function Write-LogNew {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$Message
    )
    
    $sepnew = "`n-------------------------------------------------------------------`n"
    
    # Write to both console and log file
    Write-Host $Message  # Keeps original colored output in console
    $sepnew | Add-Content -Path ".\spicetify.log"
}
# Function to display script info w/seperators
function Write-Sep {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$Mid
    )
    
    $top = "`n +/------------------------------\+`n"
    $bot = "`n +\------------------------------/+`n"
    
    Write-Host $top $Mid $bot
}
# Function that logs output with timestamps and removes ANSI color codes
function Write-LogMessage {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$Message
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $cleanMessage = $Message -replace '\x1b\[[0-9;]*m', ''
    $logEntry = "[$timestamp] $cleanMessage"
    
    # Skip empty messages
    if ([string]::IsNullOrWhiteSpace($Message)) { return }
    
    # Write to log file
    Write-Host $Message
    $logEntry | Add-Content -Path ".\spicetify.log"
}
# Function to execute commands and handle individual output in real-time
function Invoke-CommandWithLogging {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    
    Write-LogMessage "$Command"
    
    $result = Invoke-Expression -Command $Command 2>&1 | ForEach-Object {
        $_ | Write-LogMessage
    }
}


# Script start
Write-LogNew

$sep = "|*      Updating Spicetify      *|"
Write-Sep $sep
"$sep" | Add-Content -Path ".\spicetify.log"
Invoke-CommandWithLogging "spicetify update --no-restart"

$sep = "|*  Restoring Spicetify config  *|"
Write-Sep $sep
"$sep" | Add-Content -Path ".\spicetify.log"
Invoke-CommandWithLogging "spicetify restore backup apply --no-restart"

$sep = "|*      Restarting Spotify      *|"
Write-Sep $sep
"$sep" | Add-Content -Path ".\spicetify.log"
Invoke-CommandWithLogging "spicetify restart"


# If running in the console, wait for input before closing
# if ($Host.Name -eq "ConsoleHost")
# {
#     Write-Host "Press any key to end..."
#     $Host.UI.RawUI.FlushInputBuffer()   # Make sure buffered input doesn't "press a key" and skip the ReadKey().
#     $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
# }