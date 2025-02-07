Option Explicit

Dim shell, powerShellPath, scriptPath, command, exitCode

Set shell = CreateObject("WScript.Shell")

powerShellPath = "powershell.exe"
scriptPath = shell.CurrentDirectory & "\spicetify.ps1"
command = powerShellPath & " -ExecutionPolicy Bypass -NoProfile -File """ & scriptPath & """"

On Error Resume Next
exitCode = shell.Run(command, 0, True)
    ' Use 1 to show the window normally
    ' Use 0 to hide it completely
    ' Use 2 to minimize it
    ' Use 3 to maximize it

If Err.Number <> 0 Then
    WScript.Echo "Error launching PowerShell script: " & Err.Description
    WScript.Quit 1
End If
If exitCode <> 0 Then
    WScript.Echo "PowerShell script returned error code: " & exitCode
    WScript.Quit exitCode
End If

Set shell = Nothing