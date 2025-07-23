# build index
- stl 경로에 있는 stl 파일들의 빌드 내역

#### 빌드 명령어 예시
```
/usr/bin/openscad --export-format asciistl -D sn=1 -o "/media/owl/src/eclipse-workspace/resource3d/openscad/stl/$(date +'%Y%m%d%H%M%S').stl" /media/owl/src/eclipse-workspace/resource3d/openscad/src/tmp/texture.scad
/usr/bin/openscad --export-format asciistl -D sn=1 -o "/media/owl/src/eclipse-workspace/resource3d/openscad/stl/$(date +'%Y%m%d%H%M%S').stl" /media/owl/src/eclipse-workspace/resource3d/openscad/epaper/part-13.scad

C:\apps\OpenSCAD-2025.07.11-x86-64\openscad.com --export-format asciistl -D sn=2 -o "\\opi5\public\src\eclipse-workspace\resource3d\openscad\stl\$((Get-Date).ToString('yyyyMMddHHmmss')).stl" \\opi5\public\src\eclipse-workspace\resource3d\openscad\src\tmp\texture.scad
C:\apps\openscad-2021.01\openscad.com --export-format asciistl -D sn=2 -o "\\opi5\public\src\eclipse-workspace\resource3d\openscad\stl\$((Get-Date).ToString('yyyyMMddHHmmss')).stl" \\opi5\public\src\eclipse-workspace\resource3d\openscad\src\tmp\texture.scad
C:\apps\openscad-2021.01\openscad.com --export-format asciistl -D sn=2 -o "W:\src\eclipse-workspace\resource3d\openscad\stl\%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.stl" W:\src\eclipse-workspace\resource3d\openscad\src\tmp\texture.scad
```

#### 내용
| 일련 번호  | 내용  |  일시           | 특이 사항 |
|------:|:------|:----------------|:----------|
|     0 | 예시. 시작이 반이다 | 2025-07-23 (수) | -         |
