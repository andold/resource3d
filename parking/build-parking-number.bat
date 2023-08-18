ECHO build parking

SET  OPENSCAD=C:\apps\openscad-2021.01\openscad.exe
SET  LC_ALL=ko_KR.UTF-8

SET  PARKING_OPTIONS=-D thick=2 -D radius=32

DEL /Q /F %CD%\stl\*.stl
%OPENSCAD% --export-format asciistl -o %CD%\stl\spider-web-holder.stl	%PARKING_OPTIONS% -D target=1 -D prototype=false %CD%\6479.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\spider-web.stl			%PARKING_OPTIONS% -D target=2 -D prototype=false %CD%\6479.scad
