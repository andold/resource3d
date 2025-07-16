include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>
use <part-06.scad>

//	①②③④⑤⑥⑦⑧⑨ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝ
ID = "④";
SIZE = [0, 0, 2];
PADDING = [3, 3, 1];
PADDING_INNER = [16, 16];	//	밑판 최외곽 너비
MARGIN = [0.5, 0.5, 0.2];
COLOR = [0.8, 0.4, 0.3, 1];

function PART04() = [
	PADDING.x * 2 + MARGIN.x * 2 + PART02().x,
	PADDING.y * 2 + MARGIN.y * 2 + PART02().y,
	SIZE.z + PADDING.z
];
function MARGIN04() = [0, 0, 0];

pNotate = [PART04().x - PADDING_INNER.x - 16, PADDING_INNER.y + 16];

//	밑판
module epaper_display_part_04_01() {
	size = [
		PADDING.x * 2 + MARGIN.x * 2 + PART02().x,
		PADDING.y * 2 + MARGIN.y * 2 + PART02().y,
		SIZE.z
	];

	//	아래쪽
	color(COLOR)
	translate([0, 0, 0])
	cube([size.x, PADDING_INNER.y, size.z]);
	translate([pNotate.x - 2, 0, PART04().z])
	notate([1.5, PADDING.y]);
	translate([pNotate.x - 2, PADDING.y, PART04().z])
	notate([1.5, PADDING_INNER.y - PADDING.y]);
	translate([pNotate.x, 0, PART04().z])
	notate([2, PADDING_INNER.y]);

	//	위쪽
	color(COLOR)
	translate([0, size.y - PADDING_INNER.y, 0])
	cube([size.x, PADDING_INNER.y, size.z]);
	translate([pNotate.x - 2, size.y - PADDING.y, PART04().z])
	notate([1.5, PADDING.y]);
	translate([pNotate.x - 2, size.y - PADDING_INNER.y, PART04().z])
	notate([1.5, PADDING_INNER.y - PADDING.y]);
	translate([pNotate.x, size.y - PADDING_INNER.y, PART04().z])
	notate([2, PADDING_INNER.y]);

	//	가운데
	translate([pNotate.x, PADDING_INNER.y, PART04().z])
	notate([2, PART04().y - PADDING_INNER.y * 2]);
	
	//	왼쪽
	color(COLOR)
	translate([0, PADDING_INNER.y, 0])
	cube([PADDING_INNER.x, size.y - PADDING_INNER.y * 2, size.z]);
	translate([0, pNotate.y + 2, PART04().z])
	notate([PADDING.x, 1.5]);
	translate([PADDING.x, pNotate.y + 2, PART04().z])
	notate([PADDING_INNER.x - PADDING.x, 1.5]);
	translate([0, pNotate.y, PART04().z])
	notate([PADDING_INNER.x, 2]);

	//	오른쪽
	color(COLOR)
	translate([size.x - PADDING_INNER.x, PADDING_INNER.y, 0])
	cube([PADDING_INNER.x, size.y - PADDING_INNER.y * 2, size.z]);
	translate([size.x - PADDING.x, pNotate.y + 2, PART04().z])
	notate([PADDING.x, 1.5]);
	translate([size.x - PADDING_INNER.x, pNotate.y + 2, PART04().z])
	notate([PADDING_INNER.x - PADDING.x, 1.5]);
	translate([size.x - PADDING_INNER.x, pNotate.y, PART04().z])
	notate([PADDING_INNER.x, 2]);

	//	가운데
	translate([PADDING_INNER.x, pNotate.y, PART04().z])
	notate([PART04().x - PADDING_INNER.x * 2, 2]);
	
	//	중앙 가로선
	color(COLOR)
	translate([PADDING_INNER.x, PART04().y / 2 - PADDING_INNER.y / 2, 0])
	cube([size.x - PADDING_INNER.x * 2, PADDING_INNER.y, size.z]);
	translate([pNotate.x - 2, (PART04().y - PADDING_INNER.y) / 2, PART04().z])
	notate([1.5, PADDING_INNER.y]);

	translate([pNotate.x - 2, size.y - PADDING.y, PART04().z])
	notate([1.5, PADDING.y]);

	//	중앙 세로선
	color(COLOR)
	translate([(PART04().x - PADDING_INNER.x) / 2, PADDING_INNER.y, 0])
	cube([PADDING_INNER.x, size.y - PADDING_INNER.y * 2, size.z]);
	translate([(PART04().x - PADDING_INNER.x) / 2, pNotate.y + 2, PART04().z])
	notate([PADDING_INNER.x, 1.5]);
}

module epaper_display_part_04_02() {
	v = PART02();
	s = [
		PADDING.x * 2 + MARGIN.x * 2 + v.x,
		PADDING.y * 2 + MARGIN.y * 2 + v.y,
		PART04().z
	];
	cdelta = 0.1;
	ccolor = [COLOR[0] - cdelta, COLOR[1] - cdelta, COLOR[2] - cdelta, COLOR[3]];

	// 아래
	translate([0, 0, SIZE.z])
	color(ccolor)
	cube([s.x, PADDING.y, PADDING.z]);

	//	아래 왼쪽
	translate([0, -3, 0])
	notate([PADDING.x + MARGIN03().x, 2], up = false);

	//	아래 오른쪽
	translate([PADDING.x + MARGIN03().x + PART03().x + MARGIN.x * 2, -3, 0])
	notate([PADDING.x + MARGIN03().x, 2], str(PADDING.x + MARGIN03().x, "mm"), false);

	//	위
	translate([0, PADDING.y + v.y + MARGIN.y * 2, SIZE.z])
	color(ccolor)
	cube([s.x, PADDING.y, PADDING.z]);

	//	왼쪽
	translate([0, PADDING.y, SIZE.z])
	color(ccolor)
	cube([PADDING.x, s.y - PADDING.y * 2, PADDING.z]);

	//	오른쪽
	translate([PADDING.x + v.x + MARGIN.x * 2, PADDING.y, SIZE.z])
	color(ccolor)
	cube([PADDING.x, s.y - PADDING.y * 2 , PADDING.z]);
}
//	아래쪽에 구멍내는 거, 연결선 빠져 나가는 구멍
module epaper_part_04_03() {
	size = [
		PART03().x + MARGIN.x * 2,
		PADDING.y + MARGIN.y + EPSILON,
		SIZE.z + MARGIN.z + EPSILON];

	translate([0, -EPSILON, -EPSILON])
	cube(size);

	translate([0, -3, -EPSILON])
	notate([size.x, 2]);
}
module background_04() {
	translate([-(PART02().x + PADDING.x + MARGIN.x), PADDING.y + MARGIN.y, 0])
	epaper_part_06();
}

module epaper_part_04() {
	m2 = MARGIN02();
	s3 = PART03();
	s4 = PART04();

	difference() {
		union() {
			epaper_display_part_04_01();
			epaper_display_part_04_02();
		}

		translate([PADDING.x + MARGIN03().x - MARGIN.x * 0, 0, 0])
		epaper_part_04_03();
	}

	%color("white")
	translate([2, PART04().y - 2.3, EPSILON])
	linear_extrude(height = PART04().z) {
		text(str(ID, " Cover: ", PART04().x, " x ", PART04().y, " x ", PART04().z, "mm"), font = "D2Coding", size = 2);
	}
}

module main() {
	%background_04();
	epaper_part_04();
}

main();
