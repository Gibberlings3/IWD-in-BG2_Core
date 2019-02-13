:: modified by David

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
echo Enter the full path to your Icewind Dale installation
echo     WITHOUT ANY TERMINAL SLASHES then press Enter.
echo ------------------------------------------------------

BGT\Install\STRINGS IWDPATH=ASK
ECHO %IWDPATH%>Input

GOTO CHECK


:: Windows NT installation prompt
:OLD2

echo ------------------------------------------------------
echo Enter the full path to your Icewind Dale installation 
echo            WITHOUT ANY TERMINAL SLASHES 
echo        followed by Ctrl+Z, then press Enter
echo ------------------------------------------------------

COPY CON Input > nul
FOR /F "delims=" %%v IN (Input) DO SET IWDPATH=%%v

GOTO CHECK


:: Windows 2000/XP and unknown OS installation prompt
:NEW

echo ------------------------------------------------------
echo Enter the full path to your Icewind Dale installation
echo                 then press Enter.
echo ------------------------------------------------------

SET /P DIRECTORY=

SET IWDPATH=%DIRECTORY:\=/%
ECHO %IWDPATH%>Input


:: Check that the directory is valid
:CHECK

::If idmain.exe not existant in prompted directory, fail
IF EXIST "%IWDPATH%\idmain.exe" GOTO EXTRACTION

echo ----------------------------------------------
echo Invalid Icewind Dale directory, restarting...
echo ----------------------------------------------

GOTO START



:: extract iwd game resources

:EXTRACTION

:: make destination files

MKDIR iwd_in_bg2\biff
MKDIR iwd_in_bg2\music
MKDIR iwd_in_bg2\override
MKDIR iwd_in_bg2\real_override
MKDIR iwd_in_bg2\rules
MKDIR iwd_in_bg2\sounds
MKDIR iwd_in_bg2\workspace

:: make files for BIFFs

MKDIR iwd_in_bg2\biff\bcs_dlg
MKDIR iwd_in_bg2\biff\CRE_anim
MKDIR iwd_in_bg2\biff\CRE_anim2
MKDIR iwd_in_bg2\biff\cre_ini
MKDIR iwd_in_bg2\biff\CRE_snd
MKDIR iwd_in_bg2\biff\dialog_snd
MKDIR iwd_in_bg2\biff\extra
MKDIR iwd_in_bg2\biff\gen_cre
MKDIR iwd_in_bg2\biff\gui
MKDIR iwd_in_bg2\biff\item_icons
MKDIR iwd_in_bg2\biff\itm_spl
MKDIR iwd_in_bg2\biff\misc
MKDIR iwd_in_bg2\biff\misc_anim
MKDIR iwd_in_bg2\biff\misc_snd
MKDIR iwd_in_bg2\biff\mos_bmp
MKDIR iwd_in_bg2\biff\narr_files
MKDIR iwd_in_bg2\biff\new_map
MKDIR iwd_in_bg2\biff\spell_icons
MKDIR iwd_in_bg2\biff\spl_anim
MKDIR iwd_in_bg2\biff\spl_snd


IF NOT EXIST "iwd_in_bg2\lib\file_missing_marker.txt" GOTO RESCOPY

:: remove old marker to check if files were copied over successfully

DEL iwd_in_bg2\lib\file_missing_marker.txt

:: change to the IWD directory and run a WEIDU script to copy over needed resources

:RESCOPY

SET CONVPATH=%CD%
SET IWDPATHFWS=%IWDPATH:/=\%

COPY iwd_in_bg2\weidu.exe "%IWDPATH%"\setup-get_iwd_resources.exe
COPY iwd_in_bg2\lib\get_iwd_resources.tp2 "%IWDPATH%"\setup-get_iwd_resources.tp2

CD /D "%IWDPATHFWS%"

del /s/q cache

setup-get_iwd_resources  --args "%CONVPATH%" --force-install 0

:: go back to the main directory and copy over some more files

CD /D "%CONVPATH%"


IF EXIST "iwd_in_bg2\lib\file_missing_marker.txt" GOTO END



iwd_in_bg2\weidu --game "%IWDPATH%" --out iwd_in_bg2\override --biff-get-rest  .*.mve$  .*.tis$  .*.wed$ .*.bmp$

xcopy "%IWDPATH%"\music        iwd_in_bg2\music      /e
xcopy "%IWDPATH%"\sounds       iwd_in_bg2\sounds     /e

