/*
	베드 고정 구조물 #31
*/
include	<../common/constants.scad>
use <../common/library.scad>

PARAM = [
	32,		//	가로 세로
	2,		//	아래쪽 두께
	6,		//	베드 + 렉산 두께
	0.8,	//	위쪽 두께
	4,		//	위쪽 덮는 너비
	0		//	reserved
];
module fasten(type) {
	if (type == 0) {
		rotate([0, -90, 0])
		difference() {
			union() {
				cube([PARAM[0], PARAM[0], PARAM[1]]);	//	아래판
				translate([0, 0, PARAM[1]])	cube([PARAM[1], PARAM[0], PARAM[2]]);	//	왼쪽판
				translate([0, 0, PARAM[1]])	cube([PARAM[0], PARAM[1], PARAM[2]]);	//	앞쪽판
				translate([0, 0, PARAM[1] + PARAM[2]])	cube([PARAM[1] + PARAM[4], PARAM[0], PARAM[3]]);	//	위판 왼쪽
				translate([0, 0, PARAM[1] + PARAM[2]])	cube([PARAM[0], PARAM[1] + PARAM[4], PARAM[3]]);	//	위판 앞쪽
			}

			translate([PARAM[0], 0, -EPSILON])
				rotate([0, 0, 45])
				cube([PARAM[0] * 2 + EPSILON2, PARAM[0] * 2 + EPSILON2, PARAM[0] * 2]);
		}
	} else {
		rotate([0, -90, 0])
		{
			cube([PARAM[0] / 4, PARAM[1] + PARAM[4] * 2, PARAM[1]]);	//	아래판
			translate([0, 0, PARAM[1]])	cube([PARAM[0] / 4, PARAM[1], PARAM[2]]);	//	앞쪽판
			translate([0, 0, PARAM[1] + PARAM[2]])	cube([PARAM[0] / 4, PARAM[1] + PARAM[4], PARAM[3]]);	//	위판 앞쪽
		}
	}
}

target = 0;
fasten(target);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\fasten-corner.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\fasten.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\fasten-plane.stl -D target=1 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\fasten.scad
*/
