include	<../common/constants.scad>
use <common.scad>
use <part-07.scad>
use <part-08.scad>

//	①②③④⑤⑥⑦⑧⑨ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓄ
ID = "⑨";
COLOR = [0.5, 0.4, 0.3, 0.9];

module epaper_part_09a(v, w) {
	v2 = is_undef(w) ? [8, true] : w;

	translate([v[0], 0, 0])
	mirror([1, 0, 0])
	epaper_part_07(v);

	translate([v2[0] + v[0], 0, 0])
	epaper_part_07(v);

	fs = 0.2;
	translate([v[0], -fs, 0])
	notate([v2[0], fs]);

	translate([v[0] + v2[0] + v2[0], 0, 0])
	mirror([1, 0, 0])
	epaper_part_07(v);

	translate([v[0] + v2[0], -fs, 0])
	notate([v2[0], fs]);
}
module epaper_part_09b(s, v) {
	echo("epaper_part_09b", s, v);
	s1 = is_undef(s) ? [16, 8, 4] : s;
	v1 = is_undef(v) ? [16, 8, 4, 32] : v;

	translate([v1.x, v1.y, v1.z]) {
		translate([-v1.x, -v1.y, -v1.z])
		epaper_part_08([s1.x, s1.y, s1.z, v1[3]]);
	}
}
module epaper_part_09c(p3, s3) {
	color("white")
	translate(p3)
	cube(s3);
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
	echo("epaper_part_09", v);
	v1 = is_undef(v) ? [3, 3, 3, 1] : v[0];
	v2 = is_undef(v) ? [0.4, 1.6, 8, 0.4, 0.4] : v[1];
	v3 = is_undef(v) ? [8, true] : v[2];

	p1 = [v1.x, v1.y, v1.z];
	translate(p1)
	epaper_part_09a(v2, v3);

	s1 = [v1.x * 2 + v3[0] * 2 - v2[0], v2.z + v1.y * 2, v1.z];
	epaper_part_09b(s1, v1);

	//	테스트 막대
	p3 = [s1.x, 0, 0] + [v1.x, 0, 0];
	s3 = [v3[0], v2.z + v1.y * 2, v2.y];
	epaper_part_09c(p3, s3);

	//	구멍 테스트 막대
	p4 = p3 + [s3.x, 0, 0] + [v1.x, -v1.y, 0];
	s4 = [s3.x + v1.x * 1, s3.y + v1.y * 2, s3.z];
	epaper_part_09d(p4, s4, v1, s3);
}

module main() {
	hr();

	v1 = [8, 8, 8, 2];
	v2 = [0.8, 1.6, 8, 0.4, 0.4];
	v3 = [8, true];
	v = [v1, v2, v3];
	epaper_part_09(v);

	hr();
}

main();

/*
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09-8x32x160x80.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09.scad

C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09-4x16x80x4.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09.scad
*/