:: sort out movies

cd iwd_in_bg2\override

ren intro.mve   intro15f.mve
ren bislogo.mve bwdragon.mve

IF NOT EXIST "ar9100.tis" goto renend

ren howseer.mve intro.mve

:renend

cd ..\..


mkdir cdiwdmve
move iwd_in_bg2\override\*.mve cdiwdmve

iwd_in_bg2\movie\fsp cdiwdmve\howdrag.mve

iwd_in_bg2\movie\avi2mve howdrag.avi cdiwdmve\howdrag.mve -size 50


iwd_in_bg2\weidu --make-biff cdiwdmve
rd cdiwdmve /s /q
del howdrag.avi /q
:AREA_BIFF

mkdir cd1000
mkdir cd2000
mkdir cd3000
mkdir cd4000
mkdir cd5000
mkdir cd6000
mkdir cd7000
mkdir cd8000

cd iwd_in_bg2

tis2bg2 -d -sw override\ar1000 ..\cd1000\ar1000
tis2bg2 -d -sw override\ar1001 ..\cd1000\ar1001
tis2bg2 -d -sw override\ar1002 ..\cd1000\ar1002
tis2bg2 -d -sw override\ar1003 ..\cd1000\ar1003
tis2bg2 -d -sw override\ar1004 ..\cd1000\ar1004
tis2bg2 -d -sw override\ar1005 ..\cd1000\ar1005
tis2bg2 -d -sw override\ar1006 ..\cd1000\ar1006
tis2bg2 -d -sw override\ar1007 ..\cd1000\ar1007
tis2bg2 -d -sw override\ar1008 ..\cd1000\ar1008
tis2bg2 -d -sw override\ar1009 ..\cd1000\ar1009
tis2bg2 -d -sw override\ar1010 ..\cd1000\ar1010
tis2bg2 -d -sw override\ar1011 ..\cd1000\ar1011
tis2bg2 -d -sw override\ar1012 ..\cd1000\ar1012
tis2bg2 -d -sw override\ar1013 ..\cd1000\ar1013
tis2bg2 -d -sw override\ar1014 ..\cd1000\ar1014
tis2bg2 -d -sw override\ar1015 ..\cd1000\ar1015
tis2bg2 -d -sw override\ar1016 ..\cd1000\ar1016
tis2bg2 -d -sw override\ar1100 ..\cd1000\ar1100
tis2bg2 -d -sw override\ar1101 ..\cd1000\ar1101
tis2bg2 -d -sw override\ar1102 ..\cd1000\ar1102
tis2bg2 -d -sw override\ar1103 ..\cd1000\ar1103
tis2bg2 -d -sw override\ar1104 ..\cd1000\ar1104
tis2bg2 -d -sw override\ar1105 ..\cd1000\ar1105
tis2bg2 -d -sw override\ar1106 ..\cd1000\ar1106
tis2bg2 -d -sw override\ar1109 ..\cd1000\ar1109
tis2bg2 -d -sw override\ar1200 ..\cd1000\ar1200
tis2bg2 -d -sw override\ar1201 ..\cd1000\ar1201

tis2bg2 -d -sw override\ar2000 ..\cd2000\ar2000
tis2bg2 -d -sw override\ar2001 ..\cd2000\ar2001
tis2bg2 -d -sw override\ar2002 ..\cd2000\ar2002
tis2bg2 -d -sw override\ar2003 ..\cd2000\ar2003
tis2bg2 -d -sw override\ar2004 ..\cd2000\ar2004
tis2bg2 -d -sw override\ar2005 ..\cd2000\ar2005
tis2bg2 -d -sw override\ar2006 ..\cd2000\ar2006
tis2bg2 -d -sw override\ar2100 ..\cd2000\ar2100
tis2bg2 -d -sw override\ar2101 ..\cd2000\ar2101
tis2bg2 -d -sw override\ar2102 ..\cd2000\ar2102
tis2bg2 -d -sw override\ar2103 ..\cd2000\ar2103
tis2bg2 -d -sw override\ar2104 ..\cd2000\ar2104
tis2bg2 -d -sw override\ar2105 ..\cd2000\ar2105
tis2bg2 -d -sw override\ar2106 ..\cd2000\ar2106
tis2bg2 -d -sw override\ar2107 ..\cd2000\ar2107
tis2bg2 -d -sw override\ar2108 ..\cd2000\ar2108
tis2bg2 -d -sw override\ar2109 ..\cd2000\ar2109
tis2bg2 -d -sw override\ar2110 ..\cd2000\ar2110
tis2bg2 -d -sw override\ar2111 ..\cd2000\ar2111
tis2bg2 -d -sw override\ar2112 ..\cd2000\ar2112
tis2bg2 -d -sw override\ar2113 ..\cd2000\ar2113
tis2bg2 -d -sw override\ar2114 ..\cd2000\ar2114
tis2bg2 -d -sw override\ar2115 ..\cd2000\ar2115
tis2bg2 -d -sw override\ar2116 ..\cd2000\ar2116

