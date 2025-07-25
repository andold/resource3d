include	<../common/constants.scad>
use	<../common/library_text.scad>
use <common.scad>

COLOR = [0.4, 0.8, 0.4, 0.5];
DEFAULT = [
	["display.connector",			"디스플레이 패널에 붙어있는 커넥터, displayConnector, part03"],
	["display.connector.size",		[25.50, 24.00, 0.1],			"크기, sizeDisplayConnector"],
	["display.connector.margin",	[72.35, 0, 0],					"디스플레이 패널로부터의 상대적인 위치,여백, marginDisplayConnector"],
	["reserved", "끝"]
];
function default03() = DEFAULT;

module epaper_part03(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	assert(!is_undef(map));

	sizeDisplayConnector = get(map, "display.connector.size", DEFAULT);
	marginDisplayConnector = get(map, "display.connector.margin", DEFAULT);
	description = str(parent_module(0), "\ndisplay.connector", "\ndisplay.connector.size: ", sizeDisplayConnector, "\ndisplay.connector.margin: ", marginDisplayConnector);

	carve(description, size= 0.7, translate = [1, 5, sizeDisplayConnector.z], offset = 0.01) {
		color(COLOR)
		cube(sizeDisplayConnector);
	}
}

module main() {
	epaper_part03();
}

main();
