// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<../common/constants.scad>
use <../common/library_function.scad>
use <../common/library_text.scad>
use <../common/library_cube.scad>
use <../common/utils.scad>

module epaper_display_part_one_of_one(v = ACTIVE_AREA) {
	color([0.5, 0.9, 0], 0.5)
	cube(v);
}
module epaper_display_part_two_of_one(v = OUTLINE) {
	color([0.5, 0.0, 0.9], 0.5)
	cube(v);
}

OUTLINE = [170.20, 111.20, 0.91];
ACTIVE_AREA = [160.00, 96.00];
MARGIN_ONE = [5.10, 4.70];

module epaper_display_part_one() {
	translate([MARGIN_ONE.x, (OUTLINE.y - ACTIVE_AREA.y) - MARGIN_ONE.y, 0])
	epaper_display_part_one_of_one([ACTIVE_AREA.x, ACTIVE_AREA.y, OUTLINE.z]);
	epaper_display_part_two_of_one([OUTLINE.x, OUTLINE.y, OUTLINE.z]);
}

epaper_display_part_one();
