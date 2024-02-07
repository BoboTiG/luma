@echo off

rem Vars
set new_folder=D:\%username%
set do_move=robocopy /s /copy:dat /r:0
set reg1=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
set reg2=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders


rem Create new folders
mkdir "%new_folder%"
mkdir "%new_folder%\Desktop"
mkdir "%new_folder%\Music"
mkdir "%new_folder%\Documents"
mkdir "%new_folder%\Pictures"
mkdir "%new_folder%\Videos"
mkdir "%new_folder%\Downloads"


rem Copy data from old folders to new ones
if exist "%userprofile%\Desktop" %do_move% "%userprofile%\Desktop" "%new_folder%\Desktop"
if exist "%userprofile%\Music" %do_move% "%userprofile%\Music" "%new_folder%\Music"
if exist "%userprofile%\Pictures" %do_move% "%userprofile%\Pictures" "%new_folder%\Pictures"
if exist "%userprofile%\Videos" %do_move% "%userprofile%\Videos" "%new_folder%\Videos"
if exist "%userprofile%\Documents" %do_move% "%userprofile%\Documents" "%new_folder%\Documents"
if exist "%userprofile%\Downloads" %do_move% "%userprofile%\Downloads" "%new_folder%\Downloads"


rem Adapt paths in the registry
reg add "%reg1%" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t "REG_SZ" /d "%new_folder%\Downloads" /f
reg add "%reg1%" /v "Desktop" /t "REG_SZ" /d "%new_folder%\Desktop"  /f
reg add "%reg1%" /v "My Music" /t "REG_SZ" /d "%new_folder%\Music" /f
reg add "%reg1%" /v "My Pictures" /t "REG_SZ" /d "%new_folder%\Pictures"  /f
reg add "%reg1%" /v "My Video" /t "REG_SZ" /d "%new_folder%\Videos"  /f
reg add "%reg1%" /v "Personal" /t "REG_SZ" /d "%new_folder%\Documents"  /f

reg add "%reg2%" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t "REG_SZ" /d "%new_folder%\Downloads" /f
reg add "%reg2%" /v "Desktop" /t "REG_SZ" /d "%new_folder%\Desktop"  /f
reg add "%reg2%" /v "My Music" /t "REG_SZ" /d "%new_folder%\Music" /f
reg add "%reg2%" /v "My Pictures" /t "REG_SZ" /d "%new_folder%\Pictures"  /f
reg add "%reg2%" /v "My Video" /t "REG_SZ" /d "%new_folder%\Videos"  /f
reg add "%reg2%" /v "Personal" /t "REG_SZ" /d "%new_folder%\Documents"  /f


rem Delete old folders
del /s /f "%userprofile%\Desktop" 2>NUL
del /s /f "%userprofile%\Music" 2>NUL
del /s /f "%userprofile%\Pictures" 2>NUL
del /s /f "%userprofile%\Videos" 2>NUL

echo.
echo.
echo Restart the computer to finish.
echo.
pause
