include	<../common/constants.scad>
use	<../common/library_text.scad>
use <common.scad>
use <part-01.scad>
use <part-02.scad>
use <part-03.scad>

DEFAULT = [
	["active.area",								"화소가 있는 영역, activeArea, part01"],
	["active.area.size",	[160.00, 96.00],	"크기, 화소가 있는 영역, sizeActiveArea"],
	["display.panel",								"화면 부품. Display Panel, displayPanel, part02"],
	["display.panel.size",	[170.20, 111.20, 0.91],	"크기, 화면 부품의 크기, sizeDisplayPanel"],
	["active.area.margin",	[5.10, 4.70],			"크기, 화소가 있는 영역, marginActiveArea"],
	["display.connector",			"디스플레이 패널에 붙어있는 커넥터, displayConnector, part03"],
	["display.connector.size",		[25.50, 24.00, 0.1],			"크기, sizeDisplayConnector"],
	["display.connector.margin",	[72.35, 0, 0],					"디스플레이 패널로부터의 상대적인 위치,여백, marginDisplayConnector"],

	["reserved", "끝"]
];

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
