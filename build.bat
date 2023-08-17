SET  OPENSCAD=C:\apps\openscad-2021.01\openscad.exe
SET  SCAD_PATH=.\parking
SET  STL_PATH=.\parking\stl
SET  BUILD_PATH=.\parking\build
SET  KNIFE_PATH=.\knife
SET  LC_ALL=ko_KR.UTF-8
@ECHO ON

ECHO %OPENSCAD% %SCAD_PATH% %STL_PATH% %BUILD_PATH%

%OPENSCAD% --export-format asciistl -o %STL_PATH%\webcap.stl -D target=1 -D thick=1 -D prototype=false -D radius=32 %SCAD_PATH%\6479.scad
%OPENSCAD% --export-format asciistl -o %STL_PATH%\web.stl -D target=2 -D thick=1 -D prototype=false -D radius=32 %SCAD_PATH%\6479.scad

%OPENSCAD% --export-format asciistl -o %KNIFE_PATH%\stl\landscape.stl -D thick=8 -D margin=12 -D delta=8 -D prototype=false %KNIFE_PATH%\top\landscape.scad
%OPENSCAD% --export-format asciistl -o %KNIFE_PATH%\stl\landscape-half.stl -D thick=8 -D margin=12 -D delta=8 -D prototype=true %KNIFE_PATH%\top\landscape.scad
