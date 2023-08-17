REM	root
SET  OPENSCAD=C:\apps\openscad-2021.01\openscad.exe
SET  LC_ALL=ko_KR.UTF-8

CALL %CD%\parking\build.bat

%OPENSCAD% --export-format asciistl -o %CD%\knife\stl\landscape.stl -D thick=8 -D margin=12 -D delta=8 -D prototype=false %CD%\knife\top\landscape.scad
%OPENSCAD% --export-format asciistl -o %CD%\knife\stl\landscape-half.stl -D thick=8 -D margin=12 -D delta=8 -D prototype=true %CD%\knife\top\landscape.scad

CALL %CD%\knife\body\build.bat
