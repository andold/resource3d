include	<../common/constants.scad>
use <../common/library_function.scad>
use <../common/library_text.scad>
use <../common/library_cube.scad>
use <../common/library_trimmer.scad>

MEASURE = [
	0,		//	상단 지지대, x축
	20,		//	상단 지지대, y축
	20,		//	상단 지지대, z축

	2.5,	//	연결판 두께

	//	part 1, 4 ~
	42,		//	모터 접면, 가로
	42,		//	모터 접면, 세로
	4.5,	//	모터 접면 두께
	//	구멍, 7 ~
	22,		//	중앙 모터 구멍 지름
	31,		//	구멍간 거리
	3.5,	//	나사 구멍 지름
	3.8,	//	집에 있는 검은색 나사 통과용 지름
	3.4,	//	집에 있는 검은색 나사 박히는 지름
	18,		//	집에 있는 검은색 나사 박히는 깊이
	
	0		//	reserved
];

DEFINE = [
	8,	//	두께
	0		//	reserved
];

/*
	지지대에 고정
*/
module mk8_part_2() {
	t = DEFINE[0];
	x = MEASURE[4];
	y = MEASURE[1] + t * 2;
	z = MEASURE[2] + t;

	base = [x, y, z];

	difference() {
		union() {
			cube([x, y, t]);
			translate([0, 0, 0])		cube([x, t, z]);
			translate([0, y - t, 0])		cube([x, t, z]);

			note_type_2("mk8_part_2", base);
		}

		let(
			r = MEASURE[11] / 2,
			deep = MEASURE[12],
			cx = DEFINE[0] / 2,

			reserved = 0
		) {
			translate([cx, cx, z - deep + EPSILON])			cylinder(deep + EPSILON2, r, r, $fn = fnRound(r));
			translate([x - cx, cx, z - deep + EPSILON])		cylinder(deep + EPSILON2, r, r, $fn = fnRound(r));
			translate([x - cx, y - cx, z - deep + EPSILON])	cylinder(deep + EPSILON2, r, r, $fn = fnRound(r));
			translate([cx, y - cx, z - deep + EPSILON])		cylinder(deep + EPSILON2, r, r, $fn = fnRound(r));
		}
	}
}

/*
	모터 접면
*/
module mk8_part_1() {
	x = MEASURE[4];
	y = MEASURE[5] + MEASURE[1] + DEFINE[0] * 2;
	z = MEASURE[3];
	base = [x, y, z];
	r1 = MEASURE[7] / 2;
	r2 = MEASURE[9] / 2;
	dr = MEASURE[8];
	d1 = x / 2;
	d2 = (x - dr) / 2;
	difference() {
		union() {
			cube(base);
			note_type_2("mk8_part_1", base);
		}
		
		translate([d1, d1, -EPSILON])			cylinder(z + EPSILON2, r1, r1, $fn = fnRound(r1));
		translate([d2, d2, -EPSILON])			cylinder(z + EPSILON2, r2, r2, $fn = fnRound(r2));
		translate([d2 + dr, d2, -EPSILON])		cylinder(z + EPSILON2, r2, r2, $fn = fnRound(r2));
		translate([d2 + dr, d2 + dr, -EPSILON])	cylinder(z + EPSILON2, r2, r2, $fn = fnRound(r2));
		translate([d2, d2 + dr, -EPSILON])		cylinder(z + EPSILON2, r2, r2, $fn = fnRound(r2));
		
		let(
			r = MEASURE[10] / 2,
			cx = DEFINE[0] / 2,

			reserved = 0
		) {
			translate([cx, base.x + cx, -EPSILON])	cylinder(z + EPSILON2, r, r, $fn = fnRound(r));
			translate([base.x - cx, base.x + cx, -EPSILON])	cylinder(z + EPSILON2, r, r, $fn = fnRound(r));
			translate([base.x - cx, base.y - cx, -EPSILON])	cylinder(z + EPSILON2, r, r, $fn = fnRound(r));
			translate([cx, base.y - cx, -EPSILON])	cylinder(z + EPSILON2, r, r, $fn = fnRound(r));
		}
	}
}

module mk8_assemble() {
	mk8_part_1();
	translate([MEASURE[5] + NOZZLE * 2, 0, 0])
		mk8_part_2();

	//	확인
	%union() {
		translate([0, MEASURE[5], -(MEASURE[2] + DEFINE[0])])
			mk8_part_2();
	}
}

mk8_assemble();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\extruder#40.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\extruder#39.scad
*/
