include	<../common/constants.scad>
use	<../common/library_text.scad>
use <common.scad>
use <collect-default.scad>

COLOR = [0.4, 0.8, 0.4, 0.5];
DEFAULT = default();

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
