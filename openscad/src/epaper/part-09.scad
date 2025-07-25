include	<../common/constants.scad>
use <common.scad>
use <part-07.scad>
use <part-08.scad>

//	deprecated
//	프로토타입, 테스트 출력용
ID = "⑨";
COLOR = [0.5, 0.4, 0.3, 0.9];

module epaper_part_09a3(v, w, v2, fs) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, w, v2, fs, ")"));

	translate([v[0] + v2[0] + v2[0], 0, 0])
	mirror([1, 0, 0])
	epaper_part_07(v);

	translate([v[0] + v2[0], -fs, 0])
	notate([v2[0], fs]);
}
module epaper_part_09a(v, w, female = false) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, w, ")"));
	v2 = is_undef(w) ? [8, true] : w;

	//	1st
	translate([v[0], 0, 0])
	mirror([1, 0, 0])
	epaper_part_07(v, female);

	//	2nd
	translate([v2[0] + v[0], 0, 0])
	epaper_part_07(v, female);

	fs = 0.2;
	translate([v[0], -fs, 0])
	notate([v2[0], fs]);

	//	3rd
	//epaper_part_09a3(v, w, v2, fs);
}
module epaper_part_09b(v1, v2, v3) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v1, v2, v3, ")"));

	assert(!is_undef(v1));
	assert(!is_undef(v2));
	assert(!is_undef(v3));

	base = [v1.x, v1.y, v2.y, v2.y / 4];
	hole = [2, v1.y / 3 * 2, v2.y];

	difference() {
		epaper_part_08(base);

		translate([8 - hole.x, 4, 0])
		cube(hole);
		translate([16, 4, 0])
		cube(hole);
	}
}
module epaper_part_09d(p4, s4, v1, s3) {
	echo("epaper_part_09d", p4, s4, v1, s3, HR);
	translate(p4)
	difference() {
		epaper_part_08([s4.x, s4.y, s4.z, 0.5]);

		translate([v1.x / 2, v1.y, -0.5])
		cube(s3 + [0, 0, 1]);
	}
}
module epaper_part_09(v) {
	echo(str(parent_module(0), ".", parent_module(1), "(", v, ")"));

	assert(!is_undef(v));

	v1 = v[0];
	v2 = v[1];
	v3 = v[2];

	assert(!is_undef(v1));
	assert(!is_undef(v2));
	assert(!is_undef(v3));

	translate([0, 0, 0])
	epaper_part_08(v1);

	translate([8 - v2.x, 8, v1.z])
	epaper_part_09a(v2, v3);

	//	고정 대상
	translate([v1.x + 2, 0, 0])
	difference()
	{
		//color([0.5, 0.5, 0.5], 0.9)
		epaper_part_08(v1);

		translate([8 - v2.x, 8, v1.z + EPSILON])
		mirror([0, 0, 1])
		epaper_part_09a(v2, v3, true);
	}
}

module main() {
	hr();

	v1 = [8 * 3, 8 * 2 + 4, 8, 2];
	v2 = [0.8, 4, 1.6, 0.4, 0.4];
	v3 = [8, true];
	v = [v1, v2, v3];
	epaper_part_09(v);

	hr();
	echo(DIGIT[0]);
}

main();

/*
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09-8x32x160x80.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09.scad

C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09-4x16x80x4.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09.scad
*/
