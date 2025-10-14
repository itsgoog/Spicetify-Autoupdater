# Function to include a new line before script output
function Write-LogNew {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$Message
    )
    
    $sepLog = "`n-------------------------------------------------------------------`n"
    
    # Write to both console and log file
    Write-Host $Message
    $sepLog | Add-Content -Path ".\spicetify.log"
}
# Function to display script info w/seperators
function Write-Sep {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$mid
    )
    
    $top = "`n +/------------------------------\+`n"
    $bot = "`n +\------------------------------/+`n"
    
    Write-Host $top $mid $bot
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
    Invoke-Expression -Command $Command 2>&1 | ForEach-Object {
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