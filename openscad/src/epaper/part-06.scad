include	<../common/constants.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>

//	그룹 of part1, part2, part3
function PART06() = [
	PART02().x, PART02().y + PART03().y, PART02().z
];
function MARGIN06() = [0, -PART03().y, 0];

module epaper_part_06(v) {
	echo(str(parent_module(0), "(", v, ")", HR));

	assert(!is_undef(v));

	sizeActive = v[0];
	sizeDisplay = v[1][0][0];
	margin2 = v[1][0][1];
	sizeConnect = v[2][0];
	margin3 = v[2][1];
	translate([margin2.x, (sizeDisplay.y - sizeActive.y) - margin2.y, sizeDisplay.z])
	epaper_part_01(sizeActive);
	
	epaper_part_02(v[1]);

	translate([margin3.x, -sizeConnect.y, 0])
	epaper_part_03(v[2]);
	
	%
	color("white")
	translate([0, -2.2, 0])
	linear_extrude(height = EPSILON) {
		text(str("⑥ = ①+②+③"), font = "D2Coding", size = 2);
	}
}

module background_06(v) {
	echo(str(parent_module(0), "(", v[0][0], ")", HR));

	assert(!is_undef(v));

}

module main() {
	v = [PART01(), PART02(), PART03()];
	%background_06(v);
	epaper_part_06(v);
}

main();
