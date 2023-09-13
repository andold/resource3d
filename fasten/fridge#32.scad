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
	8,		//	조립 겹치는 길이
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
module assemble() {
	// 냉장고
	%translate([0, MEASURE[0] + MEASURE[2], 0])	rotate([0, 0, -90])	container();

	// 칸막이 가로
	translate([50, MEASURE[2] + MEASURE[0] / 2 + DEFINE[0] / 2, 0])	rotate([90, 0, 0])	fridge(0);
	translate([50 + MAX.x / 2 + DEFINE[0] / 2, MEASURE[2], MEASURE[1]])	rotate([-90, 0, 90])	fridge(1);
	
	// 고정용 하단
	translate([50 + MAX.x / 2 - DEFINE[3] / 2, MEASURE[2] + MEASURE[0] / 2 - DEFINE[3] / 2, 0])
	fridge(2);
	// 고정용 상단
	translate([50 + MAX.x / 2 - DEFINE[3] / 2, MEASURE[2] + MEASURE[0] / 2 + DEFINE[3] / 2, MEASURE[1]])
	rotate([180, 0, 0])
	fridge(2);
}
module fridge(type) {
	if (type == 0) {
		//	긴쪽
		difference() {
			// 기본판
			cube([MAX.x, MEASURE[1], DEFINE[0]]);

			//	조립
			for (cx = [1:7]) {
				// 칸막이들간의 조립 구멍
				translate([MAX.x / 8 * cx - DEFINE[0] / 2, 0, -EPSILON])	cube([DEFINE[0], MEASURE[1] / 2, DEFINE[0] + EPSILON2]);
				// 고정용 하단
				translate([MAX.x / 8 * cx - DEFINE[3] / 2, MEASURE[1] - DEFINE[0], -EPSILON])
					cube([DEFINE[3], DEFINE[0] + EPSILON, DEFINE[0] + EPSILON2]);
				// 고정용 상단
				translate([MAX.x / 8 * cx - DEFINE[3] / 2, -EPSILON, -EPSILON])
					cube([DEFINE[3], DEFINE[0] + EPSILON, DEFINE[0] + EPSILON2]);
			}
		}
	} else if (type == 1) {
		//짧은쪽
		difference() {
			// 기본판
			cube([MEASURE[0], MEASURE[1], DEFINE[0]]);

			//	조립
			for (cx = [1:7]) {
				// 칸막이들간의 조립 구멍
				translate([MEASURE[0] / 8 * cx - DEFINE[0] / 2, 0, -EPSILON])
					cube([DEFINE[0], MEASURE[1] / 2, DEFINE[0] + EPSILON2]);
				// 고정용 상단
				translate([MEASURE[0] / 8 * cx - DEFINE[3] / 2, -EPSILON, -EPSILON])
					cube([DEFINE[3], DEFINE[0] + EPSILON, DEFINE[0] + EPSILON2]);
				// 고정용 하단
				translate([MEASURE[0] / 8 * cx - DEFINE[3] / 2, MEASURE[1] - DEFINE[0], -EPSILON])
					cube([DEFINE[3], DEFINE[0] + EPSILON, DEFINE[0] + EPSILON2]);
			}
		}
	} else if (type == 2) {
		difference() {
			// 기본판
			cube([DEFINE[3], DEFINE[3], DEFINE[3]]);
			// 가로홈
			translate([-EPSILON, DEFINE[3] / 2 - DEFINE[0] / 2, DEFINE[0]])
				cube([DEFINE[3] + EPSILON2, DEFINE[0], DEFINE[3]]);
			// 세로홈
			translate([DEFINE[3] / 2 - DEFINE[0] / 2, -EPSILON, DEFINE[0]])
				cube([DEFINE[0], DEFINE[3] + EPSILON2, DEFINE[3]]);
		}
	} else {
		assemble();
	}
}

target = 3;
fridge(target);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\fridge#32-long.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\fridge#32.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\fridge#32-short.stl -D target=1 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\fridge#32.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\fridge#32-connect.stl -D target=2 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\fridge#32.scad
*/
