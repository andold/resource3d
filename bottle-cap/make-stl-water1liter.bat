@SET PROFILE=n100
@SET PROJECT=water1liter
@SET EXE_FILE="C:\Program Files\OpenSCAD\openscad.exe"
@SET CURRENT_PATH=%~dp0
@SET CURRENT_FILENAME=%~nx0
@SET LC_ALL=ko_KR.UTF-8

time /t
%EXE_FILE% -o %PROJECT%.stl --export-format asciistl %PROJECT%.scad
time /t
