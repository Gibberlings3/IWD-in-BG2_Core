
@ECHO OFF
:START



:: detect Windows version

VER |find /i "Windows 95" > NUL
IF NOT ERRORLEVEL 1 GOTO OLD

VER |find /i "Windows 98" > NUL
IF NOT ERRORLEVEL 1 GOTO OLD

VER |find /i "Windows Millennium" > NUL
IF NOT ERRORLEVEL 1 GOTO OLD

VER | find "NT" > nul
IF %errorlevel% EQU 0 GOTO OLD2

VER | find "XP" > nul
IF %errorlevel% EQU 0 GOTO NEW

VER | find "2000" > nul
IF %errorlevel% EQU 0 GOTO NEW

:: if no match, issue warning, go to new
echo Undetectable Windows version.  Probably Vista or 7. Things will probably be ok, provided you are running in admin mode or have UAC turned off.
GOTO NEW



:: Windows 9x/ME installation prompt
:OLD

echo ------------------------------------------------------
echo Enter the full path to your Baldur's Gate II installation
echo     WITHOUT ANY TERMINAL SLASHES then press Enter.
echo ------------------------------------------------------

BGT\Install\STRINGS BG2PATH=ASKweidu
ECHO %BG2PATH%>Input

GOTO CHECK


:: Windows NT installation prompt
:OLD2

echo ------------------------------------------------------
echo Enter the full path to your Baldur's Gate II installation 
echo            WITHOUT ANY TERMINAL SLASHES 
echo        followed by Ctrl+Z, then press Enter
echo ------------------------------------------------------

COPY CON Input > nul
FOR /F "delims=" %%v IN (Input) DO SET BG2PATH=%%v

GOTO CHECK


:: Windows 2000/XP and unknown OS installation prompt
:NEW

echo ------------------------------------------------------
echo Enter the full path to your Baldur's Gate II installation
echo    WITHOUT ANY TERMINAL SLASHES then press Enter.
echo ------------------------------------------------------

SET /P DIRECTORY=

SET BG2PATH=%DIRECTORY:\=/%
ECHO %BG2PATH%>Input


:: Check that the directory is valid
:CHECK

::If bgmain.exe not existant in prompted directory, fail
IF EXIST "%BG2PATH%\bgmain.exe" GOTO EXTRACTION

echo ----------------------------------------------
echo Invalid Baldur's Gate II directory, restarting...
echo ----------------------------------------------

GOTO START

:: extract bg2 game resources
:EXTRACTION

rd characters /s /q
rd ereg /s /q
rd portraits /s /q
rd save /s /q
rd scripts /s /q
rd sounds /s /q
rd temp /s /q
rd tempsave /s /q
rd override /s /q
rd data /s /q

del *.* /q

mkdir characters
mkdir data
mkdir ereg
xcopy "%BG2PATH%"\characters   characters /e
xcopy "%BG2PATH%"\data   data /e
xcopy "%BG2PATH%"\ereg         ereg /e
mkdir portraits
mkdir save
mkdir scripts
mkdir sounds
mkdir override
xcopy "%BG2PATH%"\scripts   scripts /e
xcopy "%BG2PATH%"\sounds   sounds /e
xcopy "%BG2PATH%"\override   override /e
mkdir temp
mkdir tempsave
copy  "%BG2PATH%"\baldur.ico /y
copy  "%BG2PATH%"\bgmain.exe /y
copy  "%BG2PATH%"\bgconfig.exe /y
copy  "%BG2PATH%"\dialog.tlk /y
copy  "%BG2PATH%"\chitin.key /y
copy  "%BG2PATH%"\keymap.ini /y
copy  "%BG2PATH%"\language.txt /y
copy  "%BG2PATH%"\baldur.ini /y
copy  "%BG2PATH%"\autorun.ini /y


mkdir override



iwd_in_bg2\weidu iwd_in_bg2\update-path.tp2 --yes --args-list "%CD%" "%BG2PATH%"
iwd_in_bg2\get_iwd_resources_easy.bat

