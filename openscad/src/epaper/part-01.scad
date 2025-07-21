// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<common.scad>

// active area
ACTIVE_AREA_COLOR = [0.3, 0.3, 0.9, 0.9];
function PART01() = [
	160.00, 96.00,
	"Active Area"
];

module epaper_part_01(v) {
	echo(str(parent_module(0), "(", v, ")"));

	assert(!is_undef(v));

	s = [v.x, v.y, EPSILON];
	fs = 2;	//	폰트 크기

	color(ACTIVE_AREA_COLOR)
	cube(s);
	
	translate([0, s.y - 8, s.z])
	notate([s.x, fs]);

	translate([s.x - 8, 0, s.z])
	notate([fs, s.y]);

	%translate([s.x / 2, s.y / 2, 0])
	linear_extrude(height = EPSILON) {
		text(str(parent_module(0), v), font = "D2Coding", size = fs, halign = "center");
	}
}
module main() {
	v = PART01();
	epaper_part_01(v);
}

main();
