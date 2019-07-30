c:
cd c:\shit
@lxb screensetup "Ž„kk”set kuntoon"
lxb dirfileselect tied *.*
head -Z -24 %tied%
lxb fileselect method a:\sed\*.*
sed -f a:\sed\%method% %tied%>tmp.tmp
head -Z -24 tmp.tmp
lxb yesno "OK?"
if not errorlevel 1 goto ohi
copy tmp.tmp %tied%
del tmp.tmp
:ohi
lxb screenrestore
