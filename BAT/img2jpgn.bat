set dircmd=
dir /B *.IMG | rpl -M .IMG -R | rpl -M ^?+ -R call\sImg2jpg1\s& > teetamaz.bat
call teetamaz.bat
del teetamaz.bat