tis2bg2 -d -sw override\ar3000 ..\cd3000\ar3000
tis2bg2 -d -sw override\ar3001 ..\cd3000\ar3001
tis2bg2 -d -sw override\ar3101 ..\cd3000\ar3101
tis2bg2 -d -sw override\ar3201 ..\cd3000\ar3201
tis2bg2 -d -sw override\ar3301 ..\cd3000\ar3301
tis2bg2 -d -sw override\ar3401 ..\cd3000\ar3401
tis2bg2 -d -sw override\ar3501 ..\cd3000\ar3501
tis2bg2 -d -sw override\ar3502 ..\cd3000\ar3502
tis2bg2 -d -sw override\ar3503 ..\cd3000\ar3503
tis2bg2 -d -sw override\ar3600 ..\cd3000\ar3600
tis2bg2 -d -sw override\ar3601 ..\cd3000\ar3601
tis2bg2 -d -sw override\ar3602 ..\cd3000\ar3602
tis2bg2 -d -sw override\ar3603 ..\cd3000\ar3603

tis2bg2 -d -sw override\ar4000 ..\cd4000\ar4000
tis2bg2 -d -sw override\ar4001 ..\cd4000\ar4001
tis2bg2 -d -sw override\ar4002 ..\cd4000\ar4002
tis2bg2 -d -sw override\ar4003 ..\cd4000\ar4003
tis2bg2 -d -sw override\ar4004 ..\cd4000\ar4004
tis2bg2 -d -sw override\ar4005 ..\cd4000\ar4005

tis2bg2 -d -sw override\ar5000 ..\cd5000\ar5000
tis2bg2 -d -sw override\ar5001 ..\cd5000\ar5001
tis2bg2 -d -sw override\ar5002 ..\cd5000\ar5002
tis2bg2 -d -sw override\ar5003 ..\cd5000\ar5003
tis2bg2 -d -sw override\ar5004 ..\cd5000\ar5004
tis2bg2 -d -sw override\ar5101 ..\cd5000\ar5101
tis2bg2 -d -sw override\ar5102 ..\cd5000\ar5102
tis2bg2 -d -sw override\ar5103 ..\cd5000\ar5103
tis2bg2 -d -sw override\ar5104 ..\cd5000\ar5104
tis2bg2 -d -sw override\ar5201 ..\cd5000\ar5201
tis2bg2 -d -sw override\ar5202 ..\cd5000\ar5202
tis2bg2 -d -sw override\ar5203 ..\cd5000\ar5203
tis2bg2 -d -sw override\ar5204 ..\cd5000\ar5204
tis2bg2 -d -sw override\ar5301 ..\cd5000\ar5301
tis2bg2 -d -sw override\ar5302 ..\cd5000\ar5302
tis2bg2 -d -sw override\ar5303 ..\cd5000\ar5303
tis2bg2 -d -sw override\ar5304 ..\cd5000\ar5304
tis2bg2 -d -sw override\ar5401 ..\cd5000\ar5401
tis2bg2 -d -sw override\ar5402 ..\cd5000\ar5402
tis2bg2 -d -sw override\ar5403 ..\cd5000\ar5403
tis2bg2 -d -sw override\ar5404 ..\cd5000\ar5404
tis2bg2 -d -sw override\ar5502 ..\cd5000\ar5502

