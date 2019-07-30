@echo off
echo -
if "%2"=="" goto bad
if  %2==%1 goto bad
if "%menu%"=="" goto resta
if not %1==%menu% goto bad
:resta
echo      +-----------------------------------+
echo       ...Swapping
if exist C:\_DAT\APPMGR.DAT  REN C:\_DAT\APPMGR.DAT APPMGR.MN%1
if exist C:\_DAT\APPMGR.MN%2 REN C:\_DAT\APPMGR.MN%2 APPMGR.DAT
echo                   from Menu-%1
if exist C:\_DAT\APNAME.LST  REN C:\_DAT\APNAME.LST APNAME.MN%1
if exist C:\_DAT\APNAME.MN%2 REN C:\_DAT\APNAME.MN%2 APNAME.LST
echo                                to Menu-%2
if exist a:\APNAME.LST       REN a:\APNAME.LST APNAME.MN%1
if exist a:\APNAME.MN%2      REN a:\APNAME.MN%2 APNAME.LST
echo      +-----------------------------------+
set menu=%2
goto end
:bad
echo What is this?!? 
echo You were trying to switch from menu-%1 to menu-%2
echo while (already) in menu-%menu%...
echo .
time
:end
100