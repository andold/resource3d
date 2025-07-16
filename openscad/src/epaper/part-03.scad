include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>

function PART03() = [25.50, 24.00, 0.1];
function PADDING03() = [3, 3, 1];
function MARGIN03() = [72.35, 0, 0];

SIZE = [0, 0, 2];
PADDING = [3, 3, 1];
MARGIN = [0.5, 0.5];
COLOR = [0.4, 0.8, 0.4, 0.5];

part01 = PART01();
part02 = PART02();
margin02 = MARGIN02();
part03 = PART03();
part04 = PART04();

function PART04() = [
	PADDING.x * 2 + MARGIN.x * 2 + PART02().x,
	PADDING.y * 2 + MARGIN.y * 2 + PART02().y,
	SIZE.z + PADDING.z
];
function MARGIN04() = [PADDING.x + MARGIN.x, PADDING.y + MARGIN.y, SIZE.z + PADDING.z];

module epaper_part_03() {
	s = PART03();
	m = MARGIN03();
	
	color(COLOR)
	cube(PART03());

	%color("white")
	translate([1, s.y - 4, PART03().z])
	linear_extrude(height = PART03().z + EPSILON) {
		text("3. Connector", size = 2);

		translate([2, -3])
		text(str(s.x, " x ", s.y, " x 0.1", "mm"), size = 2);
	}

	//	가로
	translate([0, 2, PART03().z])
	notate([PART03().x, 2]);
	//	세로
	translate([PART03().x - 4, 0, PART03().z])
	notate([2, PART03().y]);
}

module epaper_display_part_03() {
	s = PART03();
	m = MARGIN03();
	
	translate(m)
	{
		epaper_part_03();
	}
}

module background_03() {
	translate([0, PART03().y, 0])
	epaper_display_part_02();
}

module main() {
	%background_03();
	epaper_display_part_03();
}

epaper_display_part_03();
!epaper_part_03();
