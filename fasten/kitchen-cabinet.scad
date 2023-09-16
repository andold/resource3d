/*
	싱크대 하부장 칸막이
	Kitchen cabinet
*/
include	<../common/constants.scad>
use <../common/library.scad>
use <../common/library_function.scad>
use <../common/library_cube.scad>

MEASURE = [
	//	트레이: 외경 기준
	234,	//	외경 기준 가로
	80,		//	높이
	4.5,	//	지지철선 지름

	//	바닥: 3 ~
	11,		//	세로 철선 개수
	2.5,	//	세로 철선 지름
	16.2,	//	세로 철선간 거리, deprecated
	3.9,	//	가로 철선 지름
	
	//	측정값 오류 및 개선 #34, 7~
	9,
	151.88,

	0		//	reserved
];
DEFINE = [
	124,			//	높이, 기본, 긴 것, 아래층
	200,			//	가로 최대
	0.28 * 10,		//	두께
	MEASURE[4] * 2,	//	꼽는 깊이
	0.4 * 5,		//	꼽는 것의 두께
	32,				//	꼽는 것의 너비
	(MEASURE[8] - MEASURE[4]) / (MEASURE[7] - 1),	//	세로 철선간 거리

	0				//	reserved
];

module container() {
	x = MEASURE[0];
	y = 300;
	z = MEASURE[1];

	//	외경
	//	가로
	rotate([0, 90, 0])	cylinder(x, MEASURE[2] / 2, MEASURE[2] / 2);
	translate([0, 0, z])		rotate([0, 90, 0])	cylinder(x, MEASURE[2] / 2, MEASURE[2] / 2);

	//	높이
	translate([0, 0, 0])	cylinder(z, MEASURE[2] / 2, MEASURE[2] / 2);
	translate([x, 0, 0])	cylinder(z, MEASURE[2] / 2, MEASURE[2] / 2);

	//	세로
	translate([0, 0, 0])	rotate([-90, 0, 0])	cylinder(y, MEASURE[2] / 2, MEASURE[2] / 2);
	translate([0, 0, z])	rotate([-90, 0, 0])	cylinder(y, MEASURE[2] / 2, MEASURE[2] / 2);
	translate([x, 0, z])	rotate([-90, 0, 0])	cylinder(y, MEASURE[2] / 2, MEASURE[2] / 2);
	translate([x, 0, 0])	rotate([-90, 0, 0])	cylinder(y, MEASURE[2] / 2, MEASURE[2] / 2);
	
	//	바닥
	sx = MEASURE[2] / 2 + (MEASURE[0] - (DEFINE[6] * (MEASURE[3] - 1) + MEASURE[4])) / 2;
	for(cx = [0:MEASURE[3] - 1]) {
		translate([sx + cx * DEFINE[6], 0, 0])
			rotate([-90, 0, 0])
			cylinder(y, MEASURE[4] / 2, MEASURE[4] / 2, $fn = fnRound(MEASURE[4] / 2));
	}

}
module assemble() {
	y_start = 64;
//	sx = 24 + (MEASURE[2] + MEASURE[3]) * 6 - (MEASURE[4] / 2 + DEFINE[4]) - 200 / 2;
	sx = MEASURE[2] / 2 + (MEASURE[0] - (DEFINE[6] * (MEASURE[3] - 1) + MEASURE[4])) / 2;
	sz = trimmer_type_1_height(MEASURE[4] / 2, MINIMUM, DEFINE[5] + EPSILON2, DEFINE[4]);

	%translate([0, 0, MEASURE[2] / 2])
		container();

	translate([sx + DEFINE[6] * 1 - (MEASURE[4] / 2 + DEFINE[4]), y_start, 0])
		kitchen(2);
	translate([sx + DEFINE[6] * 5 - (MEASURE[4] / 2 + DEFINE[4]), y_start, 0])
		kitchen(2);
	translate([sx + DEFINE[6] * 9 - (MEASURE[4] / 2 + DEFINE[4]), y_start, 0])
		kitchen(2);

	#translate([sx, y_start + DEFINE[5] / 2, sz])
		cube([DEFINE[1], DEFINE[2], DEFINE[2] * 2]);
}

//	큰 칸막이
module kitchen1(z) {
	sx = MEASURE[2] / 2 + (MEASURE[0] - (DEFINE[6] * (MEASURE[3] - 1) + MEASURE[4])) / 2;
	sz = trimmer_type_1_height(MEASURE[4] / 2, MINIMUM, DEFINE[5] + EPSILON2, DEFINE[4]);

	%translate([0, -32, MEASURE[2] / 2])
		container();

	//	연결 조립
	translate([sx + DEFINE[6] * 1 - (MEASURE[4] / 2 + DEFINE[4]), 0, 0])
		kitchen3();
	translate([sx + DEFINE[6] * 5 - (MEASURE[4] / 2 + DEFINE[4]), 0, 0])
		kitchen3();
	translate([sx + DEFINE[6] * 9 - (MEASURE[4] / 2 + DEFINE[4]), 0, 0])
		kitchen3();

	// 칸막이
	translate([sx, DEFINE[5] / 2, sz])
	{
		cube([DEFINE[1], DEFINE[2], z]);
	}
}

// 바닥 가는 철선 연결 조립 부품품
module kitchen3() {
	x = MEASURE[4] + DEFINE[4] * 2;
	y = DEFINE[5];
	z = trimmer_type_1_height(MEASURE[4] / 2, MINIMUM, DEFINE[5] + EPSILON2, DEFINE[4]) + DEFINE[4];
	
	difference() {
		cube([x, y, z]);
		translate([DEFINE[4], -EPSILON, -EPSILON])
			trimmer_type_1(MEASURE[4] / 2, MINIMUM, DEFINE[5] + EPSILON2, DEFINE[4]);
	}
}
module kitchen(type) {
	if (type == 0) {
		kitchen1(DEFINE[0]);
	} else if (type == 1) {
		kitchen1(MEASURE[1]);
	} else if (type == 2) {
		kitchen3();
	} else {
		assemble();
	}
}

target = 1;
kitchen(target);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\kitchen-cabinet#34-tall.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\kitchen-cabinet.scad
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\kitchen-cabinet#34-small.stl -D target=1 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\kitchen-cabinet.scad
*/
