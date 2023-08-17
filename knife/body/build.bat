REM	body
SET  OPENSCAD=C:\apps\openscad-2021.01\openscad.exe
SET  LC_ALL=ko_KR.UTF-8

SET  KNIFE_BODY_OPTIONS=-D thick=8 -D margin=8 -D delta=8 -D marginy=12 -D paddingx=24 -D paddingy=24
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-top-front-half.stl -D target=1 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-top-side-half.stl -D target=2 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-top-joint-half.stl -D target=3 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-bottom-front-half.stl -D target=4 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-bottom-side-half.stl -D target=5 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body.scad

%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-top-front.stl -D target=1 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-top-side.stl -D target=2 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-top-joint.stl -D target=3 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-bottom-front.stl -D target=4 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\..\stl\body-bottom-side.stl -D target=5 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body.scad
