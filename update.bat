:: Log function [new] ::
@echo off && setlocal enabledelayedexpansion
if "!_log!/" == "/" (
    :: Define log path ::
    set "_log=.\spicetify.log"
    :: Create a timestamp for script start ::
    for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
    set "timestamp=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2! !datetime:~8,2!:!datetime:~10,2!:!datetime:~12,2!"
    :: Log script start time ::
    echo.>> "!_log!"
    echo ------------------------------------------------------------------- >> "!_log!"
    echo.>> "!_log!"
    echo ╭╌/╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\╌╮ >> "!_log!"
    echo ┊*    [!timestamp!]     *┊ >> "!_log!"
    echo ┊*      Starting Spicetify      *┊ >> "!_log!"
    echo ╰╌\╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌/╌╯ >> "!_log!"
    echo.>> "!_log!"
    :: Pipe all output through PowerShell to remove ANSI codes ::
    2>&1 call "%~f0" | powershell "$input | ForEach-Object { $_ -replace '\x1b\[[0-9;]*m', '' }" >> "!_log!" & exit /b
@REM     :: Alt pipe that includes timestamps for all commands
@REM     2>&1 call "%~f0" | powershell "$input | ForEach-Object { $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'; \"[$timestamp] $($_ -replace '\x1b\[[0-9;]*m', '')\" }" >> "!_log!" & exit /b
)else endlocal


:: batch script ::
:start
echo ╭╌/╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\╌╮
echo ┊*      Updating Spicetify      *┊
echo ╰╌\╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌/╌╯
echo.
powershell spicetify update --no-restart
echo.
echo ╭╌/╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\╌╮
echo ┊*  Restoring Spicetify config  *┊
echo ╰╌\╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌/╌╯
echo.
powershell spicetify restore backup apply --no-restart
echo.
echo ╭╌/╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\╌╮
echo ┊*      Restarting Spotify      *┊
echo ╰╌\╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌/╌╯
echo.
powershell spicetify restart