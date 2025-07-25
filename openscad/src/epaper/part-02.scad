// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_text.scad>
use <common.scad>

COLOR02 = [0.5, 0.5, 0.1, 0.9];
DEFAULT = [
	["display.panel",								"화면 부품. Display Panel, displayPanel, part02"],
	["display.panel.size",	[170.20, 111.20, 0.91],	"크기, 화면 부품의 크기, sizeDisplayPanel"],
	["active.area.margin",	[5.10, 4.70],			"크기, 화소가 있는 영역, marginActiveArea"],

	["reserved", "끝"]
];
function default02() = DEFAULT;

module epaper_part02(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	sizeDisplayPanel = get(map, "display.panel.size", DEFAULT);
	marginActiveArea = get(map, "active.area.margin", DEFAULT);
	description = str(parent_module(0), "\ndisplay.panel", "\ndisplay.panel.size: ", sizeDisplayPanel, "\nactive.area.margin: ", marginActiveArea);
	//echo(str(parent_module(0)), sizeDisplayPanel, marginActiveArea, description);

	//	Panel
	carve(description, size = 1, rotate = [0, 0, 0], translate = [sizeDisplayPanel.x - 32, 6, sizeDisplayPanel.z], offset = 0.01, preview = !true) {
		color(COLOR02)
		cube(sizeDisplayPanel);
	}
}
module main() {
	epaper_part02();
}

main();
