REM	body
SET  OPENSCAD=C:\apps\openscad-2021.01\openscad.exe
SET  LC_ALL=ko_KR.UTF-8

ECHO	start export stl body

DEL /Q /F %CD%\stl\*.stl

SET  KNIFE_TOP_OPTIONS=-D thick=8 -D margin=12 -D delta=8
%OPENSCAD% --export-format asciistl -o %CD%\stl\landscape.stl		-D prototype=false %KNIFE_TOP_OPTIONS% %CD%\top\landscape.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\landscape-half.stl	-D prototype=true  %KNIFE_TOP_OPTIONS% %CD%\top\landscape.scad

SET  KNIFE_BODY_OPTIONS=-D thick=8 -D margin=8 -D delta=8 -D marginy=12 -D paddingx=24 -D paddingy=12
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-top-front-half.stl		-D target=1 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-top-side-half.stl		-D target=2 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-top-joint-half.stl		-D target=3 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-bottom-front-half.stl	-D target=4 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-bottom-side-half.stl	-D target=5 -D prototype=true %KNIFE_BODY_OPTIONS% %CD%\body\body.scad

%OPENSCAD% --export-format asciistl -o %CD%\stl\body-top-front.stl		-D target=1 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-top-side.stl		-D target=2 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-top-joint.stl		-D target=3 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-bottom-front.stl	-D target=4 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body\body.scad
%OPENSCAD% --export-format asciistl -o %CD%\stl\body-bottom-side.stl	-D target=5 -D prototype=false %KNIFE_BODY_OPTIONS% %CD%\body\body.scad

ECHO	done export stl body
