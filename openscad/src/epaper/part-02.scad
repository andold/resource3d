// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>

function PART02() = [170.20, 111.20, 0.91];
function MARGIN02() = [5.10, 4.70];
COLOR02 = [0.5, 0.5, 0.1, 0.9];

module epaper_part_02() {
	s = PART02();
	m = MARGIN02();

	//	Panel
	color(COLOR02)
	cube(s);

	pNotate = [m.x + PART01().x - 8, (s.y - 8) - m.y];

	//	왼쪽 테두리
	translate([0, pNotate.y, PART02().z])
	notate([MARGIN02().x, 2], str(MARGIN02().x, "mm"));

	//	오른쪽 테두리
	translate([pNotate.x + 8, pNotate.y, PART02().z])
	notate([MARGIN02().x, 2], str(MARGIN02().x, "mm"));

	//	위쪽 테두리
	translate([pNotate.x, PART02().y - MARGIN02().y, PART02().z])
	notate([2, MARGIN02().y]);

	//	아래쪽 테두리
	translate([pNotate.x, 0, PART02().z])
	notate([2, PART02().y - PART01().y - MARGIN02().y]);

	%translate([2, s.y - 4, EPSILON])
	color("black")
	linear_extrude(height = s.z) {
		text(str("2. Panel: (", s.x, " x ", s.y, " x ", s.z, "mm), "), size = 2);
	}
}
module epaper_display_part_02() {
	s = PART02();
	m = MARGIN02();

	//	Active Area
	translate([m.x, (s.y - PART01().y) - m.y, s.z])
	epaper_display_part_01();

	epaper_part_02();
}

epaper_display_part_02();
!epaper_part_02();
