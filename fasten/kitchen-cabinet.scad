/*
	싱크대 하부장 칸막이
	Kitchen cabinet
*/
include	<../common/constants.scad>
use <../common/library.scad>

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
	124,			//	높이
	200,			//	가로 최대
	0.28 * 10,		//	두께
	MEASURE[4] * 2,	//	꼽는 깊이
	0.4 * 3,		//	꼽는 것의 두께
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
		translate([sx + cx * DEFINE[6], 0, 0])	rotate([-90, 0, 0])	#cylinder(y, MEASURE[4] / 2, MEASURE[4] / 2);
	}

}
module assemble() {
	y_start = 64;
	dx = 24 + (MEASURE[2] + MEASURE[3]) * 6 - (MEASURE[4] / 2 + DEFINE[4]) - 200 / 2;

	translate([0, 0, MEASURE[2] / 2])
		%container();
	translate([24 + DEFINE[6] * 2 - (MEASURE[4] / 2 + DEFINE[4]), y_start, 0])
		kitchen(2);
	translate([24 + DEFINE[6] * 6 - (MEASURE[4] / 2 + DEFINE[4]), y_start, 0])
		kitchen(2);
	translate([24 + DEFINE[6] * 10 - (MEASURE[4] / 2 + DEFINE[4]), y_start, 0])
		kitchen(2);

	translate([dx, y_start + DEFINE[5] / 2, 3.41])
		cube([DEFINE[1], DEFINE[2], DEFINE[2]]);
}
module kitchen1() {
	cube([DEFINE[1], DEFINE[0], DEFINE[2]]);
}

// r: 반지름, delta: 한쪽 여유
module kitchen2(r, delta, y, z) {
	r2 = r * 2;			//	지름
	delta2 = delta * 2;	//	양쪽 여유 합
	rplus = r + delta;
	rminus = r - delta;

	// 진입로
	cube_type_1([rplus * 2, y, z], rminus * 2);
	// 정착
	translate([rplus, 0, z + sqrt(rplus * rplus - rminus * rminus)])
		rotate([-90, 0, 0])
		cylinder(y, rplus, rplus, $fn = fnRound(rplus));
	// 오버행 제거
	let (
		x = rplus * sin(OVERHANG_THRESHOLD),
		z_start = z + sqrt(rplus * rplus - rminus * rminus) + sqrt(rplus * rplus - x * x),
	
		reserved = 0
	) {
		translate([rplus - x, 0, z_start])
			cube_type_1([x * 2, y, x * sin(OVERHANG_THRESHOLD)], 0);

		note_type_1([rplus * 2, y, z_start + x * sin(OVERHANG_THRESHOLD)]);
	}
}
module kitchen3() {
	x = MEASURE[4] + DEFINE[4] * 2;
	y = DEFINE[5];
	z = 3.41 + DEFINE[4];
	
	difference() {
		cube([x, y, z]);
		translate([DEFINE[4], -EPSILON, -EPSILON])
			kitchen2(MEASURE[4] / 2, MINIMUM, DEFINE[5] + EPSILON2, DEFINE[4]);
	}
}
module kitchen(type) {
	if (type == 0) {
		kitchen1();
	} else if (type == 1) {
		kitchen2(MEASURE[4] / 2, MINIMUM, DEFINE[5], 2);
	} else if (type == 2) {
		kitchen3();
	} else {
		assemble();
	}
}

target = 3;
kitchen(target);
/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\kitchen-cabinet.stl -D target=3 --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\kitchen-cabinet.scad
*/
