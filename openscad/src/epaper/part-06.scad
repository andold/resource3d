include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>

//	그룹 of part1, part2, part3
function PART06() = [PART02().x, PART02().y + PART03().y, PART02().z];
function MARGIN06() = [0, -PART03().y, 0];

module epaper_part_06() {
	translate([MARGIN02().x, (PART02().y - PART01().y) - MARGIN02().y, PART02().z])
	epaper_part_01();
	
	epaper_part_02();

	translate([MARGIN03().x, -PART03().y, 0])
	epaper_part_03();
	
	%
	color("white")
	translate([0, -2.2, 0])
	linear_extrude(height = EPSILON) {
		text(str("⑥ = ①+②+③"), font = "D2Coding", size = 2);
	}
}

module background_06() {
}

module main() {
	%background_06();
	epaper_part_06();
}

main();
