// 라이브러리, 검증된 것만 이곳에
include	<../common/constants.scad>
use	<../common/library_function.scad>
use	<../common/library_text.scad>
use <common.scad>
use <collect-default.scad>
use <part-08.scad>	//	모난 구석이 없는 네모 상자

COLOR = [0.4, 0.6, 0.2, 0.9];

DEFAULT = default();

module epaper_part05a(map) {
	hightUpperPanel = get(map, "upper.panel.hight", DEFAULT);
	radiusUpperPanel = get(map, "upper.panel.radius", DEFAULT);	//	not used

		//epaper_part08([sizeOutterUnderPanel.x, sizeOutterUnderPanel.y, hightUpperPanel, radiusUpperPanel]);
	//	모서리 대패 적용해 보자
	radiusUnderPanelCornerPlane = get(map, "under.panel.corner.plane.radius", DEFAULT);	//	모서리 대패의 반경
	sizeOutterUnderPanel = calculateSizeOutterUnderPanel(map, DEFAULT);
	base = [
		sizeOutterUnderPanel.x - radiusUnderPanelCornerPlane * 2,
		sizeOutterUnderPanel.y - radiusUnderPanelCornerPlane * 2,
		hightUpperPanel
	];
	
	$fn = 8;
	intersection() {
		minkowski() {
			translate([radiusUnderPanelCornerPlane, radiusUnderPanelCornerPlane, radiusUnderPanelCornerPlane])
			cube(base);

			sphere(radiusUnderPanelCornerPlane);
		}
		cube([sizeOutterUnderPanel.x, sizeOutterUnderPanel.y, hightUpperPanel]);
	}
}
module epaper_part05c(map = DEFAULT) {
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
	radiusUnderPanelCornerPlane = get(map, "under.panel.corner.plane.radius", DEFAULT);	//	
	
	description = str(parent_module(0),
						"\n hightUpperPanel: ", hightUpperPanel,
						"\n sizeOutterUnderPanel: ", sizeOutterUnderPanel,
						"\n radiusUpperPanel = ", radiusUpperPanel, " not used",
						"\n radiusUnderPanelCornerPlane = ", radiusUnderPanelCornerPlane,
						"");

	color(COLOR)
	carve(description, size = 1, translate = [1, 10, hightUpperPanel], offset = 0.01) {

		difference() {
			epaper_part05a(map);
			epaper_part05c(map);
		}
	}
}

module usage() {
}

module main(command = 0) {
	echo(str("", parent_module(0), "(", command, ")"));
	hr();

	if (command == 0) {
		usage();
	} else if (command == 1) {
		epaper_part05a(DEFAULT);
	} else if (command == 2) {
		epaper_part05c();
	} else if (command == 3) {
		epaper_part05();
	} else if (command == 4) {
	} else if (command == 5) {
	} else {
		echo("NOT SUPPORTED");
	}
	hr();
}

main();

main(is_undef(command) ? 3 : command);