tis2bg2 -d -sw override\ar6000 ..\cd6000\ar6000
tis2bg2 -d -sw override\ar6001 ..\cd6000\ar6001
tis2bg2 -d -sw override\ar6002 ..\cd6000\ar6002
tis2bg2 -d -sw override\ar6003 ..\cd6000\ar6003
tis2bg2 -d -sw override\ar6004 ..\cd6000\ar6004
tis2bg2 -d -sw override\ar6005 ..\cd6000\ar6005
tis2bg2 -d -sw override\ar6006 ..\cd6000\ar6006
tis2bg2 -d -sw override\ar6007 ..\cd6000\ar6007
tis2bg2 -d -sw override\ar6008 ..\cd6000\ar6008
tis2bg2 -d -sw override\ar6009 ..\cd6000\ar6009
tis2bg2 -d -sw override\ar6010 ..\cd6000\ar6010
tis2bg2 -d -sw override\ar6011 ..\cd6000\ar6011
tis2bg2 -d -sw override\ar6013 ..\cd6000\ar6013
tis2bg2 -d -sw override\ar6014 ..\cd6000\ar6014

tis2bg2 -d -sw override\ar7000 ..\cd7000\ar7000
tis2bg2 -d -sw override\ar7001 ..\cd7000\ar7001
tis2bg2 -d -sw override\ar7002 ..\cd7000\ar7002
tis2bg2 -d -sw override\ar7003 ..\cd7000\ar7003
tis2bg2 -d -sw override\ar7004 ..\cd7000\ar7004
tis2bg2 -d -sw override\ar7005 ..\cd7000\ar7005

tis2bg2 -d -sw override\ar8001 ..\cd8000\ar8001
tis2bg2 -d -sw override\ar8002 ..\cd8000\ar8002
tis2bg2 -d -sw override\ar8003 ..\cd8000\ar8003
tis2bg2 -d -sw override\ar8004 ..\cd8000\ar8004
tis2bg2 -d -sw override\ar8005 ..\cd8000\ar8005
tis2bg2 -d -sw override\ar8006 ..\cd8000\ar8006
tis2bg2 -d -sw override\ar8007 ..\cd8000\ar8007
tis2bg2 -d -sw override\ar8008 ..\cd8000\ar8008
tis2bg2 -d -sw override\ar8009 ..\cd8000\ar8009
tis2bg2 -d -sw override\ar8010 ..\cd8000\ar8010
tis2bg2 -d -sw override\ar8011 ..\cd8000\ar8011
tis2bg2 -d -sw override\ar8012 ..\cd8000\ar8012
tis2bg2 -d -sw override\ar8013 ..\cd8000\ar8013
tis2bg2 -d -sw override\ar8014 ..\cd8000\ar8014
tis2bg2 -d -sw override\ar8015 ..\cd8000\ar8015
tis2bg2 -d -sw override\ar8016 ..\cd8000\ar8016

cd ..



IF NOT EXIST "iwd_in_bg2\override\ar9100.tis" goto biffend

mkdir cd9100

cd iwd_in_bg2

tis2bg2 -d -sw override\ar9100 ..\cd9100\ar9100
tis2bg2 -d -sw override\ar9101 ..\cd9100\ar9101
tis2bg2 -d -sw override\ar9102 ..\cd9100\ar9102
tis2bg2 -d -sw override\ar9103 ..\cd9100\ar9103
tis2bg2 -d -sw override\ar9104 ..\cd9100\ar9104
tis2bg2 -d -sw override\ar9105 ..\cd9100\ar9105
tis2bg2 -d -sw override\ar9106 ..\cd9100\ar9106
tis2bg2 -d -sw override\ar9107 ..\cd9100\ar9107
tis2bg2 -d -sw override\ar9108 ..\cd9100\ar9108
tis2bg2 -d -sw override\ar9109 ..\cd9100\ar9109
tis2bg2 -d -sw override\ar9110 ..\cd9100\ar9110
tis2bg2 -d -sw override\ar9200 ..\cd9100\ar9200
tis2bg2 -d -sw override\ar9201 ..\cd9100\ar9201
tis2bg2 -d -sw override\ar9300 ..\cd9100\ar9300
tis2bg2 -d -sw override\ar9301 ..\cd9100\ar9301
tis2bg2 -d -sw override\ar9400 ..\cd9100\ar9400
tis2bg2 -d -sw override\ar9500 ..\cd9100\ar9500
tis2bg2 -d -sw override\ar9501 ..\cd9100\ar9501
tis2bg2 -d -sw override\ar9502 ..\cd9100\ar9502
tis2bg2 -d -sw override\ar9600 ..\cd9100\ar9600
tis2bg2 -d -sw override\ar9601 ..\cd9100\ar9601
tis2bg2 -d -sw override\ar9602 ..\cd9100\ar9602
tis2bg2 -d -sw override\ar9603 ..\cd9100\ar9603
tis2bg2 -d -sw override\ar9604 ..\cd9100\ar9604

