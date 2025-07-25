// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_text.scad>
use	<common.scad>

// 화소가 있는 영역, activeArea
ACTIVE_AREA_COLOR = [0.3, 0.3, 0.9, 0.9];
DEFAULT = [
	["active.area",								"화소가 있는 영역, activeArea"],
	["active.area.size",	[160.00, 96.00],	"크기, 화소가 있는 영역, sizeActiveArea"],
	["reserved", "끝"]
];
function default01() = DEFAULT;

module epaper_part01(map = DEFAULT) {
	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	sizeActiveArea = get(map, "active.area.size", DEFAULT);

	size = [sizeActiveArea.x, sizeActiveArea.y, EPSILON];
	fs = 2;	//	폰트 크기

	color(ACTIVE_AREA_COLOR)
	cube(size);
	
	translate([0, size.y - 8, size.z])
	notate([size.x, fs]);

	translate([size.x - 8, 0, size.z])
	notate([fs, size.y]);

	%translate([size.x / 2, size.y / 2, 0])
	linear_extrude(height = EPSILON) {
		text(str(parent_module(0), sizeActiveArea), font = "D2Coding", size = fs, halign = "center");
	}
}
module main() {
	epaper_part01();
}

main();
