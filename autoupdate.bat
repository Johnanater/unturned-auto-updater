@echo off
title Auto Update - Unturned
echo =-= Auto Update for Unturned =-=
echo     =-=Made by Johnanater=-=
echo.
::Version: 1.0

::Config
SETLOCAL ENABLEDELAYEDEXPANSION
	::Steam username and password
	::I recommend that you make another account for this!
	SET SteamUser=YourUsername
	SET SteamPass=YourPassword
	
	::Should the updater download Rocket?
	::https://rocketmod.net/
	::true/false
	SET DownloadRocket=true
	
	::How often should it check for an update? Time is in seconds!
	SET WaitTime=300
	
	::Put your path to the servers here!
	SET ServerPath=C:\Unturned\


::=======================================================================================::
:: I wouldn't edit anything past here if I were you, but if you want to, go right ahead! ::
::=======================================================================================::


:start
::Checks if SteamCMD and serverver.txt are present
::(Windows asks if serverver.txt is a file or directory when copying it if it doesn't already exist)

if not exist temp\ (
	mkdir temp
)

if not exist lib\SteamCMD\steamcmd.exe (
	echo.
	echo SteamCMD not detected, downloading it now...
	echo.
	lib\wget.exe -O temp\SteamCMD.zip https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip
	title Auto Update - Unturned
	powershell.exe -command "Expand-Archive temp\SteamCMD.zip lib\SteamCMD\ -Force" >nul
	del temp\SteamCMD.zip
	echo.
	echo SteamCMD has been downloaded^^!
	echo.
)

if not exist temp\serverver.txt (
	echo Serverver.txt not detected, creating it...
	echo.
	echo   > temp\serverver.txt
)

::Login to Steam and download the Unturned info. Then isolate the string
::The appcache has to be deleted in order for SteamCMD to actually update the app info
::Yes... I used sed and wget... (Sed is win-bash and wget is mingw32)
if exist "lib\SteamCMD\appcache\appinfo.vdf" (del /f lib\SteamCMD\appcache\appinfo.vdf)
lib\SteamCMD\steamcmd.exe +login %SteamUser% %SteamPass% +app_info_update 1 +app_info_print "304930" +app_info_print "304930" +quit | findstr /r "buildid" > temp\vers.txt
lib\sed.exe 2,9d temp\vers.txt > temp\version.txt

::Setting variables
SET /p ServerVer=<temp\serverver.txt
SET /p SteamVer=<temp\version.txt

::Setting variables
SET /p ServerVer=<temp\serverver.txt
SET /p SteamVer=<temp\version.txt
	
::If the two versions match, repeat. If they don't, update the server
if "%ServerVer%"=="%SteamVer%" (TIMEOUT %WaitTime% && goto start)

cls
title Auto Update - Updating

echo.
echo Update detected^^! Starting update at %DATE% - %TIME%^^!
echo ===================================================================
echo.
echo.
echo Copying version.txt to serverver.txt...
echo.
copy "temp\version.txt" "temp\serverver.txt" >nul

lib\Restart.exe 
echo Saving and shutting down all servers at %DATE% / %TIME%...
echo.

::I've had troubles with Unturned.exe still running, so let's wait...
echo Waiting for rogue Unturned.exe's to end...
TIMEOUT 60
echo.
TASKKILL /IM Unturned.exe
echo Unturned.exe taskkilled at %DATE% / %TIME%^^!

::Let's wait again just to make sure...
TIMEOUT 5 >nul

cls
echo Starting Unturned update at %DATE% / %TIME%^^!
echo ================================================================
echo.
echo.
lib\SteamCMD\steamcmd.exe +login %SteamUser% %SteamPass% +force_install_dir %ServerPath% +"app_update 304930" validate +quit
cls

if "%DownloadRocket%"=="true" (
	echo Starting download of Rocket
	echo ==============================
	echo.
	echo.
	lib\wget.exe -O temp\rocket.zip https://ci.rocketmod.net/job/Rocket.Unturned/lastSuccessfulBuild/artifact/Rocket.Unturned/bin/Release/Rocket.zip
	title Auto Update - Unturned
	powershell.exe -command "Expand-Archive temp\rocket.zip %ServerPath% -Force"
	del temp\rocket.zip
)

cls
echo Your Unturned Server is up to date at %DATE% / %TIME%^^!
echo ======================================================================
echo.

echo Starting servers...
lib\Start.exe

::Let the user read
timeout 5 >nul
cls

::Update has finished, now go back to the start.
echo Checking for updates...
echo =========================
echo.
timeout %WaitTime%
goto start
