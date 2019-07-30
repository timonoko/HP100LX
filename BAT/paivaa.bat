@echo off
lxb getweekday paivaa
lxb getdate date
lxb strmid m 1 2 %date%
lxb strmid d 4 2 %date%
lxb strmid y 7 2 %date%
echo it. is. %paivaa% .... %d%.. %m%.. 19 hundred and %y% > paivaa.txt
lxb sound t240cegecegecgec
call say paivaa.txt
call say -c
set paivaa=
set date=
set m=
set d=
set y=
del paivaa.txt


