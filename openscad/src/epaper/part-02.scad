// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>

function PART02() = concat([[
		[170.20, 111.20, 0.91],
		[5.10, 4.70],
		"Display Panel"
	],
	PART01()
]);
COLOR02 = [0.5, 0.5, 0.1, 0.9];

module epaper_part_02(v) {
	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));

	s = [ for (cx = [0:2]) v[0][0][cx] ];
	m = v[0][1];
	p1 = v[1];
	echo(str(parent_module(0)), s, m, p1);

	//	Panel
	color(COLOR02)
	cube(s);

	pNotate = [m.x + p1.x - 8, (s.y - 8) - m.y];

	//	왼쪽 테두리
	translate([0, pNotate.y, s.z])
	notate([m.x, 2], str(m.x, "mm"));

	//	오른쪽 테두리
	translate([pNotate.x + 8, pNotate.y, s.z])
	notate([m.x, 2], str(m.x, "mm"));

	//	위쪽 테두리
	translate([pNotate.x, s.y - m.y, s.z])
	notate([2, m.y]);

	//	아래쪽 테두리
	translate([pNotate.x, 0, s.z])
	notate([2, s.y - p1.y - m.y]);

	fs = 2;
	%translate([s.x / 2, s.y - fs, EPSILON])
	linear_extrude(height = s.z) {
		text(str(parent_module(0), v[0]), font = "D2Coding", size = fs, halign = "center");
	}
}
module background02(v) {
	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));
	s = v[0][0];
	m = v[0][1];
	p1 = v[1];

	//	Active Area
	translate([m.x, (s.y - p1.y) - m.y, s.z])
	epaper_part_01(p1);

}
module main() {
	v = PART02();
	
	background02(v);
	epaper_part_02(v);
}

main();
