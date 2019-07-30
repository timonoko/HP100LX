@echo off
if not exist %1.img goto ohi
if exist %1.jpg goto ohi
if exist %1.tga del %1.tga
img2tga -v %1.img %1.tga
if exist %1.tga cjpeg %1.tga
del %1.tga
pkzip -m %1.zip %1.img
:ohi

