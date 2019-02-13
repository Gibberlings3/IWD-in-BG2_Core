@echo off
IF NOT EXIST "override\narr_pl.wav" goto install
goto end

:install

"iwd_in_bg2/oggdec.exe" "iwd_in_bg2/files/narr/narr_pl.ogg"
"iwd_in_bg2/oggdec.exe" "iwd_in_bg2/files/narr/narr_ch1.ogg"
"iwd_in_bg2/oggdec.exe" "iwd_in_bg2/files/narr/narr_ch2.ogg"
"iwd_in_bg2/oggdec.exe" "iwd_in_bg2/files/narr/narr_ch3.ogg"
"iwd_in_bg2/oggdec.exe" "iwd_in_bg2/files/narr/narr_ch4.ogg"
"iwd_in_bg2/oggdec.exe" "iwd_in_bg2/files/narr/narr_ch5.ogg"
"iwd_in_bg2/oggdec.exe" "iwd_in_bg2/files/narr/narr_ch6.ogg"


move "iwd_in_bg2\files\narr\*.wav" "iwd_in_bg2\BIFF\narr_files" > nul

:end
::::