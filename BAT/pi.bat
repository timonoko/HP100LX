@echo off
if exist do del do
if exist do.bat del do.bat
if exist loppu del loppu
if exist xxxxtemp.zip del xxxxtemp.zip
if exist xxxxxpi2.bat del xxxxxpi2.bat

if "%1"=="" goto rec
if %1==loop goto rec
if "%2"=="" goto end

set baud=9600
if %1==2 set baud=19200
if %1==3 set baud=38400
if %1==4 set baud=115200

if "%2"=="loppu" echo loppu > loppu
if "%2"=="do" echo %3 %4 %5 %6 %7 %8 %9 > do

set comprs=es
if exist c:\_dat\memo.env set comprs=e0
pkzip -%comprs% xxxxtemp %2
if not exist xxxxtemp.zip goto end
echo transfer /r /B%baud% /com1 xxxxtemp.zip > xxxxxpi2.bat
transfer /s /com1 xxxxxpi2.bat
transfer /s /B%baud% /com1 xxxxtemp.zip
goto end

:rec
transfer /r /com1 xxxxxpi2.bat
if not exist xxxxxpi2.bat goto rec
call xxxxxpi2
del xxxxxpi2.bat
if not exist xxxxtemp.zip goto end
pkunzip -o xxxxtemp.zip
if not exist do goto nodo
	ren do do.bat
	call do
	del do.bat
:nodo
if not "%1"=="loop" goto end
if not exist loppu goto rec

:end
if exist do del do
if exist do.bat del do.bat
if exist loppu del loppu
if exist xxxxtemp.zip del xxxxtemp.zip
if exist xxxxxpi2.bat del xxxxxpi2.bat
echo --



