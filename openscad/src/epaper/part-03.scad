use <part-01.scad>
use <part-02.scad>

SIZE = [0, 0, 2];
PADDING = [3, 3, 1];
MARGIN = [0.5, 0.5];
COLOR = [0.4, 0.8, 0.4, 0.5];

function PART_03() = [
	PADDING.x * 2 + MARGIN.x * 2 + PART_01().x,
	PADDING.y * 2 + MARGIN.y * 2 + PART_01().y,
	SIZE.z + PADDING.z
];
function MARGIN_03() = [PADDING.x + MARGIN.x, PADDING.y + MARGIN.y, SIZE.z + PADDING.z];

module epaper_display_part_03_01() {
	v = PART_01();
	s = [
		PADDING.x * 2 + MARGIN.x * 2 + v.x,
		PADDING.y * 2 + MARGIN.y * 2 + v.y,
		SIZE.z
	];

	color(COLOR)
	cube(s);

	*#translate([PADDING.x + MARGIN.x, PADDING.y + MARGIN.y, s.z])
	epaper_display_part_01();
}

module epaper_display_part_03_02() {
	v = PART_01();
	s = [
		PADDING.x * 2 + MARGIN.x * 2 + v.x,
		PADDING.y * 2 + MARGIN.y * 2 + v.y,
		PART_03().z
	];

	translate([0, 0, SIZE.z])
	color(COLOR)
	cube([PADDING.x + MARGIN_02().x, PADDING.y, PADDING.z]);

	translate([PADDING.x + MARGIN_02().x + PART_02().x + MARGIN.x * 2, 0, SIZE.z])
	color(COLOR)
	cube([PADDING.x + MARGIN_02().x, PADDING.y, PADDING.z]);

	translate([0, PADDING.y + v.y + MARGIN.y * 2, SIZE.z])
	color(COLOR)
	cube([s.x, PADDING.y, PADDING.z]);

	translate([0, 0, SIZE.z])
	color(COLOR)
	cube([PADDING.x, s.y, PADDING.z]);

	translate([PADDING.x + v.x + MARGIN.x * 2, 0, SIZE.z])
	color(COLOR)
	cube([PADDING.x, s.y, PADDING.z]);
}
module epaper_display_part_03() {
	m2 = MARGIN_02();

	*translate([PADDING.x + MARGIN.x + m2.x, m2.y, m2.z])
	epaper_display_part_02();

	epaper_display_part_03_01();
	epaper_display_part_03_02();
}

epaper_display_part_03();
