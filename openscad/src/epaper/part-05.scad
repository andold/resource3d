// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
include	<../common/library_text.scad>

use <common.scad>
use <part-01.scad>	//	화소가 있는 영역, activeArea
use <part-02.scad>	//	주요 화면 부품. Display Panel, displayPanel
use <part-04.scad>	//	패널 밑에 받치는 밑판
use <part-06.scad>	//	waveshare epaper 7.3인치 제품. 그룹 of part1, part2, part3
use <part-08.scad>	//	모난 구석이 없는 네모 상자

COLOR = [0.4, 0.6, 0.2, 0.9];
DEFAULT = [
	["upper.panel",					"디스플레이 패널을 덮는 위판, upperPanel"],
	["upper.panel.hight",	1,		"높이 of 디스플레이 패널을 덮는 위판, hightUpperPanel"],
	["upper.panel.radius",	1 / 4,	"모서리 굴곡의 반지름, radiusUpperPanel"],
	
	for (cx = default02()) cx,
	for (cx = default06()) cx,
	for (cx = default04()) cx,

	["reserved", "끝"]
];
function default05() = DEFAULT;

module epaper_part_05c(map = DEFAULT) {
	sizeUnderPanelHill = get(map, "under.panel.hill.size", DEFAULT);	//	언덕의 크기, sizeUnderPanelHill
	marginActiveArea = get(map, "active.area.margin", DEFAULT);	//	여백, 화소가 있는 영역, marginActiveArea
	sizeActiveArea = get(map, "active.area.size", DEFAULT);	//	크기, 화소가 있는 영역, sizeActiveArea
	sizeDisplayPanel = get(map, "display.panel.size", DEFAULT);
	marginDisplayPanel = get(map, "display.panel.margin", DEFAULT);	//	여백, 밑판과 화면 부품 사이의 여유 공간, marginDisplayPanel

	translate([
		sizeUnderPanelHill.x + marginActiveArea.x - marginDisplayPanel.x,
		sizeDisplayPanel.y - sizeActiveArea.y,
		-1
	])
	cube([
		sizeActiveArea.x + marginDisplayPanel.x * 2,
		sizeActiveArea.y + marginDisplayPanel.y * 2,
		100
	]);
}

module epaper_part05(map = DEFAULT) {
//	echo(str(parent_module(0), ".", parent_module(1), "(", map, ")"));

	hightUpperPanel = get(map, "upper.panel.hight", DEFAULT);
	radiusUpperPanel = get(map, "upper.panel.radius", DEFAULT);
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);

	description = str(parent_module(0), "\nsize = ", sizeOutterUnderPanel, "\nradius = ", radiusUpperPanel);

	color(COLOR)
	carve(description, size = 1, translate = [1, 10, hightUpperPanel], offset = 0.01) {
		difference() {
			epaper_part_08([sizeOutterUnderPanel.x, sizeOutterUnderPanel.y, hightUpperPanel, radiusUpperPanel]);
			epaper_part_05c(map);
		}
	}
}

module main() {
	hr();
	epaper_part05();
	hr();
}

main();
