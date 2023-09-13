/*
	냉장고 칸막이
- 내경 기준
- 높이: 90 mm
- 깊이: 155 mm
- 앞판 두께: 11.5+ mm
*/
include	<../common/constants.scad>
use <../common/library.scad>

MEASURE = [
	155,	//	내경 기준 깊이
	90,		//	높이
	11.5,	//	앞판 두께
	0		//	reserved
];
DEFINE = [
	2,		//	두께
	160,	//	간격
	16,		//	가로 묶음 높이, 대들보 위치
	0		//	reserved
];

module container() {
	y = 300;
	z = 300;
	translate([-EPSILON, 0, 0])		cube([EPSILON,					y + MEASURE[2],	z]);
	translate([0, 0, -EPSILON])		cube([MEASURE[0] + MEASURE[2],	y,				EPSILON]);
	translate([0, 0, 0])			cube([MEASURE[0] + MEASURE[2],	MEASURE[2],		MEASURE[1]]);
	translate([0, y, 0])			cube([MEASURE[0] + MEASURE[2],	MEASURE[2],		MEASURE[1]]);
	translate([MEASURE[0], 0, 0])	cube([MEASURE[2],				y,				MEASURE[1]]);
}
module fridge(type) {
	*translate([32, MEASURE[0] + MEASURE[2], 0])	rotate([0, 0, -90])	container();

	//	칸막이
	cube([DEFINE[0], MEASURE[0], MEASURE[1]]);
	translate([DEFINE[1], 0, 0])		cube([DEFINE[0], MEASURE[0], MEASURE[1]]);
	//	칸막이 반으로 나누기
	translate([-DEFINE[1] / 4, MEASURE[0] / 2, 0])		cube([220, DEFINE[0], MEASURE[1]]);
}

target = 0;
fridge(target);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\fridge.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\fridge.scad
*/
