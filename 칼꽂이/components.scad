use <landscape.scad>
use <body.scad>

module main() {
	landscapeSize = landscapeSize();
	landscape();

	bodyTopSize = bodyTopSize();
	translate([landscapeSize[0] + 4, 0, 0]) {
		bodyTopFront();
		translate([0, bodyTopSize[2] + 1, 0])	bodyTopSide();
	}
	
	bodyBottomSize = bodyBottomSize();
	translate([landscapeSize[0] + bodyTopSize[0] + 4 * 3, 0, 0]) {
		bodyBottomFront();
		translate([0, bodyBottomSize[2] + 1, 0])	bodyBottomSide();
	}
}

main();