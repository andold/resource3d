// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use <common.scad>

function PART02() = [
	[170.20, 111.20, 0.91, "부품의 크기", "sizeDisplayPanel"],
	[5.10, 4.70, "Active Area의 상대적 위치 = 좌상단의 여백", "marginActiveArea"],
	"화면 부품. Display Panel"
];
COLOR02 = [0.5, 0.5, 0.1, 0.9];

module epaper_part_02() {
	echo(str(parent_module(0), "(", ")"));

	p2 = PART02();

	sizeDisplayPanel = [ for (cx = [0:2]) p2[0][cx] ];
	marginActiveArea = p2[1];
	echo(str(parent_module(0)), sizeDisplayPanel, marginActiveArea);

	//	Panel
	color(COLOR02)
	cube(sizeDisplayPanel);

	pNotate = [marginActiveArea.x + - 8, (sizeDisplayPanel.y - 8) - marginActiveArea.y];

	//	왼쪽 테두리
	translate([0, pNotate.y, sizeDisplayPanel.z])
	notate([marginActiveArea.x, 2], str(marginActiveArea.x, "mm"));

	//	오른쪽 테두리
	translate([pNotate.x + 8, pNotate.y, sizeDisplayPanel.z])
	notate([marginActiveArea.x, 2], str(marginActiveArea.x, "mm"));

	//	위쪽 테두리
	translate([pNotate.x, sizeDisplayPanel.y - marginActiveArea.y, sizeDisplayPanel.z])
	notate([2, marginActiveArea.y]);

	//	아래쪽 테두리
	translate([pNotate.x, 0, sizeDisplayPanel.z])
	notate([2, sizeDisplayPanel.y - marginActiveArea.y]);

	fs = 2;
	%translate([sizeDisplayPanel.x / 2, sizeDisplayPanel.y - fs, EPSILON])
	linear_extrude(height = sizeDisplayPanel.z) {
		text(str(parent_module(0), p2[0], p2[2]), font = "D2Coding", size = fs, halign = "center");
	}
}
module main() {
	epaper_part_02();
}

main();
