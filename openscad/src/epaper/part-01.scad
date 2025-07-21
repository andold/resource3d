// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<common.scad>

// active area
ACTIVE_AREA_COLOR = [0.3, 0.3, 0.9, 0.9];
function PART01() = [
	160.00,
	96.00,
	"Active Area 실제 그림이 그려지는 화면 영역, sizeActiveArea"
];

module epaper_part_01() {
	echo(str(parent_module(0), "(", ")"));

	sizeActiveArea = PART01();
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
	epaper_part_01();
}

main();
