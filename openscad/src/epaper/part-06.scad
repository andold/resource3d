include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use <common.scad>
use <collect-default.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>

DEFAULT = default();

//	waveshare epaper 7.3인치 제품. 그룹 of part1, part2, part3

module epaper_part06(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	assert(!is_undef(map));

	sizeActiveArea = get(map, "active.area.size", DEFAULT);
	marginActiveArea = get(map, "active.area.margin", DEFAULT);
	sizeDisplayPanel = get(map, "display.panel.size", DEFAULT);
	sizeDisplayConnector = get(map, "display.connector.size", DEFAULT);
	marginDisplayConnector = get(map, "display.connector.margin", DEFAULT);

	translate([marginActiveArea.x, sizeDisplayPanel.y - sizeActiveArea.y - marginActiveArea.y, sizeDisplayPanel.z])
	epaper_part01(map);
	
	epaper_part02(map);

	translate([marginDisplayConnector.x, -sizeDisplayConnector.y, 0])
	epaper_part03(map);
	
}

module main() {
	epaper_part06();
}

main();
