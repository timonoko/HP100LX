set comspec=d:\dos\command.com
prompt $p$g
path c:\;d:\;d:\bin;d:\dos;c:\bat;c:\sys;a:\bat;a:\sys;a:\epsilon;a:\stacker
set TMP=c:\


c:
cd shit

rem Doskey ja Snipper ei sovi yhteen, kirjoita SNIP ja boottaa..
 if exist c:\snipper snipper
 if exist c:\snipper set SNIPPER=YES
 if not exist c:\snipper doskey /insert
 if not exist c:\snipper call macros
 del c:\snipper

ansi fast
assign e:=a:
cursor 0
rem fixkhp
click
dispctl +K +C
numlock

set fignore=.bak
filec -l
set fignore=

set dircmd=/oen/p

d:\bin\cic100 /gen 1

helv100
ddmmyy24
dosclip
battlog
dispctl +K +C

call a:\rbin\new-vars.bat

waiter -s5
if errorlevel 1 goto ohio
tran -d2 9 -c
100
:ohio





