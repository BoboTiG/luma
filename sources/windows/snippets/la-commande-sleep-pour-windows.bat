@echo off

timeout /t 5 /nobreak > nul
%systemroot%\system32\timeout.exe /t 5 /nobreak > nul

ping 127.0.0.1 -n 6 > NUL
