include	<../common/constants.scad>
use <common.scad>
use <part-07.scad>
use <part-08.scad>

//	①②③④⑤⑥⑦⑧⑨ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓄ
//	모난 구석이 없는 네모 상자 + 연결 부속 프로토타입
ID = "⑨";
COLOR = [0.5, 0.4, 0.3, 0.9];

module epaper_part_09a(v) {
	translate([v[0], 0, 0])
	mirror([1, 0, 0])
	epaper_part_07(v);

	translate([v[5] - v[0], 0, 0])
	epaper_part_07(v);

	translate([v[5] * 2 - v[0], 0, 0])
	mirror([1, 0, 0])
	epaper_part_07(v);
}
module epaper_part_09() {
	v1 = [3, 3, 3, 1];
	v2 = [0.4, 1.6, 8, 0.4, 0.4, 8];

	s1 = [v1.x * 2 + v2[5] * 2 - v2[0], v2.z + v1.y * 2, v1.z];
	translate([v1.x, v1.y, v1.z]) {
		translate([-v1.x, -v1.y, -v1.z])
		epaper_part_08([s1.x, s1.y, s1.z, v1[3]]);
		
		translate([0, 0, 0])
		epaper_part_09a(v2);
	}

	//	테스트 막대
	p3 = [s1.x, 0, 0] + [v1.x, 0, 0];
	s3 = [v2[5], v2.z + v1.y * 2, v2.y];
	translate(p3)
	cube(s3);

	//	구멍 테스트 막대
	p4 = p3 + [s3.x, 0, 0] + [v1.x, -v1.y, 0];
	s4 = [s3.x + v1.x * 2, s3.y + v1.y * 2, s3.z];
	HR();
	echo(s4);
	translate(p4)
	difference() {
		epaper_part_08([s4.x, s4.y, s4.z, 0.5]);

		translate([v1.x, v1.y, -0.5])
		cube(s3 + [0, 0, 1]);
	}
}

module main() {
	epaper_part_09();
}

main();

/*
C:\apps\openscad-2021.01\openscad.exe -o C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09-4x16x80x4.stl -D target=0 --export-format asciistl C:\src\eclipse-workspace\resource3d\openscad\src\epaper\part-09.scad
*/
