include	<../common/constants.scad>
use <../common/library_function.scad>
use <../common/library_text.scad>
use <../common/library_cube.scad>

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
	x = MEASURE[4];
	y = MEASURE[1] + DEFINE[0] * 2;
	z = MEASURE[2] + DEFINE[0] * 2;
	base = [x, y, z];
	
	cx = x + EPSILON2;
	cy = MEASURE[1];
	cz = MEASURE[2];
	cbase = [cx, cy, cz];

	difference() {
		union() {
			cube_type_6(base, base.x / 2, 1);
			note_type_2("mk8_part_1", base);
		}

		translate([-EPSILON, (y - cy) / 2, (z - cz) / 2])
			cube(cbase);
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
			cube_type_6(base, base.x / 2, 1);
			note_type_2("mk8_part_1", base);
		}
		
		translate([d1, d1, -EPSILON])			cylinder(z + EPSILON2, r1, r1, $fn = fnRound(r1));
		translate([d2, d2, -EPSILON])		cylinder(z + EPSILON2, r2, r2, $fn = fnRound(r2));
		translate([d2 + dr, d2, -EPSILON])			cylinder(z + EPSILON2, r2, r2, $fn = fnRound(r2));
		translate([d2 + dr, d2 + dr, -EPSILON])			cylinder(z + EPSILON2, r2, r2, $fn = fnRound(r2));
		translate([d2, d2 + dr, -EPSILON])			cylinder(z + EPSILON2, r2, r2, $fn = fnRound(r2));
		translate([0, 0, -EPSILON]) {
		}
	}
}

module mk8_assemble() {
	mk8_part_1();
	translate([0, MEASURE[5], 0])
		mk8_part_2();
}

mk8_assemble();

/*
# in HOME(project root, ie. .../resouce3d)
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\stl\extruder#39.stl --export-format asciistl C:\src\eclipse-workspace\resource3d\fasten\extruder#39.scad
*/