cd ..



IF NOT EXIST "iwd_in_bg2\override\ar9700.tis" goto biffend

mkdir cd9700

cd iwd_in_bg2

tis2bg2 -d -sw override\ar9700 ..\cd9700\ar9700
tis2bg2 -d -sw override\ar9701 ..\cd9700\ar9701
tis2bg2 -d -sw override\ar9702 ..\cd9700\ar9702
tis2bg2 -d -sw override\ar9703 ..\cd9700\ar9703
tis2bg2 -d -sw override\ar9704 ..\cd9700\ar9704
tis2bg2 -d -sw override\ar9705 ..\cd9700\ar9705
tis2bg2 -d -sw override\ar9706 ..\cd9700\ar9706
tis2bg2 -d -sw override\ar9707 ..\cd9700\ar9707
tis2bg2 -d -sw override\ar9708 ..\cd9700\ar9708
tis2bg2 -d -sw override\ar9709 ..\cd9700\ar9709
tis2bg2 -d -sw override\ar9710 ..\cd9700\ar9710
tis2bg2 -d -sw override\ar9711 ..\cd9700\ar9711
tis2bg2 -d -sw override\ar9712 ..\cd9700\ar9712
tis2bg2 -d -sw override\ar9713 ..\cd9700\ar9713
tis2bg2 -d -sw override\ar9714 ..\cd9700\ar9714
tis2bg2 -d -sw override\ar9715 ..\cd9700\ar9715
tis2bg2 -d -sw override\ar9716 ..\cd9700\ar9716
tis2bg2 -d -sw override\ar9717 ..\cd9700\ar9717
tis2bg2 -d -sw override\ar9718 ..\cd9700\ar9718
tis2bg2 -d -sw override\ar9800 ..\cd9700\ar9800
tis2bg2 -d -sw override\ar9801 ..\cd9700\ar9801

cd ..


::rd cd9700 /s /q



iwd_in_bg2\weidu --make-biff cd1000
iwd_in_bg2\weidu --make-biff cd2000
iwd_in_bg2\weidu --make-biff cd3000
iwd_in_bg2\weidu --make-biff cd4000
iwd_in_bg2\weidu --make-biff cd5000
iwd_in_bg2\weidu --make-biff cd6000
iwd_in_bg2\weidu --make-biff cd7000
iwd_in_bg2\weidu --make-biff cd8000
iwd_in_bg2\weidu --make-biff cd9100
iwd_in_bg2\weidu --make-biff cd9700

rd cd1000 /s /q
rd cd2000 /s /q
rd cd3000 /s /q
rd cd4000 /s /q
rd cd5000 /s /q
rd cd6000 /s /q
rd cd7000 /s /q
rd cd8000 /s /q
rd cd9100 /s /q
rd cd9700 /s /q



:biffend

:: create another tra file, for insertion purposes

iwd_in_bg2\weidu --game "%IWDPATH%" --traify-tlk --traify# 74100 --out iwd_in_bg2\iwdtext.txt

:: strip the >74100 strings from the BG2 dialog.tlk

iwd_in_bg2\weidu --traify-tlk --max 74099 --out iwd_in_bg2\bg2text.txt

:: make a combined dialog file

iwd_in_bg2\weidu --make-tlk iwd_in_bg2\bg2text.txt --make-tlk iwd_in_bg2\iwdtext.txt --tlkout dialog.tlk


:: clear out override and BIFF files

iwd_in_bg2\weidu --tlkout dialog.tlk --ftlkout dialogf.tlk --log iwd_in_bg2\workspace\log.debug iwd_in_bg2\setup-iwd_in_bg2.tp2 --args 1 --force-install-list 14 15

:: copy over directories of modified files to override

xcopy iwd_in_bg2\easy\cre_ini       override      /e
xcopy iwd_in_bg2\easy\gen_cre       override      /e
xcopy iwd_in_bg2\easy\itm_spl       override      /e
xcopy iwd_in_bg2\easy\bcs_dlg       override      /e
xcopy iwd_in_bg2\easy\misc          override      /e

:: do WEIDU postproduction

iwd_in_bg2\weidu --tlkout dialog.tlk --ftlkout dialogf.tlk --log iwd_in_bg2\workspace\log.debug iwd_in_bg2\setup-iwd_in_bg2.tp2 --args 1 --force-install-list 18 60 100 110 210 600 730 760 840 850 855 1000 4500 5000 11000 

:END
