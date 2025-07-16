// 라이브러리, 검증된 것만 이곳에
use <MCAD/boxes.scad>
include	<../common/constants.scad>
use <../common/library_function.scad>
use <../common/library_text.scad>
use <../common/library_cube.scad>
use <../common/utils.scad>

use <part-01.scad>
use <part-02.scad>
use <part-03.scad>
use <part-04.scad>
use <part-05.scad>

module epaper_display_00() {
	m2 = MARGIN_02();
	m3 = MARGIN_03();

	translate([MARGIN_03().x, MARGIN_03().y * 0, 2.0])
	{
		translate([m2.x, m2.y, 0])
		epaper_display_part_02();
	}

	translate([0, PART_02().y - m3.y, 0])
	epaper_display_part_03();
}

module epaper_display() {
	p5 = PART05();

	translate([-p5.x - 10, 0, 0])
	epaper_part_04();

	//translate([-10, 0, PART04().z + PART05().z])
	//rotate([0, 180, 0])
	epaper_display_part_05();
}

epaper_display();
