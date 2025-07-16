// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<common.scad>

// active area
ACTIVE_AREA_COLOR = [0.3, 0.3, 0.9, 0.9];
function PART01() = [160.00, 96.00, EPSILON];

module epaper_part_01() {
	s = PART01();

	color(ACTIVE_AREA_COLOR)
	cube(s);
	
	translate([0, s.y - 8, s.z])
	notate([s.x, 2]);

	translate([s.x - 8, 0, s.z])
	notate([2, s.y]);

	%translate([2, s.y - 4, EPSILON * 2])
	linear_extrude(height = s.z) {
		text(str("1. Active Area: ", s.x, " x ", s.y, "mm"), font = "D2Coding", size = 2);
	}
}
module epaper_display_part_01() {
	epaper_part_01();
}

epaper_display_part_01();
