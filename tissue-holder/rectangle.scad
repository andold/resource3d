// rectangle.scad
include <BOSL/constants.scad>
use <BOSL/threading.scad>

include	<../common/constants.scad>
use <../common/library_function.scad>
use <../common/library_text.scad>
use <../common/library_cube.scad>
use <../common/library_trimmer.scad>

MEASURE = [
	//	사각 티슈
	240,	//	1. 가로
	120,	//	2. 세로
	100,	//	3. 높이
	120,	//	4. 중앙 타원 구멍
	158,	//	5. 중앙 타원 가로
	42,		//	6. 중앙 타원 세로
	//	식탁 고정 대상
	10,		//	1. 걸이 높이 가까운 쪽
	14,		//	2. 걸이 높이 먼 쪽
	19,		//	3. 걸이 너비
	26,		//	4. 걸이 상단과의 공간 높이

	0		//	reserved
];

DEFINE = [
	2,	//	두께

	0	//	reserved
];

/*
*/
module holder() {
}
module basis() {
	translate([0, -MEASURE[0] / 2, 0])
	rotate([0, -90, 0])
	cube_type_2([MEASURE[6], MEASURE[0] * 2, MEASURE[8]], MEASURE[7]);
}
module tissue_box() {
	cube([MEASURE[1], MEASURE[0], MEASURE[2]]);
}
module holder_assemble() {
	basis();
	translate([128, 0, 0])
	tissue_box();
	holder();
}

holder_assemble();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\water1liter#41.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\bottle-cap\water1liter.scad
*/
